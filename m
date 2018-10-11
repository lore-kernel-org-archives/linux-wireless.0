Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A183C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC07320835
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:09:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC07320835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbeJKRf4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 13:35:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57222 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbeJKRf4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 13:35:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAXu4-0008Cx-HG; Thu, 11 Oct 2018 12:09:12 +0200
Message-ID: <1539252537.3687.209.camel@sipsolutions.net>
Subject: Re: linux-next: manual merge of the crypto tree with the
 mac80211-next tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 11 Oct 2018 12:08:57 +0200
In-Reply-To: <20181011111329.253f0689@canb.auug.org.au>
References: <20181011111329.253f0689@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-10-11 at 11:13 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the crypto tree got conflicts in:
> 
>   net/wireless/lib80211_crypt_tkip.c
>   net/wireless/lib80211_crypt_wep.c
> 
> between commit:
> 
>   b802a5d6f345 ("lib80211: don't use skcipher")
> 
> from the mac80211-next tree and commit:
> 
>   db20f570e17a ("lib80211: Remove VLA usage of skcipher")
> 
> from the crypto tree.

Thanks Stephen.

The fixup (use mac80211-next file) is fine, but I'm not sure we want to
bother Linus/Greg with it?

Herbert, maybe you can drop the patch from the crypto tree since my
change also removes the VLA usage?

johannes
