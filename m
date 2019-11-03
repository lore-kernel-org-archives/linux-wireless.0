Return-Path: <SRS0=fuBz=Y3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE17BCA9EB0
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Nov 2019 15:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0C72067D
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Nov 2019 15:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gzmg8Zpl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfKCPgH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Nov 2019 10:36:07 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38678 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfKCPgH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Nov 2019 10:36:07 -0500
Received: by mail-oi1-f196.google.com with SMTP id v186so12053305oie.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Nov 2019 07:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=orWvojcokT0GElJ+Jy5svBGq0U6iJmEd1nn+wFy1Qm4=;
        b=gzmg8ZplSKhdnNMMMEa4Ry5XC6Fg/RqZo57eP7NLbZXeNXXq34JCO/1StMS/XE0qpn
         M+xKzgImWOS3mDZ8YWnDPQW+Yu+wDu1H5ayCA7OYSjfbbHb6M4PcHQO1Voy8c8eW8eMt
         jbY5cJbRmsJ6PPbFAiIgmjZNTckX59wDa9DHQ6S1sqvlxUE0vby8XQsOLckdHzWGvx7L
         SKT1nZGzU57wSkvB6BHLWNB/Ym3Ybd7OKmGWUC1UCnVgIN6f/NtXHU95cNBfgsNhpbPk
         grwVP1fqbHANBAfV/HgP0+ZqBuwxpXv/imMCqoLLXv0oX+Jnlf0lxMwKfClI7Ick0qhn
         vl4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=orWvojcokT0GElJ+Jy5svBGq0U6iJmEd1nn+wFy1Qm4=;
        b=CczG5asYXYfd+87d9HzPeL9ize032iKCV1WxfmNFBBptNc84CuAbJaBj6KcikP3l0K
         HjTaPH9hdW+bIHz6RkA94+OyoGdvMVELC3vin7wNoA6OmQ16+BjwBQYLFes65uYAcekj
         TnvbFtPCTYCx/VM1yskSdFXIBli+NVn22c9xZPZbhZN4KlkgA96vF00KfmGwiPHMBOkt
         RjnECds3qdivyyKBBPFHvEQU9sPBYqPFA/u1KAzizjlZNgxEu/3W5TnBVeeKRnjBz30o
         djP2649OZmrXMHwxeWF9SaSSwfa1C8f8K9oKSfWzVe5gWTk6D8kFz8SIjIA+DzOfzi31
         8S0w==
X-Gm-Message-State: APjAAAVi7pOB1cUZ6WQoes2FxUXSti7qbzPqP8lh1zxxXipFynlUuxhh
        fnanY2sNSPn829R7ilTGNvT7H4x3GCZ0gPGuN0I=
X-Google-Smtp-Source: APXvYqyzCjS3eSbQS7p5mE1O0SYjXYtqs7nxGU+tFT8CGvMUUGQQTi26psof/asLi2c6bBtYG4HImkcIf9Jf0Au5CBU=
X-Received: by 2002:a54:448b:: with SMTP id v11mr11164112oiv.155.1572795365033;
 Sun, 03 Nov 2019 07:36:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:384:0:0:0:0:0 with HTTP; Sun, 3 Nov 2019 07:36:03 -0800 (PST)
In-Reply-To: <8c6d531f6474faf4df55f90185466774@codeaurora.org>
References: <1571734629-18028-1-git-send-email-zhichen@codeaurora.org>
 <d6cfd945-7bab-a01d-0157-e0e1802f66e3@eero.com> <8c6d531f6474faf4df55f90185466774@codeaurora.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Sun, 3 Nov 2019 16:36:03 +0100
Message-ID: <CAKR_QV+Qh_ErYduYoD8=u_i-y=cbKSJkkajtKxsJ5ML8-Z79EQ@mail.gmail.com>
Subject: Re: [PATCH RFC] Revert "ath10k: fix DMA related firmware crashes on
 multiple devices"
To:     zhichen@codeaurora.org
Cc:     Peter Oh <peter.oh@eero.com>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 30/10/2019, zhichen@codeaurora.org <zhichen@codeaurora.org> wrote:
> On 2019-10-23 01:16, Peter Oh wrote:
>>
>> How can you say value 0 (I believe it's 64 bytes) DMA burst size
>> causes the symptom and 1 fixes it?
>>
>> Peter
>
> Confirmed from HW team that the configuration controls AXI burst size of
> the RD/WR access to the HOST MEM.
> 0-	No split , RAW read/write transfer size from MAC is put out on bus as
> burst length.
> 1-	Split at 256 byte boundary
> 2,3- Reserved
>
> That's why we see issue with value 0.
>
> Zhi
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>

is this true for both wave1 and wave2 ? at least per this commit
message: ath10k: Fix DMA burst size
it's suppose to be:

0 - 128B max (not sure if this means 128B static, or any size between 0 and 128)
1 - 256B
