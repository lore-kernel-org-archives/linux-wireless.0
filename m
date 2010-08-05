Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-1.cc.uic.edu ([128.248.155.182]:48119 "EHLO
	mail-1.cc.uic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326Ab0HEOwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 10:52:45 -0400
From: "ABM Musa" <amusa2@uic.edu>
To: "'Daniel Haid'" <d.haid@gogi.tv>, <linux-wireless@vger.kernel.org>
References: <201008051614.11546.d.haid@gogi.tv>
In-Reply-To: <201008051614.11546.d.haid@gogi.tv>
Subject: RE: Capturing packets with bad FCS in monitor mode
Date: Thu, 5 Aug 2010 09:43:57 -0500
Message-ID: <475A8455ABBB4AD79E2B0AD03B1F69B9@personal>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Packets with crc error can be captured using corresponding flag of iw.

iw phy phy0 interface add wlan0 type monitor flags fcsfail 

However, there is also option for plcpfail flag but I never obtained any
packet with plcpfail using this flag. Any info about that will be helpful.

Musa

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Daniel Haid
Sent: Thursday, August 05, 2010 9:14 AM
To: linux-wireless@vger.kernel.org
Subject: Capturing packets with bad FCS in monitor mode

Hello,

is it possible to receive packets with bad FCS in monitor mode (ath9k
driver)?
There is a comment in ath9k/common.c which says that a bad checksum is
ignored in monitor mode, but I have so far never been able to receive a
packet with bad FCS (I do not know how to generate such packets, so I might
just be too lucky that all packets are received unimpaired).

Does ath9k hardware drop packets with bad FCS directly? If so, can it be
disabled?

Best regards.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html


