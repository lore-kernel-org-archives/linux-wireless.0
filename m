Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50138 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab0KPTYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 14:24:24 -0500
Received: by qwh6 with SMTP id 6so864981qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 11:24:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDC4480.8050206@openwrt.org>
References: <AANLkTikjg+jY6XYhJjRPydwveW0xr+8tLv-Oypsks4ay@mail.gmail.com>
	<AANLkTimVEm7=c-fof_niToJqy1t+C5fk_JYH_=x1+p5r@mail.gmail.com>
	<4CDC4480.8050206@openwrt.org>
Date: Tue, 16 Nov 2010 14:24:23 -0500
Message-ID: <AANLkTimKuEako8VahvNSP0q59DPXppcuQ_bedpTaWDcb@mail.gmail.com>
Subject: Re: ath9k max_power question
From: Mark Mentovai <mark@moxienet.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> On 2010-11-11 8:22 PM, Luis R. Rodriguez wrote:
> > The values are just some safe value to use as defaults but will
> > quickly be replaced by the max regulatory allowed and then upon
> > further inspection also capped to the lower value of the regulatory
> > limit, the max allowed device limit (where things start becoming
> > unreliable), and the CTL indexed limit which is calibrated
> > specifically for the card you use, so this will vary. You can read
> > more about it here:
> >
> > http://wireless.kernel.org/en/users/Drivers/ath
>
> That should have already been taken care of by this commit (w-t):
>
> commit 6cdd07721180145b7ef46bd63f1eee636983f0e6
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Wed Oct 20 02:09:46 2010 +0200
>
> ath9k: initialize per-channel tx power limits instead of hardcoding them

I see. Now that some of the more important regulatory bugs with
multiple cards are more under control, and with your and Luis’
explanations, I took another look at all of this.

The CTL capping is working properly when it comes to actually setting
txpower, but as far as the maximum allowable values are concerned
(ieee80211_channel’s max_power or orig_mpwr), only the regulatory
value is being used, which may be higher than the CTL limit.  It
certainly doesn’t help me that I can set txpower to 30dBm (the
regulatory limit) on 5825MHz when nothing over 21dBm (the CTL limit)
will actually transmit any louder, and frankly, it scares me when I
see iwconfig reporting 30dBm because I know that if it really were
shouting that loudly, it’d be close to toasting itself. After reading
the code I’m convinced that it won’t actually toast itself, but
reporting 30dBm back to userland is freaky.

ath9k_init_txpower_limits is only called once (hence the “init”) from
ath9k_init_device. Any changes that it makes to a channel’s max_power
will be overwritten by subsequent operation of the regulatory
machinery. At the very least, the subsequent regulatory_hint call in
ath9k_init_device will trigger this work; it will happen at an
unspecified point in the future due to CRDA’s asynchronous nature, but
it will generally happen “soon.” This renders
ath9k_init_txpower_limits’ work ineffective.

I think that the point of ath9k_init_txpower_limits was to make
max_power more useful, but as things stand now, max_power is still set
to the regulatory value as was the case before. I don’t think that
this is what was intended. I would find it more useful if at each
regulatory change, each channel’s max_power was set to
min(regulatory_max_power, ctl_max_power).

The only time that ath9k_init_txpower_limits appears to have close to
the intended effect is with the OpenWrt ATH_USER_REGD option, which
bypasses some of the regulatory machinery. While ATH_USER_REGD may
have its purpose, I don’t think that this feature should cater to that
option, and I don’t think that the behavior of setting max_power to
regulatory_max_power outright or to min(regulatory_max_power,
ctl_max_power) should be dependent on that option. I’m not using
ATH_USER_REGD, the mainstream won’t use it, and it’d be nice to wean
others off it.

I propose making ath9k_reg_notifier set each channel’s max_power to
min(regulatory_max_power, ctl_max_power), although I’m a little wary
of using ath9k_hw_set_txpowerlimit, even with the test flag, after
driver initialization. The interface as it stands now would require
touching ah->curchan from within the notifier, and I’m not convinced
that’s safe or smart. I’m also concerned about dependencies on
chan->chanmode and ah->txchainmask. In fact, as things stand now, I
fall into the “invalid chainmask configuration” block when
ath9k_init_device calls ath9k_init_txpower_limits because txchainmask
is 0. Maybe 0 is fine to just compute ctl_max_power, but it seems that
if this is to be done from ath9k_reg_notifier, it should be made more
deterministic.

If these concerns are valid, I think that what’s truly needed is a
refactoring to provide an EEPROM routine that gets the CTL power limit
for a channel given a caller-supplied channel, chanmode, txchainmask,
and anything else in ah that really shouldn’t be modified or relied
upon for this purpose. Does this sound like the right approach? Is
anyone already working on this?
