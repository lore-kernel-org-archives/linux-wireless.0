Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.224]:4862 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXJHUir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 16:38:47 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1432085wxd
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2007 13:38:46 -0700 (PDT)
Date: Mon, 8 Oct 2007 16:38:52 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/6] ath5k: Ported new initval changes from OpenBSD to
	ath5k
Message-ID: <20071008203852.GB7633@pogo> (sfid-20071008_213852_457093_D8339C44)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo> <40f31dec0710070249p5ed648c8u61e8fe3768d934da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0710070249p5ed648c8u61e8fe3768d934da@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 07, 2007 at 02:49:23AM -0700, Nick Kossifidis wrote:
> 2007/10/5, Luis R. Rodriguez <mcgrof@gmail.com>:
> > Ported new initval changes from OpenBSD to ath5k to ar5212_ini[] and
> > ar5212_ini_mode[].
> 
> NACK
> 
> Nothing new was introduced in OpenBSD cvs that i haven't already
> included!, what have you ported ???

Actually, you are right, an oversight by my part. Thanks for catching
this. However after verying this I did find the one type. Please
review.
 
> > This also adds an O(log(N)) bitswap for one byte
> > on ath5k_hw_bitswap(), thanks to Tom from OpenBSD.
> 
> ACK it's used for modifying rf buffer settings...

I think its easier to just new patches. I'll do so but please first
review the small change below.

  Luis


diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 1537517..f826422 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1980,4 +1980,4 @@ after DFS is enabled */
 #define	AR5K_PHY_GAIN_2GHZ		0xa20c
 #define	AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX	0x00fc0000
 #define	AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX_S	18
-#define	AR5K_PHY_GAIN_2GHZ_INI_5111	0x6480416c
+#define	AR5K_PHY_GAIN_2GHZ_INI_5111	0x6448416a
