Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A82C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 13:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED3A02168B
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 13:09:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MOAFB0ph"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED3A02168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbeI1TdE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 15:33:04 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34865 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbeI1TdE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 15:33:04 -0400
Received: by mail-ot1-f68.google.com with SMTP id j9-v6so5987742otl.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 06:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=61MZ4Kf+eEI2YuPc9XPGomA3P6dDDVqehMMb1y7aoLA=;
        b=MOAFB0phN2QLYUQMcIIOZug1Qe1mp4MFm2uFmTMZ5SIUe2S9wFS2xANhjkV//q69tz
         c78Fv/CJm15PfsEb5fMmggtbbN8TvUOGDr8RB6hwZPFfv/mwe1VUf4ZF/Wn4DJNnkaYw
         yyFNJne5Ang4jw7xQiRhpSYxv3AZA85oJNhQ6ZuV1K4nDCAoIFV+HKZ9aOoGDSC4a1GV
         02Zhcg402GlVjbyJFaEcy2g/t0JvavgqT8nFtbx0esXAUEe83YOi/EG4UMDKa7ZLyE92
         9SUjPyTX1R4Kf0d29RHvXlImx6ieVhAzXepkJidpp5cxdX4NF2+3FWLoHJXLKLSNeVtS
         Vzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=61MZ4Kf+eEI2YuPc9XPGomA3P6dDDVqehMMb1y7aoLA=;
        b=LKoMbBJKo319CPZMJU2AOo+GZp/Os25zGrf9dH5JwL5aK+Loluxzt0QHQRYbXRGKtM
         vxRE+BvQ94VDAQ6ozpVfPcC6QVIIqCspm9i4aOxqx0zWtj/yOKpMv1ZolQot29LQTcKZ
         GMgECkYCcZHbXK7n3UfGY2GhYmpPtl7NYGpqCCFMjfnNz48CWdSWNrNktpkUTkOJ0Tls
         zb7NdDBhNK3+YdGQTtVngHlfCwuXC1hONoDh73Hd4XrD5tuSN8NMmQhu78/nfPU7KyrM
         gQCKfIEKlQfidd9j0vSoi6nysQCSMlOFTeLbn7dOu3cHXV6WLNmVEMp6nothDK5L1Kf/
         p36A==
X-Gm-Message-State: ABuFfoib/uXtyJgdG84THZmYcV62Y0eLWe58Liq+D+0eNQF2Dad2Js3b
        7uET7UBlfRRUQuTXA+Hit5GsUdWNBMCJwvjzoT8Yig==
X-Google-Smtp-Source: ACcGV60HuGvD0FW47g9cOAIjcZrV5G+LN2cGFTY4Ev8OWHU/CUKhBnF8ZgmB4NfrGjvzja5K51YprtmbXmkqNtLBmoc=
X-Received: by 2002:a9d:5285:: with SMTP id f5-v6mr9509913oth.247.1538140161806;
 Fri, 28 Sep 2018 06:09:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2834:0:0:0:0:0 with HTTP; Fri, 28 Sep 2018 06:09:21
 -0700 (PDT)
In-Reply-To: <20180919103711.19304-1-sw@simonwunderlich.de>
References: <20180919103711.19304-1-sw@simonwunderlich.de>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 28 Sep 2018 15:09:21 +0200
Message-ID: <CAKR_QVJM4T_nvVMVqh75U+_xqXG8hW80OzzJmtpxbJKWecUtKg@mail.gmail.com>
Subject: Re: [PATCH 0/5] ath9k: FFT fixes and improvements
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

compiles OK, no interfere with normal card operations (IBSS) so it
should be merged.

On 19/09/2018, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> During FFT evaluation on an AR9462 adapter, we noticed that there were
> way less FFT samples received than we would expect. This patchset adds
> some counters to be able to check for received (and discarded) FFT
> samples, and fixes a variety of issues I found while debugging.
>
> Cheers,
>      Simon
>
> Simon Wunderlich (5):
>   ath9k: add counters for good and errorneous FFT/spectral frames
>   ath9k: return when short FFT frame was handled
>   ath9k: fix and simplify FFT max index retrieval
>   ath9k: FFT magnitude check: don't consider lower 3 data bits
>   ath9k: fix reporting calculated new FFT upper max
>
>  drivers/net/wireless/ath/ath9k/common-debug.c    |  2 +
>  drivers/net/wireless/ath/ath9k/common-debug.h    |  4 ++
>  drivers/net/wireless/ath/ath9k/common-spectral.c | 83
> +++++++++---------------
>  drivers/net/wireless/ath/ath9k/common-spectral.h | 17 +++++
>  4 files changed, 55 insertions(+), 51 deletions(-)
>
> --
> 2.11.0
>
>
