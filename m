Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:44253 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZBXQ3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 11:29:33 -0500
Cc: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Message-Id: <03E07CC7-A971-4EDD-9363-628B61E94A92@ing.unibs.it> (sfid-20090224_172936_470162_3A928BAF)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <49A41F1D.9060300@lwfinger.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: More data on open-source firmware crash
Date: Tue, 24 Feb 2009 17:29:28 +0100
References: <49A1A331.9080205@lwfinger.net> <80C13710-6BA9-4F14-95B5-82C3043CE93B@ing.unibs.it> <49A41F1D.9060300@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 24, 2009, at 5:23 PM, Larry Finger wrote:

>
> Francesco,
>
> I don't think the problem results from an overrun of the TX FIFO. In  
> my latest
> test, I added code in routine handle_irq_transmit_status() that  
> would print a
> message if the while loop count reached 16 or more. That print did  
> not occur.
> The largest queue depth reached during the run was 14. When the first
> out-of-order cookie was received, the largest depth in the last 64  
> transactions
> was only 5.
>
> I'm going to increase the number of transactions saved for my next  
> run. Any
> other info that I should capture?
What about drop info from dmesg? Another try could be halve the dma  
queue, I believe now it is 64 slots. Could you give a try setting it  
to 32?

Cheers,
-FG

>
>
> Larry

-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli




