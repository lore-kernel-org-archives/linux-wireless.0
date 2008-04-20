Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:37595 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319AbYDTS6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 14:58:14 -0400
Message-ID: <480B91F5.3050700@lwfinger.net> (sfid-20080420_195816_913012_A85CBA02)
Date: Sun, 20 Apr 2008 13:56:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Rewrite LO calibration algorithm
References: <200804201603.33400.mb@bu3sch.de>
In-Reply-To: <200804201603.33400.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This patch distributes the Local Oscillator calibration bursts over time,
> so that calibration only happens when it's actually needed.
> Currently we periodically perform a recalibration of the whole table.
> The table is huge and this takes lots of time. Additionally only small bits
> of the table are actually needed at a given time. So instead of maintaining
> a huge table with all possible calibration values, we create dynamic calibration
> settings that
> a) We only calibrate when they are actually needed.
> b) Are cached for some time until they expire.
> So a recalibration might happen if we need a calibration setting that's not
> cached, or if the active calibration setting expires.
> Currently the expire timeout is set to 30 seconds. We may raise that in future.
> 
> This patch reduces overall memory consumption by nuking the
> huge static calibration tables.
> 
> This patch has been tested on several 4306, 4311 and 4318 flavours.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
 > ---
