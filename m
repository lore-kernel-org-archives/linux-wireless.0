Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B57C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02E6C2081D
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sO33wcUl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02E6C2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbeKFAp4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:45:56 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:43862 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729749AbeKFApz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 19:45:55 -0500
Received: by mail-lj1-f171.google.com with SMTP id g26-v6so8370042lja.10
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 07:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=AtQvZbcAMxFC0T35DAd9qci+QJx3TP6YAfDIoyJdmaU=;
        b=sO33wcUl2/vRV1oXpGfvvuTyRk1MelHQe5sqWSpx89ds0v3Zoh7iCKZjxBH38l6Sd5
         gwY5EpjvD+xOgKXSqnWQwZJ4fRQUc6QM2c6iguMAwUx3IhmXEyzyoOP871eKGMdobBDw
         Ix+1fcMQ1CADRcwtAfzpUvg5cMRgdniqvPi1VACxndl428hgG2Kx78dfhl2B076a5QEx
         qtq/y4ogbG+mfb14RxlpumJSWpQJv+n8eyn6wHjW9CBAZPHepXABMW7BHEGykIV+ap03
         IotmHoYRQlYVTVlXkJUBUO+fmCMpAY3Z5QY2EIyR+UzxQpsuye65GThnaSTqxJfTTV7f
         qSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=AtQvZbcAMxFC0T35DAd9qci+QJx3TP6YAfDIoyJdmaU=;
        b=Ys+N7RiszMaPt8XERkKnMplbzA6jzXTW6T2Q4dRDnO9xvmt0GpBgy+X4s81c2pwLo+
         DlVkT/if6xswFSm+WkU1O1gGfLCneJMrCBIH3RrHUDeaO/Y0ykSTyg+YKW4jKUUCdpOS
         peHoKkJpf/G5TzOtdu1zxSf46Yfex0LOqvzsV8upHxijY8WYpBMspbOP60X2CqDoJOqo
         3E+763/Gj1TaYzT1PdfW/QrsWUA1bki40r79pF6vBcH3uONz1zVxA8+7TdFfoFNMDfdc
         rVO6f5c4WfafyjVZfQurwfjqHDjTAoRuL/N4A0iPj0SUq8aOZQoSrNuejOHbdW8kVoXK
         QjqQ==
X-Gm-Message-State: AGRZ1gLfAIIZaug877PojCaGgO2Pi923+/X5+NaElDIhax7VpionjuwL
        ecpRVbbT1Ng6PlaHNnKRtJin8TRa99RGDOdIWMBaiA==
X-Google-Smtp-Source: AJdET5egWLQv6q+/y4rSQnlQ9yxw3McW+jtjSnkCyMk3OBN5irR7w7vM+zhTx9G6DOUGPx1mlFU21ZUt0Evb8nFeFTE=
X-Received: by 2002:a2e:8606:: with SMTP id a6-v6mr12529657lji.43.1541431542217;
 Mon, 05 Nov 2018 07:25:42 -0800 (PST)
MIME-Version: 1.0
From:   sdnlabs Janakaraj <wsuprabhu@gmail.com>
Date:   Mon, 5 Nov 2018 10:25:30 -0500
Message-ID: <CAPWex-A1gtJ4NkWq395PNuqS06A9OT8rMmSBzEOJHSUupvn1TA@mail.gmail.com>
Subject: ath10k 802.11ac Mesh throughput
To:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I am using Compex WLE900VX wireless card. How do I force it use 3x3
MIMO in Mesh mode ?

Also, what is the best way to configure my wireless adapter to have
both Mesh mode and AP mode ? If someone can help me with this
configurations, I will be happy to document the process push it online
for our user.




Thanks,
Pj
