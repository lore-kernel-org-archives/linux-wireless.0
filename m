Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41575 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbbBMKuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 05:50:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YMDoy-0006oz-0d
	for linux-wireless@vger.kernel.org; Fri, 13 Feb 2015 11:50:04 +0100
Received: from 194.144-252-62.static.virginmediabusiness.co.uk ([194.144-252-62.static.virginmediabusiness.co.uk])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2015 11:50:03 +0100
Received: from miketurner.forum by 194.144-252-62.static.virginmediabusiness.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2015 11:50:03 +0100
To: linux-wireless@vger.kernel.org
From: Mike Turner <miketurner.forum@gmail.com>
Subject: rtl8192cu beacon fix unreliable
Date: Fri, 13 Feb 2015 10:48:47 +0000 (UTC)
Message-ID: <loom.20150213T114021-973@post.gmane.org> (sfid-20150213_115011_339531_7BDFCD7D)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using hostapd and an rtl8192cu Wireless USB adaptor the beacon 
doesn't start sometimes. This was tested with the 

kernel/git/davem/net-next.git repository

and

3423eb92315865d76cb8d488513bfef6ab9251d0

This behaviour is apparently random. If the beacon starts OK then it 
continues. If a beacon isn't generated then it never starts. Repeating 
cycles of hostapd stop/start may or may not generate a beacon. There are 
no specific error messages displayed either on console or in syslog. I 
have repeated hostapd stop/start a number of consecutive times and 
received a beacon each time, however I have also done this a number of 
times and never generated a beacon.

We have succesfully used the pvaret-rtl8192cu driver which is based on the 
vendor driver and used that in conjunction with the modified hostapd code 
that requires use of the rtl871xdrv driver interface and as far as we have 
seen it always generates a beacon. 

Platform is a custom designed Atmel-ARM CPU (AT91SAM9G25) with a D-Link 
DWA-121.

