Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.40]:47563 "HELO
	nm11-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753710Ab1AJVYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 16:24:20 -0500
Message-ID: <907295.15255.qm@web120203.mail.ne1.yahoo.com>
References: <20101201211128.GC16125@vigoh>
Date: Mon, 10 Jan 2011 13:24:18 -0800 (PST)
From: Chris Pechard <chrispechard@yahoo.com>
Subject: carl9170: RX and TX interrupt callback ?
To: linux-wireless@vger.kernel.org
In-Reply-To: <20101201211128.GC16125@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to do time measurement using carl9170 firmware side. There was some 
interesting previous thread about clock to be used and location of the probe in 
the code. My goal is to get a precise time from the moment a packet has been 
transmitted (timestamp when the packet has been transmitted) and the arrival of 
the next received packet (time when a packet has been fully received). Looking 
though the code, there is a loop in src/main.c handling the TX/RX interrupt by 
reading the AR9170_MAC_REG_INT_CTRL register and checking the 
AR9170_MAC_INT_TXC/RXC bits. Pending on task to be performed in the loop, it 
could take tens of microseconds to go through one iteration which affects the 
measurement and resulting in having RXC timestamp smaller than TXC timestamp 
which is clearly an issue !
My current workaround is to add many check to AR9170_MAC_REG_INT_CTRL in the 
main loop to reduce the detection latency which at least gave me better results 
(TXC time < RXC time ) but somehow it does not seem AR9170_MAC_REG_INT_CTRL 
register is refreshed right away when a packet is received or transmitted. I 
would like to know if there is any way to attach a callback function  to the RXC 
or TXC interrupt so that we get immediate notification  instead of depending on 
a polling method. If not, is there any way to  minimize delays between the time 
a packet is sent/received and the  TXC/RXC bit flag raised in the register ?

Thanks,
Chris.


      
