Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E18C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 00:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3BD02054F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 00:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UrMfgjGU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfCHAJH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 19:09:07 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44818 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfCHAJH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 19:09:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id a3so12712724pff.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2019 16:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fvg9NbXPnU3p4ZPcj3iIqmSG1j2etsWEod71O4uV8KM=;
        b=UrMfgjGU4xy8L5BmGVqU0zFJVTvWqcqyXsKe9xJ3QqBKI/F0WatTSi9Z9nJN+h3VwN
         ZHMYezryxnSSE9WeyPth7ZrYuwBq7yadvKJcVBRLQGeWWmYp+6SxnMQ38wEfSAYsWAX0
         SIwmo7yvHN+duNs/EFhCo95dD+RWg7OjNRGWi1I6oam50V+NkYKfsoKA0hgRaXO4/e0d
         Sf1Qr8OWJOmHg5I9urimtf0sVSyu9J4XMA1/F2EQJt+vie3fXwJP/CduoWbxyj6nF3XG
         wurZlKgWekG+/mf4HyB4MhAUIGjov3g6G9T10bavHASMXGTT8P7G4vLTkQprGcuBN2Bp
         PO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fvg9NbXPnU3p4ZPcj3iIqmSG1j2etsWEod71O4uV8KM=;
        b=XWTarqKhx9tz3Q9YZQTWhiWX8NNPo5QpOZhgks4JxgTuqq/DBBGYyE9bq+uJgQYPCB
         R+CyxGKudVyiapzVoElsMmxq7/QduB/m/XHqk/GNAWG//J7txyk0Ic9+se3wl2omamLc
         GRIc8HOwYk9+vkkufuPvMNsA04PPyr/2TCmncvk8+kGHAABjWd0bGoTrdgW77Dkc34U0
         Y4PIMO8D3YRf/Xs054uXtN5zu8g1bdWdc0LOeIlVydsIVk9CXIjUb2NED468IHcTEeMF
         Fm4yN6I1ZroRwPfKaD8B/fYjl8UQ6WbY0IamnlDwu4OEDPT+icpQ30fvjZrHhiUb9ODP
         Cv7Q==
X-Gm-Message-State: APjAAAVkKUvC8OLnOzz+nuwBQA3BW3YSxPjtvd07Yv8/anPodSXoJRGp
        9lPKWbXsXozY9f9hIoBwtlP+ymeEhQP/H10PFoCr1w==
X-Google-Smtp-Source: APXvYqzwPuN9LFvpxnTBcY4LeTUJroexnI+x0pO0xm8nmgYoFBJH4oHA5u5prVk5dDwkwdZ65tkhwDBcguHwctlja/o=
X-Received: by 2002:a62:e704:: with SMTP id s4mr15388994pfh.94.1552003746377;
 Thu, 07 Mar 2019 16:09:06 -0800 (PST)
MIME-Version: 1.0
References: <20190308000322.5379-1-natechancellor@gmail.com>
In-Reply-To: <20190308000322.5379-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 7 Mar 2019 16:08:55 -0800
Message-ID: <CAKwvOdn183kWz=+6robC44m4YWPXBLVJzhxL6f9jftvRi-=sxA@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: mvm: Change an 'else if' into an 'else' in iwl_mvm_send_add_bcast_sta
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 7, 2019 at 4:03 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When building with -Wsometimes-uninitialized, Clang warns:
>
> drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:12: warning: variable
> 'queue' is used uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>
> Clang can't evaluate at this point that WARN(1, ...) always returns true
> because __ret_warn_on is defined as !!(condition), which isn't
> immediately evaluated as 1. Change this branch to else so that it's
> clear to Clang that we intend to bail out here.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/399
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the simple fix.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
> index 498c315291cf..360724ec41a6 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
> @@ -2111,8 +2111,10 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
>                         queue = mvm->probe_queue;
>                 else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
>                         queue = mvm->p2p_dev_queue;
> -               else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
> +               else {
> +                       WARN(1, "Missing required TXQ for adding bcast STA\n");
>                         return -EINVAL;
> +               }
>
>                 bsta->tfd_queue_msk |= BIT(queue);
>
> --
> 2.21.0
>


-- 
Thanks,
~Nick Desaulniers
