Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EA8C04EBF
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 08:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D458620854
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 08:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="MSYAwE4H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D458620854
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbeKQSw1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 13:52:27 -0500
Received: from plaes.org ([188.166.43.21]:38308 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbeKQSw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 13:52:27 -0500
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 2378140227;
        Sat, 17 Nov 2018 08:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542443789; bh=HzJVQx+Bg2X6T+cbuSuJAaQCs82gjYrYYb2Rq7ojpoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MSYAwE4HHQMnQdXcs+TMWwHznIWMyLuG0N2X4gM/39vDaX7EqJWQk5pqEb98UOOyp
         TY1Eg/d/HRtQgz+iOlVL7n/3Q8P64xvQhWwKVHn0A2yJBNjxwDTZuYEG14laZJq5wH
         5YaY4uC8/DZd1entEjRBygCmeL/NGV3ZAt6JpAmW0kINPFmr7Or3/hvvqigyCDeJkI
         XawqzQYQ5lVOR1abt0SLKtzOmMyFmyv8aFUTkoiOjjMoB/wgdgOJ68EPLDS5KoZVMD
         oGl/EMZhYk8f7sK/I+6hcpDtfHAOWyVX1bcJyWYtyXFP7LhHYm/GNernLL8iAmRHIG
         vKsWHj/4PpwhQ==
Date:   Sat, 17 Nov 2018 08:36:28 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
Message-ID: <20181117083628.sm6juvz75kiargz4@plaes.org>
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
 <20181114194628.0f485637@wiggum>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181114194628.0f485637@wiggum>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 14, 2018 at 07:46:28PM +0100, Michael Büsch wrote:
> On Wed, 14 Nov 2018 20:27:52 +0200
> Priit Laes <plaes@plaes.org> wrote:
> 
> > Kernel library has a common cordic algorithm which is identical
> > to internally implementatd one, so use it and drop the duplicate
> > implementation.
> 
> 
> In v2 of the series it has been said that:
> 
> Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> > I recall doing a comparison between the algorithms and thought I put 
> > that in the original commit message. However, it is not there. It is not 
> > exactly the same as in b43 so there are difference for certain angles, 
> > most results are the same however. This implementation is slightly more 
> > accurate on the full scale.
> 
> 
> That's not my definition of "identical".
> 
> Please do not apply this patch without doing a thorough regression test
> on actual b43 LP hardware.

Indeed, there's a big discrepancy in the results of both algorithms.

Here's the test script:
https://gist.github.com/plaes/284993a4fc65e0926d0628a11f0cf874

So at current state, this is self-NAK from me too and this patch should
be dropped.

> 
> -- 
> Michael


