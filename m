Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab0HEO4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 10:56:46 -0400
Subject: RE: Capturing packets with bad FCS in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: ABM Musa <amusa2@uic.edu>
Cc: 'Daniel Haid' <d.haid@gogi.tv>, linux-wireless@vger.kernel.org
In-Reply-To: <475A8455ABBB4AD79E2B0AD03B1F69B9@personal>
References: <201008051614.11546.d.haid@gogi.tv>
	 <475A8455ABBB4AD79E2B0AD03B1F69B9@personal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 16:56:41 +0200
Message-ID: <1281020201.4058.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-05 at 09:43 -0500, ABM Musa wrote:
> Packets with crc error can be captured using corresponding flag of iw.
> 
> iw phy phy0 interface add wlan0 type monitor flags fcsfail 
> 
> However, there is also option for plcpfail flag but I never obtained any
> packet with plcpfail using this flag. Any info about that will be helpful.

It only works with very few drivers (b43) and also had issues -- you'll
probably need this patch:
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-no-rate-check.patch

johannes

