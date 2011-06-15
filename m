Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16202 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab1FOWYX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 18:24:23 -0400
Received: from mj.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by smtprelay1.cesmail.net (Postfix) with ESMTPSA id D61A334C9A
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 18:26:08 -0400 (EDT)
Message-ID: <4DF93116.700@gnu.org> (sfid-20110616_002427_837613_AD841361)
Date: Wed, 15 Jun 2011 18:24:22 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k WDS panic without CONFIG_ATH9K_RATE_CONTROL
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm trying to implement WDS support in ath5k, but I have found that the 
kernel would panic when I bring the interface up:

modprobe ath5k
iwconfig wlan0 mode repeater
iw dev wlan0 set peer 00:01:02:03:04:05
ifconfig wlan0 up

There are many stack traces, but the first one comes from WARN_ON in 
rate_lowest_index().  I think it should really be BUG_ON (patch 
submitted separately), as returning an invalid index will surely lead to 
memory corruption.

I tried WDS with ath9k and found that it doesn't crash the kernel if 
CONFIG_ATH9K_RATE_CONTROL is set.  However, if that setting is off in 
.config, I would get the same crash.

It appears that rate_control_rate_init() is called in 
ieee80211_do_open() too early.  I think there should be some set on the 
rates assumed to be available on the WDS link for the given channel.

Alternatively, the WDS interface should not be able to emit packets 
until either the rates are set manually with iw or they come from a 
beacon send by the peer.  The rate control algorithms should be able to 
deal with it.

-- 
Regards,
Pavel Roskin
