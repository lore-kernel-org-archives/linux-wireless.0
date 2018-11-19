Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29811C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 11:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E33DF206BA
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 11:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="nViARzlu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E33DF206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbeKSVvT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 16:51:19 -0500
Received: from plaes.org ([188.166.43.21]:46110 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbeKSVvT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 16:51:19 -0500
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 0657640282;
        Mon, 19 Nov 2018 11:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542626877; bh=BejDCY+wpAWZKpndQTQdd4pESffLH2SRwnk73Phj/5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nViARzlumL2PEk3r29cMAyeGtzrQMOkn3O4/N21+sWrnIUTftIqQ8td7gbBwhuRIp
         V4xUXGJl5BVhcYBAtZpm2H6jHc31rLxdEv4mvRElwc0k4YdzFA4DuDHIsqyUG2BLkM
         7hTyUTVIOUCRvhkqNB4vUVVZ+nLMHg31ISscq4ZX7+m/LXlfIpjWUAL5SoJbOzS7Y/
         ERyQVHo92j5yj1Merbf7WOVkV1/gtT3nB0HgwhAB14pkuhdx2hDcc7dAjbJnSMj7ht
         ZT8c28X2VPSihfMQfHK95c7a6wA1dcY1f7xCc42X5Z1Ug8a9BjiueEyNw+XKOm/FVw
         QJg7+QRlGkDFw==
Date:   Mon, 19 Nov 2018 11:27:55 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
Message-ID: <20181119112755.qtthenx54v3tnok3@plaes.org>
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
 <d630ca3e-4070-5395-54c2-e20e0c552dc3@lwfinger.net>
 <20181118082327.ttrz2nl5owi2hoqv@plaes.org>
 <df798743-10bb-0455-be83-2fb59eca3209@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df798743-10bb-0455-be83-2fb59eca3209@lwfinger.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Nov 18, 2018 at 01:35:57PM -0600, Larry Finger wrote:
> On 11/18/18 2:23 AM, Priit Laes wrote:
> > On Sat, Nov 17, 2018 at 09:31:35PM -0600, Larry Finger wrote:
> > > On 11/14/18 12:27 PM, Priit Laes wrote:
> > > > Kernel library has a common cordic algorithm which is identical
> > > > to internally implementatd one, so use it and drop the duplicate
> > > > implementation.
> > > > 
> 
> My test setup has a hardware failure, thus I cannot test your patch, but I
> now believe it to be correct. Thus your first and third patches may be
> annotated with
> ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> One thing that should be done is to fix the error in the b43 code for stable
> as it was introduced in 2.6.34. I propose adding the attached patched to
> your series placed between your current 2nd and 3rd patches so that the old
> kernels get fixed. Of course, your 3rd patch will need to be revised. If all
> 4 of the patches get submitted together there will be no problems with the
> timing. My change will exist for seconds in the mainline kernel, but it will
> get propagated back through stable.

Thanks!

> From b42ae73ef7505de93e4c66fb9f66930e3f3d969a Mon Sep 17 00:00:00 2001
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Sun, 18 Nov 2018 13:15:07 -0600
> Subject: [PATCH] b43: Fix error in cordic routine
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> To: kvalo@codeaurora.org
> Cc: linux-wireless@vger.kernel.org
> 
> The cordic routine for calculating sines and cosines that was added in
> commit 986504540306 ("b43: make cordic common (LP-PHY and N-PHY need it)")
> contains an error whereby a quantity declared u32 can in fact go negative.

It seems to be different commit though:
commit 6f98e62a9 ("b43: update cordic code to match current specs")

> This problem was detected by Priit Laes who is switching b43 to use the
> routine in the library functions of the kernel.
> 
> Fixes: 986504540306 ("b43: make cordic common (LP-PHY and N-PHY need it)")
> Reported-by: Priit Laes <plaes@plaes.org>
> Cc: Rafa?? Mi??ecki <zajec5@gmail.com>
> Cc: Stable <stable@vger.kernel.org> # 2.6.34
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  drivers/net/wireless/broadcom/b43/phy_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43/phy_common.c b/drivers/net/wireless/broadcom/b43/phy_common.c
> index 85f2ca989565..ef3ffa5ad466 100644
> --- a/drivers/net/wireless/broadcom/b43/phy_common.c
> +++ b/drivers/net/wireless/broadcom/b43/phy_common.c
> @@ -616,7 +616,7 @@ struct b43_c32 b43_cordic(int theta)
>  	u8 i;
>  	s32 tmp;
>  	s8 signx = 1;
> -	u32 angle = 0;
> +	s32 angle = 0;
>  	struct b43_c32 ret = { .i = 39797, .q = 0, };
>  
>  	while (theta > (180 << 16))
> -- 
> 2.16.4
> 

