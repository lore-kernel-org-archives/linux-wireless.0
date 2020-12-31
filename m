Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1C7C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Dec 2020 01:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432E3221FA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Dec 2020 01:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgLaBT5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Dec 2020 20:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgLaBT5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Dec 2020 20:19:57 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7183C061573
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2020 17:19:16 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o13so41321126lfr.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2020 17:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7jZjVYpHujOzXBzfqvQU/+a0YQPbQy2pgIuGE3mIh8=;
        b=KZJuNSkMQw3PNnedlYa6biW6ktk8aqLjAHLOu/qzsjQWdKttlrfRL6PIHObfd67Xje
         MX8de4CkB/cWbDho/ZRIl3yWPHY9KC3kE2eiNxsoGwknUvuwl8fZasiY3RNvAjo8dKv0
         oHByMMLYWRDO7Y21xFQCOzY9QO6cQbUv25EwbzYLlpVu9N8daJUfPgBGOWiYKG+bleEZ
         bf/k3Q8UBj7Ectn7GMiz5vZUVuPVupMmyr4FFoCs5VKl/T844mUly4b5AzKfu1ccb6RN
         q+pHvDmFHlOOurkObGMYxLz0I3dqYE3IWQPOqCtXvEcIEwX8A4Kw95WCRjKyHYf+PpuQ
         Hsyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7jZjVYpHujOzXBzfqvQU/+a0YQPbQy2pgIuGE3mIh8=;
        b=nAsZp2FPvxpCiWj5sz5MbkT8mW3D3NkNF4kSd03R8zV900gcGp11xMD6TWtfxbzL/z
         ZkqzHX7ZE/acfN/pm9lT+Gc1iPLMT/YxRhYbebDJn2xeFRb2o7NBbqSktfKV4gnMIa3U
         QvAiihI7tywWKJWSe+QYFMTPb3amcfvOmctyBxxKXTAWFLqAYD7N+XKU8MlV8c8b2TA0
         7mIDFQcNgbKSN3RZubhhcXCve3aNAkeCl4Tmoko7dCQXqMnhaosxHSTBDXo4WOKrAEz6
         0Ek5f/j8GbxM5w+3/ugxZGEfCyqcS/W9tu1bVAVSeKM9RmK5siCHYju50bgn/HdFss/w
         6BBg==
X-Gm-Message-State: AOAM532KW148ZM260O+jX28VIGYdMcXgSHQFMy36gBdgnf6tn2we2hhh
        +IclGi+HXKhU/y7NTQVs7j/Bgh+7pPt+TozfoFA=
X-Google-Smtp-Source: ABdhPJyEfxmnQdqSRjm6U0rO7A88TKgfREhXuxlqSeELbo8P6hBmbkoQW+dJvnW2hrnFpO7hSeD9qLSNmzn4/22y4kI=
X-Received: by 2002:a19:6547:: with SMTP id c7mr22838350lfj.14.1609377554982;
 Wed, 30 Dec 2020 17:19:14 -0800 (PST)
MIME-Version: 1.0
References: <20201231000523.14963-1-greearb@candelatech.com> <20201231000523.14963-3-greearb@candelatech.com>
In-Reply-To: <20201231000523.14963-3-greearb@candelatech.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 31 Dec 2020 12:19:03 +1100
Message-ID: <CAGRGNgXx3tqzOjLcKA=+FDrQsad_Hn=KX_gC+P4DFX+r8e2Fnw@mail.gmail.com>
Subject: Re: [PATCH 3/6] iwlwifi: Allow per-device fwcfg files.
To:     Ben Greear <greearb@candelatech.com>
Cc:     linux-wireless@vger.kernel.org, Luciano Coelho <luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ben,

On Thu, Dec 31, 2020 at 11:17 AM <greearb@candelatech.com> wrote:
>
> From: Ben Greear <greearb@candelatech.com>
>
> This allows one to set the NSS and some
> other low-level features for ax200 radios.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-dbg-cfg.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-cfg.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-cfg.c
> index 223c716d9fce..e2ae509d1650 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-cfg.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-cfg.c
> @@ -246,12 +246,16 @@ void iwl_dbg_cfg_load_ini(struct device *dev, struct iwl_dbg_cfg *dbgcfg)
>         const struct firmware *fw;
>         char *data, *end, *pos;
>         int err;
> +       char fname[128];
>
>         if (dbgcfg->loaded)
>                 return;
>
> -       /* TODO: maybe add a per-device file? */
> -       err = firmware_request_nowarn(&fw, "iwl-dbg-cfg.ini", dev);
> +       snprintf(fname, 127, "iwl-dbg-cfg-%s.ini", dev_name(dev));
> +       fname[127] = 0;
> +
> +       /* TODO: maybe add a per-device file?  Yes, did that. --Ben */

You probably don't need the comment anymore =)

> +       err = firmware_request_nowarn(&fw, fname, dev);

Would it make sense to fall back to "iwl-dbg-cfg.ini" if the
per-device one isn't available?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
