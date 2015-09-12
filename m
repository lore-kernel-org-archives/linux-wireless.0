Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbbILPsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 11:48:42 -0400
Date: Sat, 12 Sep 2015 08:48:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shraddha Barke <shraddha.6596@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Staging: wilc1000: wilc_wfi_cfgoperations.c: replace
 memset(x,0,ETH_ALEN)
Message-ID: <20150912154841.GB29944@kroah.com> (sfid-20150912_174904_167960_DD2EC714)
References: <1442036259-2693-1-git-send-email-shraddha.6596@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442036259-2693-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 12, 2015 at 11:07:39AM +0530, Shraddha Barke wrote:
> eth_zero_addr() is a wrapper function for memset if 0 is going to
> be assigned to a mac address. The aforementioned function replaces
> memset.
> 
> Changes were done using Coccinelle
> 
> @eth_zero_addr@
> expression e;
> @@
> 
> -memset(e,0x00,\(6\|ETH_ALEN\));
> +eth_zero_addr(e);
> 
> Build tested it.

You need to do much more to prove that this is a safe change than just
test build it, sorry.
