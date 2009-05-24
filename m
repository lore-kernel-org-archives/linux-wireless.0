Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:41090 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZEXVnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 17:43:24 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 3BE22D1ADF1
	for <linux-wireless@vger.kernel.org>; Sun, 24 May 2009 23:43:21 +0200 (CEST)
Message-ID: <4A19BF2A.3030101@free.fr>
Date: Sun, 24 May 2009 23:42:02 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 : under high load, ack are lost
References: <loom.20090517T085823-487@post.gmane.org> <loom.20090520T203218-265@post.gmane.org> <loom.20090520T210546-24@post.gmane.org> <200905211747.43882.mb@bu3sch.de>
In-Reply-To: <200905211747.43882.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 20 May 2009 23:09:47 matthieu castet wrote:
>> I see also some period were the AP seem to drop all packet.
>> I am wondering if it can be due to slow recalibration.
>> Do you now how much take calibration were mac is down ?
> 
> I think you should try without QoS.
> Try specifying the qos=0 module parameter to b43.
> If that does not work, additionally apply the following patch.
> I think there are some problems with QoS and I think somebody reported some bugs
> some time ago. I think they are still not addressed.
Thank you for your help.

First I used a ipw2200 for monitoring traffic, but it seems it doesn't 
not capture all packets. That what explain the strange pattern I saw 
before (missing ack or 2 following ack).

The qos disable doesn't seem to help much. There still some period where 
the AP seem blind.

Disabling pwork doesn't help, but some stuff is still done with 
b43_phy_txpower_check on tx path.


I will try to investigate more. A quick workaround is to increase the 
number of retry on my station.


yes.

Matthieu
