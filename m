Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54352 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFFeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 01:34:01 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21554.10746.716067.553115@gargle.gargle.HOWL> (sfid-20141006_073406_720082_D98F892F)
Date: Mon, 6 Oct 2014 11:04:50 +0530
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: re: ath: Add support for tracing
In-Reply-To: <20141003121101.GA23748@mwanda>
References: <20141003121101.GA23748@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> Hello Sujith Manoharan,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch e6664dff0608: "ath: Add support for tracing" from Sep 27, 
> 2014, leads to the following Smatch complaint:
> 
> drivers/net/wireless/ath/main.c:88 ath_printk()
> 	 error: we previously assumed 'common->hw' could be null (see line 82)

Thanks.

ath_printk() would be called only if ath_hw/ath_common are setup,
so the chances of common being NULL is pretty low.

But, since we are interested in trace information with a functional
driver, trace_ath_log() can be moved inside the check. I'll send
a patch.

Sujith
