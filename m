Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa09-02.prod.phx3.secureserver.net ([173.201.193.231]:57802
	"EHLO p3plsmtpa09-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaJAQTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 12:19:09 -0400
Date: Wed, 1 Oct 2014 09:11:42 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: NFC: trf7970a: Handle timeout values of zero
Message-ID: <20141001161142.GA695@animalcreek.com> (sfid-20141001_181913_725838_A2E10ECB)
References: <20141001142048.GA32518@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141001142048.GA32518@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 01, 2014 at 05:20:48PM +0300, Dan Carpenter wrote:
> Hello Mark A. Greer,
> 
> The patch 1961843ceeca: "NFC: trf7970a: Handle timeout values of
> zero" from Sep 2, 2014, leads to the following static checker warning:
> 
> 	drivers/nfc/trf7970a.c:897 trf7970a_irq()
> 	warn: passing zero to 'ERR_PTR'
> 
> drivers/nfc/trf7970a.c
>    892                          trf7970a_cmd(trf, TRF7970A_CMD_FIFO_RESET);
>    893  
>    894                          if (!trf->timeout) {
>    895                                  trf->ignore_timeout = !cancel_delayed_work(
>    896                                                  &trf->timeout_work);
>    897                                  trf->rx_skb = ERR_PTR(0);
>                                                       ^^^^^^^^^^
> Why not just say "NULL"?

No reason.  I thought I'd fixed them all.

Mark
--
