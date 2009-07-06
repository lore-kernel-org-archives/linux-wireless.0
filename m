Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:43134 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZGFBgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 21:36:48 -0400
Message-ID: <4A51553B.9050204@lwfinger.net>
Date: Sun, 05 Jul 2009 20:36:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
References: <200907040053.05654.chunkeey@web.de> <200907051559.32958.chunkeey@web.de> <4A50E7C5.4040309@lwfinger.net> <200907060005.55329.chunkeey@web.de>
In-Reply-To: <200907060005.55329.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:

> hmm, can you please give this a go? (I hope this patch still applies...)
> I'm curious if you can dump the tx_queue when p54_alloc_skb fail?

The patch applied with the aid of wiggle. Since adding it, I've had 7
of the disassociation failures, but none of the queue len problems.

I have modified every place that p54_alloc_skb() fails with a printk
that tells why it failed and then calls p54_dump_tx_queue(), but I
have not gotten to test it yet. I found an oops when 2.6.31-rc2 is
booted that I'm bisecting right now.

Larry


