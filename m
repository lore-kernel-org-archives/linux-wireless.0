Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58242 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3IRUrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 16:47:06 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so3732717ead.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 13:47:04 -0700 (PDT)
From: Detlev Casanova <detlev.casanova@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	laurent.pinchart@ideasonboard.com
Subject: NetworkManager not listing access points
Date: Wed, 18 Sep 2013 22:47:15 +0200
Message-ID: <31357461.i5mG9q5IfA@naboo> (sfid-20130918_224710_281230_E69528DB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

After a bisection on the kernel, it seems that a patch is causing a 
problem with NetworkManager: 

commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8 ("cfg80211: 
use DS or HT operation IEs to determine BSS channel")

The Wifi access points are not listed in the KDE plasma widget and it 
won't even connect to the saved ones even if they are in range.

There is a fix though: running "iwlist wlan0 scan" twice as root (which 
properly lists APs in reach) and the second time must be run about two 
seconds after the first time.

Then NetworkManager lists the access points and connects to the 
prefered one if possible (normal behavior).

This also happens with nm-applet in Gnome.

The hardware is: 14e4:4315 (Network controller: Broadcom Corporation 
BCM4312 802.11b/g LP-PHY (rev 01)) on an Intel Core i3 M370 CPU (64 
bits) computer.

The abnormal behaviour is not random, it happens every time.

Detlev Casanova
