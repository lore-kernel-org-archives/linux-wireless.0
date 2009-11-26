Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:53729 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbZKZR0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 12:26:04 -0500
Received: from 8an.javor.praha12.czf (8an.javor.praha12.czf [10.27.67.2])
	by parez.praha12.net (Postfix) with ESMTPS id BC609EDCF5
	for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 18:26:08 +0100 (CET)
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
Date: Thu, 26 Nov 2009 18:26:08 +0100
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [RFC] API for setting ACK timeout
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911261826.08576.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we discussed this in ath5k-devel, but it involves a mac80211 extension, so I'm 
bringing it here.

Although Wi-Fi was designed for outdoor use, it's also sometimes used for long 
distance outdoor links. However, long distance links require longer ACK 
timeout, as packets travel "only" at the speed of light and every kilometer 
adds almost 7 microseconds to the roundtrip. So for a driver to be usable 
outdoors it has to permit setting ACK timeout from userspace.

Currently this is supported only by out-of-tree Madwifi driver for Atheros 
hardware. However, modification of ACK timeout is not an Atheros specific 
feature. According to a quick skim over the source code in 
drivers/net/wireless, besides ath5k and ath9k it's at least supported by 
rt2x00, rtl818x and maybe zd1211.

I think the current hardware support is sufficient for a generic mac80211 
solution. The exact interpretation of ACK timeout value is hardware specific, 
so I propose a higher level API operating with link distance.

It consists of a new nl80211 parameter:
[NL80211_ATTR_WIPHY_DISTANCE] = { .type = NLA_U32 },

The value of the parameter would be a link distance in meters, so after the 
support is added to iw one could set the ACK timeout on a 3km link using:
# iw phy0 set distance 3000

Another required change would be extending cfg80211_ops by functions 
set_distance and get_distance. Calculation of appropriate ACK timeout (and in 
the case of ath5k, also CTS timeout and slottime) for the distance would be 
left to the driver (it's a trivial formula).

I can prepare the patches, if you think these extension would be acceptable. 
Suggestions are welcome.

Lukas Turek
