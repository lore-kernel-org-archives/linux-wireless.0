Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49263 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZLUSqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 13:46:39 -0500
Received: by iwn1 with SMTP id 1so3883009iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 10:46:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091221113602.50579359.undefined@pobox.com>
References: <20091221113602.50579359.undefined@pobox.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Dec 2009 10:46:18 -0800
Message-ID: <43e72e890912211046h49d93cb4r49a2b3aef452b29a@mail.gmail.com>
Subject: Re: Compat-wireless releases for 2.6.33-rc1 and 2.6.32.2
To: Corey Wright <undefined@pobox.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2009 at 9:36 AM, Corey Wright <undefined@pobox.com> wrote:
> (my apologies to those with thread-aware mail user agents as this is not a
> true reply as i'm not subscribed to linux-wireless, but copied from
> marc.info's raw message display.)
>
>> If there are any bugs please report them
>> through linux-wireless.
>
>> I've tested ath5k on 2.6.27.41 on x86_64 and
>> send this e-mail out through it.
>
>> While at it 2.6.32.2 got released today so I just updated a release
>> for that so users can benefit from the few fixes [3], you can check
>> the ChangeLog for that on the wireless for details on the changes [4].
>
> i tested ath5k from compat-wireless-2.6.32 on 2.6.27.41 and from
> compat-wireless-2.6.32.2 on 2.6.27.42 and i needed this patch [1]
> to avoid duplicate ieee80211_rx symbol in ieee80211 (from kernel) &
> mac80211 (from compat-wireless).
>
> [1] http://patchwork.kernel.org/patch/54569/
>
> i see that the patch was applied to compat-wireless-2.6.33-rc1, but i
> wonder if it should be backported to the 2.6.32.2 release.

I'll suck it in, thanks for the report.

> actually, i have no personal stake in the fix as after i got it to work i
> learned that the new release is not compatible with my older distro-provided
> user-land (doesn't recognize it as wireless),

Old userspace should not bust. If you find what the issue was let us
know. AFAICT old userspace tend to look for 3 possible things to see
if a device is a wireless device.

  1) Wireless-tools requires SIOCGIWRANGE
  2) Network manager requires SIOCGIWNAME
  3) Linux hald < 0.5.12 used to use check the existance of
/sys/class/net/<interface>/wireless/

The only one I can think of your userspace might have an issue with is
the last one but even then you should get this if you have
CONFIG_WIRELESS_EXT_SYSFS=y on 2.6.27.41

> which i don't feel like
> upgrading/self-maintaining and possibly descending into dependency-hell, so
> i'm sticking with compat-wireless-2.6.30 (compat-wireless-2.6.31-rc7 release
> didn't seem to work as well as 2.6.30), but thought the finding might be of
> interest to others (possibly stumbling upon this searching for
> "compat-wireless-2.6.32 ieee80211_rx ieee80211 mac80211 duplicate symbol"
> or something similar).
>
> thanks for compat-wireless!

Thanks for reporting your issue.

  Luis
