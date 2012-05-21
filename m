Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25633 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2EUN2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 09:28:18 -0400
Date: Mon, 21 May 2012 16:32:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: NFC: Initial LLCP support
Message-ID: <20120521133212.GD4629@mwanda> (sfid-20120521_152821_957235_BC252202)
References: <20111216202659.GD18570@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111216202659.GD18570@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 16, 2011 at 11:26:59PM +0300, Dan Carpenter wrote:
> Hello Samuel Ortiz,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch d646960f7986: "NFC: Initial LLCP support" from Dec 14, 
> 2011, leads to the following Smatch complaint:
> 
> net/nfc/llcp/sock.c +47 llcp_sock_bind()
> 	 warn: variable dereferenced before check 'addr' (see line 45)
> 
> net/nfc/llcp/sock.c
>     44	
>     45		pr_debug("sk %p addr %p family %d\n", sk, addr, addr->sa_family);
>                                                                 ^^^^^^^^^^^^^^^
> New dereference.
> 
>     46	
>     47		if (!addr || addr->sa_family != AF_NFC)
>                      ^^^^
> New check.
> 

This got lost in the holiday season.  Probably the check can just be
remove, yes?

regards,
dan carpenter

>     48			return -EINVAL;
>     49	
> 
> regards,
> dan carpenter
> 
