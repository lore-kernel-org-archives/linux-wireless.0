Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49719C19F2D
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Aug 2022 18:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbiHMSYc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Aug 2022 14:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239428AbiHMSYb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Aug 2022 14:24:31 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845A7B4BB
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2022 11:24:30 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-116c7286aaaso4189754fac.11
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2022 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=matician-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QzbK9qAuy3D409SFr4GCnny2SikQT7nHb5ul8Dsb/Cs=;
        b=KW7qvkGnE0L1M9RUw6IxsjUFF+tDHL8OAn7MVuRbfhCtAXp302J1dRwIeTp1IwFQFh
         hUTJW+mDHCpgPVMYSEvzxAeHykMywFKNcLnafN7WDfe0NJYM4bD/hHAth/I/xKpqOw5j
         YHS42qHrjhD2Vo8sPbAbYwVzKwBMHfBQOhW1fz8y7peq5kpBbi3z8ojPVNr/NSQ7hgkp
         Ol35xfBkC5jphZ0WN1s8tYolza2mlt1nnonL4DHv5VnfZYlt3VgLXr7mf/XRxLasOytW
         l4+vMTEPuZJDgQEcxOuZV53UJlcQP0zm63ZHn0gfbtCedFKiYLHHW22SqFrrrIJ+krUC
         NYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QzbK9qAuy3D409SFr4GCnny2SikQT7nHb5ul8Dsb/Cs=;
        b=fUVLJZr++g2hdkD8MkMj6wXJreXVYDNdBmDZ7munrL1cEwBSrvARGH432BylQFE7Ro
         LqgFbz49YtwgUhiR/OEhNkONXq+XpYhxjzqrmiEoyz/SJdtaGFPb51T/UX37L3lO6KdM
         KY04WeuMVoZW41MgFMCDSRlAKHnrFA7RGf33XBAAzJlwVpthJDzNrp5mCPTCjrCQpOuC
         4TqNtTsu6+5pT0Gg5engrw4fmET8OyOdbsXEwKSxX/L3NRVHWb7TKcXmVNo2bNKKPHgS
         7BbvkywisA8+XgXkWrbCrfTaZMREE2MzD0AeQSo5yHuNzCVyxY8i+rQu9J9yijfuQHDU
         yR4g==
X-Gm-Message-State: ACgBeo0EjyBjre2s8QW0u+JPvqSw4t6L0P0qqgjuxqhwEBB6S5dpicmQ
        l+KNY0IhmriAIS57iLzbm3sN7mlH3MRQw78iePXLHg==
X-Google-Smtp-Source: AA6agR4oL/3/vgv+M777w7emktUD5+rLYegsgATA2zpM36Vuv1rpOV/dhOYQP+ieLup6hG7k3LCsHhP4DyMLnZ4J7lU=
X-Received: by 2002:a05:6870:a708:b0:10f:a91:5990 with SMTP id
 g8-20020a056870a70800b0010f0a915990mr4060840oam.147.1660415069979; Sat, 13
 Aug 2022 11:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <fa1879c7-ba9e-fcd7-9a5b-f6a187b74781@gmail.com>
 <20220808174925.3922558-1-alex.coffin@matician.com> <CA+hUFcuqofeHaOkYySJNJexcEvJE0K-yNk+15=BcDVFCa2k=FQ@mail.gmail.com>
In-Reply-To: <CA+hUFcuqofeHaOkYySJNJexcEvJE0K-yNk+15=BcDVFCa2k=FQ@mail.gmail.com>
From:   Alexander Coffin <alex.coffin@matician.com>
Date:   Sat, 13 Aug 2022 18:24:14 +0000
Message-ID: <CA+hUFcsK1oimPCVD0KGZXuzrUr-wOWLRAPiYFNcZZaLRFi1fsw@mail.gmail.com>
Subject: Re: [PATCH v2] brcmfmac: fix use-after-free bug
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend,

I just wanted to double check that you have received my second patch
as I'm beginning to be slightly worried that your spam filters are
blocking my stack traces.

- Alexander Coffin

I'm resending this message as I realized that Gmail automatically
quoting the stack trace would have made it always go to your spam if I
was correct.
