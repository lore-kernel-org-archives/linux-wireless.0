Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:40650 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXK0Lqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 06:46:46 -0500
Received: from localhost (localhost [127.0.0.1])
	by hiems2.ing.unibs.it (Postfix) with ESMTP id 753A8182553A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 12:46:44 +0100 (CET)
Received: from hiems2.ing.unibs.it ([127.0.0.1])
	by localhost (hiems1.ing.unibs.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GKWjcaIHEGSV for <linux-wireless@vger.kernel.org>;
	Tue, 27 Nov 2007 12:46:44 +0100 (CET)
Mime-Version: 1.0 (Apple Message framework v752.3)
In-Reply-To: <43e72e890711201448k54bd4d64kaf9887de83f07def@mail.gmail.com>
References: <E7E9AC02-E136-48B7-8E39-3419B36B6575@ing.unibs.it> <43e72e890711201448k54bd4d64kaf9887de83f07def@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <42996941-C9EA-46FD-8B84-E9A99F2501D9@ing.unibs.it> (sfid-20071127_114700_024818_E67A03E6)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: ath5k: driver fails to enter RTS/CTS procedure
Date: Tue, 27 Nov 2007 12:46:47 +0100
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

(sorry if you already know, however) I was debugging the driver on my  
mips board and I discovered a problem with the RTS/CTS procedure. I  
see that even if I set the threshold for RTS, packets that are longer  
than the threshold are correctly scheduled by net/mac80211 as to be  
led by the RTS/CTS procedure (this means that timing is correctly  
calculated to take into account the CTS that follows the RTS): this  
is then correctly reported to the ath5k_tx() funtion inside the  
control structure, but the driver actually misses to setup the  
hardware to enter the RTS procedure.

For the sake of clarity, the issue affects also Intel code.

Regards,
FG




