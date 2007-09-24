Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:57262 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbXIXTBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:01:51 -0400
Received: by py-out-1112.google.com with SMTP id u77so3079288pyb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 12:01:50 -0700 (PDT)
Message-ID: <43e72e890709241201r8bcc6dds3648aefb68182937@mail.gmail.com>
Date: Mon, 24 Sep 2007 15:01:49 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3 try 3] Net: ath5k, use int as retval
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <31460273016629243@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2595810412809010611@pripojeni.net>
	 <31460273016629243@pripojeni.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> ath5k, use int as retval
>
> Changes-licensed-under: ISC
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>

Same comment applies here for the #if 0. Specifically here:

@@ -4360,38 +4344,41 @@ yes:
       return 0;
 }

-bool
-ath5k_hw_query_pspoll_support(struct ath_hw *hal)
+#if 0
+static bool ath5k_hw_query_pspoll_support(struct ath_hw *hal)
 {
       AR5K_TRACE;
+
       if (hal->ah_version == AR5K_AR5210)
-               return(true);
+               return true;

       return false;
 }
+#endif

  Luis
