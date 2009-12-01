Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59589 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZLAHoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 02:44:32 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NFNPY-0002FN-Nd
	for linux-wireless@vger.kernel.org; Tue, 01 Dec 2009 08:44:36 +0100
Received: from 82-100-4-37.net.maiva.cz ([82.100.3.6])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 08:44:36 +0100
Received: from puferd by 82-100-4-37.net.maiva.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 08:44:36 +0100
To: linux-wireless@vger.kernel.org
From: David Pufer <puferd@seznam.cz>
Subject: Re: [RFC] API for setting ACK timeout
Date: Tue, 1 Dec 2009 07:44:11 +0000 (UTC)
Message-ID: <loom.20091201T082140-326@post.gmane.org>
References: <200911261826.08576.8an@praha12.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lukáš Turek <8an@...> writes:

> 
> Hi,
> 
> we discussed this in ath5k-devel, but it involves a mac80211 extension, so I'm 
> bringing it here.
> 
> Although Wi-Fi was designed for outdoor use, it's also sometimes used for long 
> distance outdoor links. However, long distance links require longer ACK 
> timeout, as packets travel "only" at the speed of light and every kilometer 
> adds almost 7 microseconds to the roundtrip. So for a driver to be usable 
> outdoors it has to permit setting ACK timeout from userspace.
> 
> Currently this is supported only by out-of-tree Madwifi driver for Atheros 
> hardware. However, modification of ACK timeout is not an Atheros specific 
> feature. According to a quick skim over the source code in 
> drivers/net/wireless, besides ath5k and ath9k it's at least supported by 
> rt2x00, rtl818x and maybe zd1211.
> 
> I think the current hardware support is sufficient for a generic mac80211 
> solution. The exact interpretation of ACK timeout value is hardware specific, 
> so I propose a higher level API operating with link distance.
> 
> It consists of a new nl80211 parameter:
> [NL80211_ATTR_WIPHY_DISTANCE] = { .type = NLA_U32 },
> 
> The value of the parameter would be a link distance in meters, so after the 
> support is added to iw one could set the ACK timeout on a 3km link using:
> # iw phy0 set distance 3000
> 
> Another required change would be extending cfg80211_ops by functions 
> set_distance and get_distance. Calculation of appropriate ACK timeout (and in 
> the case of ath5k, also CTS timeout and slottime) for the distance would be 
> left to the driver (it's a trivial formula).
> 
> I can prepare the patches, if you think these extension would be acceptable. 
> Suggestions are welcome.
> 
> Lukas Turek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
Hi list,
for more advanced devices such as Atheros multiband multiantenna radios more
additional settings should be available than 80211 driver permits. While talking
about Atheros devices and their use in different environments, not only ACK
timeouts and slottime are concern but also ACK rate, interference mitigation
settins, antenna diversity, antenna mode, calibration interval, LED settings and
more. Therefore, concurrently maintained drivers for Atheros devices
(Madwifi-project, OpenWRT Madwifi driver) are far more usable and tunable in
different environments than ath5k with nl80211. I think, based the ath5k list,
the simplest way would be exporting such device-specific special settings into
procfs or sysfs like Madwifi driver (/proc/sys/dev/wlanX/setting_knob). Then
setting of a special parameter would be simple sysctl or echoing a value into a
file in /proc.. 80211 layer should perform its primary job (e.g. beaconing,
authentication..) and don't care of setting device-specific parameters.
Regards
David Pufer



