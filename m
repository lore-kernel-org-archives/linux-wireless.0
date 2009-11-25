Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:14613 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602AbZKYIlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 03:41:23 -0500
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id E322F148005
	for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 09:41:28 +0100 (CET)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UzM51o9TJNXT for <linux-wireless@vger.kernel.org>;
	Wed, 25 Nov 2009 09:41:28 +0100 (CET)
Received: from lin01.mn-solutions.de (pD95FA5E7.dip0.t-ipconnect.de [217.95.165.231])
	by mx51.mymxserver.com (Postfix) with ESMTP id 866ED148010
	for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 09:41:28 +0100 (CET)
Received: from schurig.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 17CB71E004F
	for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 09:41:15 +0100 (CET)
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: PROPOSAL: cfg80211 antenna selection
Date: Wed, 25 Nov 2009 09:41:10 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911250941.10929.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I just wondered how we can do the antenna and diversity
selection.

Assumption: 32 antennas are enought



My current idea is this:

 struct cfg80211_ops {
+int (*set_antennas)(struct wiphy *wiphy, struct net_device *dev,
+                    u32 rx_antenna_mask, u32 tx_antenna_mask);
+int (*get_antennas)(struct wiphy *wiphy, struct net_device *dev,
+                    u32 *rx_antenna_mask, u32 tx_antenna_mask);
 }

 struct wiphy {
+u8 max_antennas;
 }

wiphy->max_antennas will just be used by user-space to query the 
driver capability, e.g. in "iw list".


A driver must have wiphy->max_antennas && ops->set/get_antennas
set in order to have antenna-selection. xx_antenna_mask is a 
bitfield, where the active bits denote which antenna to use.

When more than one bits are set in tx_antenna_mask, the driver 
may use diversity. This means that my proposal doesn't support 
diffentiating between diversity and sending the same frame 
throught several anteannas at the same time. Not sure if this is 
a short-coming, e.g. if there's a use-case behind this or not.

Another thing I'm not sure is if we really need rx_antenna_mask. 
it would allow us to receive with one antenna, but send with 
another one. Is this over-design or a real use-case?


If a driver doesn't support diversity, the driver simply returns 
an error if more than one bit is set in the mask.


For iw, I'd then be able to do:

iw wlan0 get antennas
iw wlan0 set antenna 0 1         (set both tx/rx antenna mask)
iw wlan0 set antenna tx 0 rx 1


-- 
http://www.holgerschurig.de
