Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:42961 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbXKTN03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 08:26:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by hiems2.ing.unibs.it (Postfix) with ESMTP id 67E941825533
	for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 14:17:26 +0100 (CET)
Received: from hiems2.ing.unibs.it ([127.0.0.1])
	by localhost (hiems1.ing.unibs.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xo93-02zoY1P for <linux-wireless@vger.kernel.org>;
	Tue, 20 Nov 2007 14:17:26 +0100 (CET)
Mime-Version: 1.0 (Apple Message framework v752.3)
Message-Id: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it> (sfid-20071120_132631_990930_BA1FFBB0)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-wireless@vger.kernel.org
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: ath5k driver on MIPS and low level control over the hw
Date: Tue, 20 Nov 2007 14:17:25 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

I have been following the ath5k project for a while hoping that the  
new driver could sort out the speed issue that afflicts the MIPS  
platform I am using: I'm involved in a performance evaluation task  
and I need to hack the kernel in such a way that frames are created  
from a task running in kernel space and sent directly to the device  
without passing through the traditional network stack. Clearly I  
cannot deal with a closed binary.

After a small effort to have 2.6.24-rc2 booting up and running  
without problems on my MIPS boards (Mikrotik RB133), I finally added  
the ath5k driver and everything went fine: the driver is usable also  
on these MIPS boards, wlan0 network is up and everything work, I can  
join a test network without using encryption, still have not tested  
with WEP.

I did some tests and I see that setting up filters properly I can  
also see ACKs, RTSs and all other stuff.

I have now a few questions

- is it possible to (e.g. does anybody ever succeeded to) ask the hw  
to transmit a skb-encoded frame with arbitrary content? I mean, is it  
possible to disable CSMA/CA mechanism, call ath5k_txbuf_setup() and  
let the hw to not check if a frame is actually received by someone?
- how is it implemented the rate control in the ath5k driver? I see  
that if a force 54M rate and the channel does not allow (e.g. noise  
due to other BSs in the same channel) this rate the driver takes a  
long time to switch to a lower rate (and usually it switches to 1Mb/s)
- I'm not using the wireless git branch but the standard development  
2.6.24-rc2 code with ath5k added in driver/net/wireless: I suppose  
that this is ok because I have no problems with the net/mac80211 part  
coming with the standard kernel but if someone is aware of changes in  
this part, please let me now.

I would like also to report that I did a very simple test connecting  
a couple of Atheros card with a coaxial cable (impedances adapted and  
both systems are connected to the same ground). The two PCs involved  
are running x86 Linux 2.6.24-rc2 when using ath5k and Linux 2.6.23  
when using standard Madwifi code. I see that independently of the  
channel rate (from 1Mb/s to 54Mb/s) I always get better performances  
with standard Madwifi code. Could this depend on how queues are  
handled on the ath5k code?

Regards,
FG

%%%%%%%%%%%%%%%%%%%%%

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014

%%%%%%%%%%%%%%%%%%%%%

