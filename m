Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00098C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 02:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE9A2084A
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 02:00:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z1Tk2O1N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbeLQCAa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Dec 2018 21:00:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48006 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeLQCAa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Dec 2018 21:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VkjJn5zLKBKC+0+0ffxBJE5JsJAXOTPAJYtDZRFJ6YE=; b=Z1Tk2O1NBBE/aNgZ3RY3tzImja
        QS5SfvwnP22Iz4A+net5OQP3j4aTtN7h8PBzvOo63GxhNPcvYMMB7ZMhy3pXyPWU51xcQfdSU/Fe0
        +JqKWkIqJHrNCJ1Lj5ClfOPsTfKq4q8EPlyQe38C1xxoJD0y/RZZ7NrE1lKyYj6nUpBoUTILu3u+d
        wqMqm9Cke5y8/tsHv6v0NMPpk5sWip/Q2Q0B03lrNT7YVFc+YwcgTR/ar2ZAv+mzuT9NB/Dfp7NT2
        cw9Gh8GxQtPDMFeHJ3+dSJzHe+XpLi2+8alKGw/WzmlUT9kl/3/gcdgBvIiYDyS9+ZF3FNpFcDwLB
        QB2C0hPA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gYiCo-0004U6-1S; Mon, 17 Dec 2018 02:00:26 +0000
Subject: Re: [PATCH] net: wireless: FTM: fix kernel-doc "cannot understand"
 warnings
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        David Spinadel <david.spinadel@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <ab51d1af-5635-b8dd-31dd-72c2ec75f54c@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9ea67d70-259c-a16d-fcc0-8e70b3b2d158@infradead.org>
Date:   Sun, 16 Dec 2018 18:00:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <ab51d1af-5635-b8dd-31dd-72c2ec75f54c@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ping?

On 12/6/18 12:58 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix kernel-doc warnings in FTM due to missing "struct" keyword.
> 
> Fixes 109 warnings from <net/cfg80211.h>:
> ../include/net/cfg80211.h:2838: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
> 
> and fixes 88 warnings from <net/mac80211.h>:
> ../include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
> 
> Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
> Fixes: bc847970f432 ("mac80211: support FTM responder configuration/statistics")
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: David Spinadel <david.spinadel@intel.com>
> ---
>  include/net/cfg80211.h |    2 +-
>  include/net/mac80211.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- lnx-420-rc5.orig/include/net/cfg80211.h
> +++ lnx-420-rc5/include/net/cfg80211.h
> @@ -2815,7 +2815,7 @@ struct cfg80211_external_auth_params {
>  };
>  
>  /**
> - * cfg80211_ftm_responder_stats - FTM responder statistics
> + * struct cfg80211_ftm_responder_stats - FTM responder statistics
>   *
>   * @filled: bitflag of flags using the bits of &enum nl80211_ftm_stats to
>   *	indicate the relevant values in this struct for them
> --- lnx-420-rc5.orig/include/net/mac80211.h
> +++ lnx-420-rc5/include/net/mac80211.h
> @@ -467,7 +467,7 @@ struct ieee80211_mu_group_data {
>  };
>  
>  /**
> - * ieee80211_ftm_responder_params - FTM responder parameters
> + * struct ieee80211_ftm_responder_params - FTM responder parameters
>   *
>   * @lci: LCI subelement content
>   * @civicloc: CIVIC location subelement content
> 
> 
> 


-- 
~Randy
