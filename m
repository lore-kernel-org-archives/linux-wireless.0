Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:2845 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJ1OAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 10:00:09 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1319129fkz
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2007 07:00:08 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: Use subsys_initcall
Date: Sun, 28 Oct 2007 15:19:47 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200710281439.02701.mb@bu3sch.de>
In-Reply-To: <200710281439.02701.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710281519.47663.IvDoorn@gmail.com> (sfid-20071028_140017_021084_71E03E2F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 October 2007, Michael Buesch wrote:
> We must use subsys_initcall, because we must initialize before a
> driver calls rfkill_register().
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> Index: wireless-2.6/net/rfkill/rfkill.c
> ===================================================================
> --- wireless-2.6.orig/net/rfkill/rfkill.c	2007-10-28 13:09:04.000000000 +0100
> +++ wireless-2.6/net/rfkill/rfkill.c	2007-10-28 14:27:30.000000000 +0100
> @@ -449,5 +449,5 @@ static void __exit rfkill_exit(void)
>  	class_unregister(&rfkill_class);
>  }
>  
> -module_init(rfkill_init);
> +subsys_initcall(rfkill_init);
>  module_exit(rfkill_exit);
> 


