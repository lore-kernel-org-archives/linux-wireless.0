Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:35712 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZI3TEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 15:04:55 -0400
Received: by iwn8 with SMTP id 8so3828088iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 12:04:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d355d36c0909301116l5b6f05f2s4834a47142810a54@mail.gmail.com>
References: <d355d36c0909300814w302f11a4rb5b23a80aee36c43@mail.gmail.com>
	<20090930164853.GA5730@mosca> <d355d36c0909301116l5b6f05f2s4834a47142810a54@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 30 Sep 2009 12:04:37 -0700
Message-ID: <43e72e890909301204m4712b2ebre377d362f3c98a50@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible to set MCS Index?
To: Matt Tierney <matt.tierney@post.harvard.edu>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 11:16 AM, Matt Tierney
<matt.tierney@post.harvard.edu> wrote:
>
>> mac80211 rate control code is MCS rate unaware, but we do at least
>> let drivers pass the MCS rate for tx status reporting. ath9k
>> unfortunately reports back the wrong MCS rate though because
>> of the way ath9k rate control works...
>
> Hm. I'm confused. I realize iw and the ath9k driver might be separate
> entities, but it seemed like iw was corroborating ath9k debug output with my
> setup. /sys/kernel/debug/ath9k/phy0/rcstat showed that one packet was
> successfully sent at the maximum rate possible with MCS Index 12 (162 Mbps)
> and index 12 seems to have that 1 bit flipped as the highest index in the
> "HT MCS Set" I copied in my `iw list` printout; albeit, that was one packet
> successfully sent compared to 1261 at 81.5 Mbps and 254 at 54 Mbps. Anyway,
> I thought that the HT MCS Set indicated the correct values (as seen in the
> ath9k rcstat) but I think you're saying it might not  =(

No, ath9k debugfs rcstat is fine. What we do not set properly for
mac80211 is the rx status bit rate for MCS rates, this means iw
station dump thing won't give you the right MCS rate.

> Is there a way for me to capture the MCS rate info sent from the driver for
> my own debugging view then? (It's not clear to me which ath9k debug bits to
> set in order to get that information when I modprobe ath9k, if there is a
> set that would give me that information).

You were using the right thing for now:

http://wireless.kernel.org/en/users/Drivers/ath9k/debug#rcstat

>> The first step then is to make mac80211 rate controle code MCS
>> aware and adding MCS rate control support to minstrel, for example.
>>
>> For ath9k it'd be nice to fix the rate control code to be able
>> to report the right MCS index, I really am not sure how involved
>> that is as I've tried to stay away from the rate control code.
>
> I see - this is messier than I anticipated... So, is what I'm trying to do
> (set MCS tx rates) something that I should examine in mac80211 code or is
> ath9k the place to be? (I'm not familiar with how all the pieces of ath9k,
> mac80211, nl80211, cfg80211, etc fit together so that's all contributing to
> my confusion...)

Try to work on a debugfs way to do this first. Something like:

echo 15 >  /sys/kernel/debug/ath9k/phy0/mcs-rate

To set MCS 15 statically.

>> A good step would be to get ath9k rate control to be switchable
>> to minstrel, for example. This can be done as a module parameter
>> to start but eventually I think it'd be nice to be able to switch
>> through iw on any given device. That would require quite a lot of
>> work though.
>
> Any suggestions on how to start thinking about this? Are there examples in
> the ath9k code of making this sort of adaptation?

As I said above, the easy way would be through debugfs. The nice thing
about debugfs is we can remove it at will later.

>> Once mac80211 is MCS rate control aware the next step would be to
>> add a commands to set an MCS rate.
>>
>> The cheesy and quick way to this for ath9k would be through
>> ath9k/debufs.c
>
> Would this be able to actually set an MCS rate though?

Why not?

> I thought that
> debug.c was composed of 'read-only' features.

Nope, you can echo to wiphy file to add a new virtual wiphy for
example, or to the debug file to change the debug level on demand. Hm,
I guess no one reads documentation or we need to really work harder on
promoting our wireless wiki.

> If it is possible, then this
> is the quick and dirty fix I'd like to use now,

Go for it.

  Luis
