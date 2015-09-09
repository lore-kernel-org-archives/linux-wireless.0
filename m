Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33251 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbIIGh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 02:37:27 -0400
Received: by pacex6 with SMTP id ex6so688291pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 23:37:27 -0700 (PDT)
Date: Wed, 9 Sep 2015 12:07:17 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com
Subject: Re: [PATCH 4/5] staging: wilc1000: wilc_msgqueue.c: use kmalloc with
 GFP_ATOMIC
Message-ID: <20150909063717.GA7003@sudip-pc> (sfid-20150909_083731_280549_8B724676)
References: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
 <1441640199-1507-4-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441640199-1507-4-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 08, 2015 at 12:36:38AM +0900, Chaehyun Lim wrote:
> This patch use kmalloc with GFP_ATOMIC instead of WILC_MALLOC.
> It is inside the spin lock region.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
Its not related to your patch, but while seeing your patch I thought of
checking how WILC_NULLCHECK is working. Well, WILC_NULLCHECK is simple,
its just checking for NULL and calling WILC_ERRORREPORT.
WILC_ERRORREPORT is also simple, it is printing the error and then
goto ERRORHANDLER;
Ok, so now there are total 3 ERRORHANDLER label, one in
wilc_errorsupport.h, there this label is the part of WILC_CATCH macro,
and 2 more ERRORHANDLER in coreconfigurator.c. So it jumps to which
ERRORHANDLER ???

regards
sudip
