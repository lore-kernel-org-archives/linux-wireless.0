Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:41588 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZLaOXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2009 09:23:36 -0500
Received: by fxm25 with SMTP id 25so6705949fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2009 06:23:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091230011755.4320783d.undefined@pobox.com>
References: <20091221113602.50579359.undefined@pobox.com>
	 <43e72e890912211046h49d93cb4r49a2b3aef452b29a@mail.gmail.com>
	 <20091230011755.4320783d.undefined@pobox.com>
Date: Thu, 31 Dec 2009 14:23:34 +0000
Message-ID: <3ace41890912310623y6021e345gf5e0b2474341e7c4@mail.gmail.com>
Subject: Re: compat-wireless, 2.6.27, & old hal (was Re: Compat-wireless
	releases for 2.6.33-rc1 and 2.6.32.2)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Corey Wright <undefined@pobox.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 30, 2009 at 7:17 AM, Corey Wright <undefined@pobox.com> wrote:
> On Mon, 21 Dec 2009 10:46:18 -0800
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>
>> > actually, i have no personal stake in the fix as after i got it to work
>> > i learned that the new release is not compatible with my older
>> > distro-provided user-land (doesn't recognize it as wireless),
>>
>> Old userspace should not bust. If you find what the issue was let us
>> know. AFAICT old userspace tend to look for 3 possible things to see
>> if a device is a wireless device.
>>
>>   1) Wireless-tools requires SIOCGIWRANGE
>>   2) Network manager requires SIOCGIWNAME
>>   3) Linux hald < 0.5.12 used to use check the existance of
>> /sys/class/net/<interface>/wireless/
>>
>> The only one I can think of your userspace might have an issue with is
>> the last one but even then you should get this if you have
>> CONFIG_WIRELESS_EXT_SYSFS=y on 2.6.27.41
>
> the primary differences between compat-wireless 2.6.30 & 2.6.32.2 ath5k on
> 2.6.27.42 (by observation of the resulting environment) is the older
> version creates a corresponding wmaster0 interface and the wlan0 sysfs
> entry has a wireless directory (ie /sys/class/net/wlan0/wireless).
>
> hal is version 0.5.11rc2 (from "hald --version") and indeed does not
> recognize wlan0 as 802.11, but instead 802.03 (from "hal-device").
>
> without digging into the hal source (though i guess i could simply strace
> it and see if it tests for the wireless subdirectory), it appears your idea
> was correct, but i have CONFIG_WIRELESS_EXT_SYSFS=y.
>
> from my 2.6.27.42 .config (which i compiled & ran both compat-wireless
> versions against):
> #
> # Wireless
> #
> CONFIG_CFG80211=m
> CONFIG_NL80211=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WIRELESS_EXT_SYSFS=y
> CONFIG_MAC80211=m
>
> if you have any other ideas, patches, etc, then i'll try them.  or tell me
> that hal < 0.5.12 is unsupported and i'll stick with compat-wireless-2.6.30.
>
> for the record: wireless-tools (iwconfig) recognizes wlan0 as "IEEE
> 802.11bg" with both compat-wireless versions and NetworkManager only used
> SIOC[SG]IW* ioctl requests (eg ESSID, MODE) with the older version (as seen
> by strace), so i figure hal reported wlan0 as 802.03 and NetworkManager
> believed it (never trying wireless ioctl requests).
>
> thanks for your work (going all the way back to prism54)!
>
> corey
> --
> undefined@pobox.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Having looked at hal source a bit, I think it doesn't do much more
than monitoring things going on in /sys -
most of the device probing code is in hal/hald/linux/device.c, if that
helps. hal is not big and not too difficult to find your way around.

wmaster is on its way out, I think.
