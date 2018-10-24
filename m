Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0BFC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 14:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 311832075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 14:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 311832075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbeJXWgF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 18:36:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41424 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbeJXWgF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 18:36:05 -0400
Received: from mail-pl1-f197.google.com ([209.85.214.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gFJp5-0007Et-O7
        for linux-wireless@vger.kernel.org; Wed, 24 Oct 2018 14:07:47 +0000
Received: by mail-pl1-f197.google.com with SMTP id f17-v6so2764504plr.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 07:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vN/GHrPD/0MJPXJ6HXJx2IsKrSJBHRH5YZPwAZTI+9M=;
        b=J+Z+u8XqFXNnKfJv2JME3ouyroIv5ReznlaRV5aHOm8VIdVqFc1h8/cEvQIH9a0dox
         BRJzQ0XnHd8igivQ5V/Eo7e578czLEOy3ekfhjJOfrS+6FMpqWKt+IhgBW8j1SJ5iDRq
         VyEXQERNVItSuk8NWUzFlgWYRR+pJANv4Pl/hbNHD3EJvYpzEnKtOgOXyaRHhzkSBFiN
         IuiVQjzTErKaQ7bYxlbKc4CQMz7l6Yxvi9i4Zi31PTS9N/lW6K6j+E+Ph36m3UPTCJ9k
         i2DP9tzbutPyRnbT3sYriG1SFL0r5CG0F9X45PlsMMZNUGL55fSkOR+/RfacznAg/qqo
         LL6w==
X-Gm-Message-State: AGRZ1gJkrPs95cDjri6nzg39MOzKs2PgxWtEiTaF+Fkk0SQAO0hYn8El
        qqSEGi5KXcD83yrRUX5djzwcgtFzAjzKwleYCMvVhTOOog26XABXi83tLPzFnpTxinqoEZ7IlvE
        QvSuDdnK2r+2yAmQpedsihuJt3xzYWNl+bYoDMzXgUrVD
X-Received: by 2002:a62:250:: with SMTP id 77-v6mr2892119pfc.16.1540390066172;
        Wed, 24 Oct 2018 07:07:46 -0700 (PDT)
X-Google-Smtp-Source: AJdET5dg3sjuOzXoe2puylb1wVKBGvBvXQ/YqlfttoXIZaUw9T8Nvb3pT2zAKz2GlvzTm6KIw2w82g==
X-Received: by 2002:a62:250:: with SMTP id 77-v6mr2892088pfc.16.1540390065663;
        Wed, 24 Oct 2018 07:07:45 -0700 (PDT)
Received: from localhost (h59.232.132.40.static.ip.windstream.net. [40.132.232.59])
        by smtp.gmail.com with ESMTPSA id h5-v6sm6170098pgh.42.2018.10.24.07.07.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Oct 2018 07:07:44 -0700 (PDT)
Date:   Wed, 24 Oct 2018 08:07:43 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     haim.dreyfuss@intel.com, linux-wireless@vger.kernel.org,
        wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: remove dependency to python attr
Message-ID: <20181024140743.GC8750@ubuntu-xps13>
References: <20181006160254.7980-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006160254.7980-1-hauke@hauke-m.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Please remember to Cc wireless-regdb@lists.infradead.org for regdb
changes, adding now.

On Sat, Oct 06, 2018 at 06:02:54PM +0200, Hauke Mehrtens wrote:
> Commit 8607edfdb6568 ("wireless-regdb: Parse wmm rule data") introduced
> a dependency to the python module attr which is not included by default
> in all python installations. Replace the code with manually coding the
> constructor instead of using attr. This makes the code also work on
> systems without attr.
> 
> I would like to avoid an additional dependency in OpenWrt where we
> compile the regulatory database inside of the build system.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

I had wonderd if this would turn out to be a problem for someone.
Applied, thanks!

> ---
>  dbparse.py | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/dbparse.py b/dbparse.py
> index 5fe752b..993f757 100755
> --- a/dbparse.py
> +++ b/dbparse.py
> @@ -5,7 +5,6 @@ from functools import total_ordering
>  import sys, math
>  from math import ceil, log
>  from collections import defaultdict, OrderedDict
> -import attr
>  
>  # must match <linux/nl80211.h> enum nl80211_reg_rule_flags
>  
> @@ -32,16 +31,17 @@ dfs_regions = {
>  
>  @total_ordering
>  
> -@attr.s(frozen=True, cmp=False)
>  class WmmRule(object):
> -    vo_c = attr.ib()
> -    vi_c = attr.ib()
> -    be_c = attr.ib()
> -    bk_c = attr.ib()
> -    vo_ap = attr.ib()
> -    vi_ap = attr.ib()
> -    be_ap = attr.ib()
> -    bk_ap = attr.ib()
> +
> +    def __init__(self, vo_c, vi_c, be_c, bk_c, vo_ap, vi_ap, be_ap, bk_ap):
> +        self.vo_c = vo_c
> +        self.vi_c = vi_c
> +        self.be_c = be_c
> +        self.bk_c = bk_c
> +        self.vo_ap = vo_ap
> +        self.vi_ap = vi_ap
> +        self.be_ap = be_ap
> +        self.bk_ap = bk_ap
>  
>      def _as_tuple(self):
>          return (self.vo_c, self.vi_c, self.be_c, self.bk_c,
> -- 
> 2.11.0
> 
