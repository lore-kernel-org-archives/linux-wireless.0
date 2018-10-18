Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8214C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 11:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84A932086E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 11:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OQs16a6w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84A932086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbeJRTrw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 15:47:52 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:36148 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbeJRTrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 15:47:52 -0400
Received: by mail-ua1-f68.google.com with SMTP id b3so6016109uak.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 04:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHnjls+FuwP4z6dk3/4VLOVQp7OqMpku+jgrc7EzsQI=;
        b=OQs16a6w8qaydocGQTc53MeYzlm8g1EXgkQJbwr6q879xVt7dnH+ajGCcDxLGJE3I9
         T5DKXbsdq6eJnjw/9tA/eagFoFZ4UjrWJUKHtPJCvxvxTLJsGxwEfd7Wh2uwi16lAORi
         vBQJRdCSePLSfcHpVvDtnprMXiMsJIgluZIJKj2cyf9Sb5BIqN7I85VxN1moC0d7HrQh
         RGde/ILnzbKlcjMR93xPALOiNxI5EM3IApmeTesePtKFk/QeITaHW0ZD9xZq5Hz7dZQf
         0JxUtvl4YuYw6YHk3st4+nGwo/GqkWZa8Kq0ESLyqk+Pw6MdXp2jEn66yNlnKpNMxMR2
         PVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHnjls+FuwP4z6dk3/4VLOVQp7OqMpku+jgrc7EzsQI=;
        b=Gr+laXmd4D9OFSzkVHBpBNLyhFaB1r/+40/u0xJFzHGJa9zX55BzugDZmGYKqzGQoD
         NClPovATvWsmVohcau3U5kwxdW6B+6Bs51udD3GNRCyo3VOqiVrEwhZiuhx+Hvs6vmlS
         Eqhllct3PT+o/fL/C+7R2sg1L143lsPrhHR/AyAfnbDAAjj/cdUiAYtFRwbQc+ah+L0L
         O44SdKT/oZ/hHb5YsVNKtVfdWQqKlHrTwsAg5Wu3vMNxqijgXeq6ZghkwUXlqLb1eZ34
         RrPpQVwSvPNNZBglNWIa+H/dCHNe6WFSdSx+unIuX5UcDWycIsvtT2Z+kV4Ns7pbDvYE
         grBg==
X-Gm-Message-State: ABuFfoh/4LwsTtenY452kNFbm+3EDUXdm/ygGC/y3wrkDHyTQ2YSC096
        kdx97Yc6LRdNRme7o0Nk7A97LMJTHZ038Y1Nk9c=
X-Google-Smtp-Source: ACcGV60VmY1+iEWYvc+iJFXoXrjTF6QO0fp8l/QmE//uPxSCI0X/HZc0DhA+5/wBdum98U9An+/pntDM/twp8Pc1wsw=
X-Received: by 2002:a9f:2e02:: with SMTP id t2mr4922695uaj.79.1539863233065;
 Thu, 18 Oct 2018 04:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <20181018083547.23262-1-johannes@sipsolutions.net>
In-Reply-To: <20181018083547.23262-1-johannes@sipsolutions.net>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Thu, 18 Oct 2018 17:21:35 +0530
Message-ID: <CANGSkXRMOK7dJwyRZOgBZbypvAPyV6DUEtE+2LGodtiN5=BqmQ@mail.gmail.com>
Subject: Re: [PATCH] mac80211: allow hardware scan to fall back to software
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        sushant kumar mishra <sushant2k1513@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        prameela.j04cs@gmail.com,
        Sushant Mishra <sushant.mishra@redpinesignals.com>,
        johannes.berg@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 18, 2018 at 2:06 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> In some cases, like in the rsi driver hardware scan offload, there
> may be scenarios in which hardware scan might not be available or
> desirable.
>
> Allow drivers to cope with this by letting them fall back to software
> scan by returning the special value 1 from the hardware scan method.
>
Acked-and-Tested-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
