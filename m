Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web120211.mail.ne1.yahoo.com ([98.138.85.178]:24887 "HELO
	web120211.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753840Ab1AaVYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:24:22 -0500
Message-ID: <275348.31403.qm@web120211.mail.ne1.yahoo.com>
References: <20101201211128.GC16125@vigoh> <907295.15255.qm@web120203.mail.ne1.yahoo.com>
Date: Mon, 31 Jan 2011 13:17:41 -0800 (PST)
From: Chris Pechard <chrispechard@yahoo.com>
Subject: carl9170: RX interrupt handler
To: linux-wireless@vger.kernel.org
In-Reply-To: <907295.15255.qm@web120203.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The carl9170 firmware is notified of incoming packets from the the mac processor 
via AR9170_MAC_INT_RXC bit set in AR9170_MAC_REG_INT_CTRL control register. 
Currently the register is polled through an infinite loop. In order to get 
faster detection of incoming packets, I would like to program a hardware 
interrupt handler which would be called right away instead of depending on a 
polling cycle state. From Steven Chen at Atheros, the chip supports hw 
interrupts even though it is not in used by the open source firmware. Has anyone 
tried to enable this feature ? If you have any pointers on how to enable hw 
interrupt on the arl9170, feel free to flood my mailbox :-) !

Thanks,
Chris.


      
