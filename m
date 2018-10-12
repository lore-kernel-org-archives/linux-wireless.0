Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FFCC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C5262098A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C5262098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbeJLWTP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 18:19:15 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45126 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbeJLWTP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 18:19:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id e10-v6so14055277qtq.12
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 07:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AbCqlofkx7U3S5AgmNcRmJBq6NcseI4g/wiBkC0Uk78=;
        b=X7rM17wTCK8wXLuNqUCS41WFR3070FnFmGqauaIxwuvW6l16nLTTNFCNOwAczsUey7
         WTABo3ip4lDAXr3fmtbTDCftPKHEg+mnPD1B5zl3N4EMo/OOuOuYu+oA66HE9tqMuVnm
         qT3l+4O2WezLhrxJ/NHfnUs5ECs7+A608L5daKGU9+kmciqcGR1jG/Ov02oySS1fYONw
         T06fHWMOI1kdTY3FBM+wgO/et221wusVSp1RhoHxEW+xC8mlu17V7V6Su0VVOTMTud3H
         5vDSNAakEliBau4ncqB2uPZi4YsvTA74DmQXykm6cj5xEJBz3mYPFd4COLBZmmYHk4lT
         uOsA==
X-Gm-Message-State: ABuFfogQT8Gij3kxFbKocrN5HEWftSDnWDMUyHj7YOa/3ZCI7s77ZnOv
        QUHzUgekCGyMJRXJK+DOz6CvChfG8KRMuomM6ls=
X-Google-Smtp-Source: ACcGV60gq3lbetu/R5tVIZaCf8CHKceB6Q9RG5bSkRHN8M0pZQOnEWcmiWti9PiYPR0ev+Zvo7kht14h/p3rtFOd5S4=
X-Received: by 2002:ac8:2bf0:: with SMTP id n45-v6mr6133033qtn.152.1539355587636;
 Fri, 12 Oct 2018 07:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <201810090804.eQbqAwdi%fengguang.wu@intel.com> <87pnwf44n6.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87pnwf44n6.fsf@kamboji.qca.qualcomm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 12 Oct 2018 16:46:10 +0200
Message-ID: <CAK8P3a2NaKwHwe3RE_wZN6=myd1dqtWC91EJahbbKuS2oZ+xXw@mail.gmail.com>
Subject: Re: [ath6kl:pending 10/15] ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko]
 undefined!
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     kbuild test robot <lkp@intel.com>, pillair@codeaurora.org,
        kbuild-all@01.org, ath10k@lists.infradead.org,
        svishnoi@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 12, 2018 at 4:32 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> + linux-wireless, arnd
>
> >
> >>> ERROR: "__udivdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
> >>> ERROR: "__divdi3" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>
> I'm not sure what this is about. The corresponding patch is here:
>
> https://patchwork.kernel.org/patch/10624567/
>
> I see some division in the patch but I can't immeaditely see what's
> wrong. So is this a problem in the bot, in parisc architecture or with
> the patch? Anyone have any good ideas? Arnd?
>

I think the problem is that 'clock_freq' is a 'u64', which means we can't use
a normal 32-bit division. It looks like it cannot actually go beyond the
range of a u32, so changing the type should be sufficient.

      Arnd
