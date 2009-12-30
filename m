Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:50645 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZL3HR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 02:17:59 -0500
Received: from sasl.smtp.pobox.com (unknown [127.0.0.1])
	by a-pb-sasl-sd.pobox.com (Postfix) with ESMTP id 27B85ABAB4
	for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 02:17:58 -0500 (EST)
Received: from a-pb-sasl-sd.pobox.com (unknown [127.0.0.1])
	by a-pb-sasl-sd.pobox.com (Postfix) with ESMTP id 25132ABAB3
	for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 02:17:58 -0500 (EST)
Received: from deuteronomy.jumbo (unknown [68.93.99.187]) (using TLSv1 with
 cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client certificate requested)
 by a-pb-sasl-sd.pobox.com (Postfix) with ESMTPSA id B2968ABAB2 for
 <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 02:17:57 -0500 (EST)
Date: Wed, 30 Dec 2009 01:17:55 -0600
From: Corey Wright <undefined@pobox.com>
To: linux-wireless@vger.kernel.org
Subject: compat-wireless, 2.6.27, & old hal (was Re: Compat-wireless releases
 for 2.6.33-rc1 and 2.6.32.2)
Message-Id: <20091230011755.4320783d.undefined@pobox.com>
In-Reply-To: <43e72e890912211046h49d93cb4r49a2b3aef452b29a@mail.gmail.com>
References: <20091221113602.50579359.undefined@pobox.com>
 <43e72e890912211046h49d93cb4r49a2b3aef452b29a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Dec 2009 10:46:18 -0800
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> > actually, i have no personal stake in the fix as after i got it to work
> > i learned that the new release is not compatible with my older
> > distro-provided user-land (doesn't recognize it as wireless),
> 
> Old userspace should not bust. If you find what the issue was let us
> know. AFAICT old userspace tend to look for 3 possible things to see
> if a device is a wireless device.
> 
>   1) Wireless-tools requires SIOCGIWRANGE
>   2) Network manager requires SIOCGIWNAME
>   3) Linux hald < 0.5.12 used to use check the existance of
> /sys/class/net/<interface>/wireless/
> 
> The only one I can think of your userspace might have an issue with is
> the last one but even then you should get this if you have
> CONFIG_WIRELESS_EXT_SYSFS=y on 2.6.27.41

the primary differences between compat-wireless 2.6.30 & 2.6.32.2 ath5k on
2.6.27.42 (by observation of the resulting environment) is the older
version creates a corresponding wmaster0 interface and the wlan0 sysfs
entry has a wireless directory (ie /sys/class/net/wlan0/wireless).

hal is version 0.5.11rc2 (from "hald --version") and indeed does not
recognize wlan0 as 802.11, but instead 802.03 (from "hal-device").

without digging into the hal source (though i guess i could simply strace
it and see if it tests for the wireless subdirectory), it appears your idea
was correct, but i have CONFIG_WIRELESS_EXT_SYSFS=y.

from my 2.6.27.42 .config (which i compiled & ran both compat-wireless
versions against):
#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

if you have any other ideas, patches, etc, then i'll try them.  or tell me
that hal < 0.5.12 is unsupported and i'll stick with compat-wireless-2.6.30.

for the record: wireless-tools (iwconfig) recognizes wlan0 as "IEEE
802.11bg" with both compat-wireless versions and NetworkManager only used
SIOC[SG]IW* ioctl requests (eg ESSID, MODE) with the older version (as seen
by strace), so i figure hal reported wlan0 as 802.03 and NetworkManager
believed it (never trying wireless ioctl requests).

thanks for your work (going all the way back to prism54)!

corey
-- 
undefined@pobox.com
