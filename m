Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819E2C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 12:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 360892081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 12:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Y/TFx+tt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 360892081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbeKBVk1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 17:40:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53625 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeKBVk1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 17:40:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id v24-v6so1853758wmh.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 05:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=yQK2VtYhbZzRnoi//3rRK6keRVJkyfdKHpaXLbjGCsg=;
        b=Y/TFx+ttk2s7wUxv3WJoN0ruZP7FkibuCEhJbQ8dHuREbTk//L3glUTTIOkeGkh690
         rNCpoH7EO3HXcSh9EF4QOLk24ZFGHbV10b4rR2eNHyG9t8n729PxJaYm1ZxUp+fC4SO1
         vnLzGr+RSuw60vAWOB2ZdGCKQoymCav216yYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=yQK2VtYhbZzRnoi//3rRK6keRVJkyfdKHpaXLbjGCsg=;
        b=lTwdyDDJMwjFLiK2fCc6rGJDBWQtVNmEy9PHAJssJqzgAyVWofh5IroZQ1JyQQjzOl
         LhGwgKNQgdeH3WOW6qHKGcBUT8JM/VA9SEVF9BPiQg2ZGu5bySCkfVp2uA0wHininm4L
         3oooMkQ9q96iAVXo7aRhB2Mriq/q2Ji8cfG17EEjKBSxuaHZ18o4bmE0Wh2ImyDQ5kTa
         jEBiaIhMGKSY9qIymSMc5GIevMNrgykmaEYhn4VHR43ntEpKCNKRc44V5FSE3+q8nAPk
         hgPCaEhEGhEXYsW4PDuBVH14a+VSu4FN9BuvzIUkzPZ9Zvc+fzUr88n31XlW5e5T2q1x
         g8/w==
X-Gm-Message-State: AGRZ1gIZXGf/04xJmvbsrRln1ZW+LGuAwabfEdfr2eYbafeRz5UWnlJ6
        ht2AFNswCA5/6BJuqIILW7EUdw==
X-Google-Smtp-Source: AJdET5ezIFG3gtZzLiDgVC44HxTtwS8X8g+H6dvqyzjdLSy90a23okQ3W5xQ0OMrXyBi0btY4PMJaA==
X-Received: by 2002:a1c:a184:: with SMTP id k126-v6mr619082wme.32.1541162002837;
        Fri, 02 Nov 2018 05:33:22 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id x139-v6sm1683404wme.3.2018.11.02.05.33.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 05:33:22 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] brcmfmac: throughput enhancement for flow control
 mode
To:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20181102082403.11676-1-wright.feng@cypress.com>
Cc:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5407f6d8-c94e-4ec6-56ab-054561765aa8@broadcom.com>
Date:   Fri, 2 Nov 2018 13:33:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181102082403.11676-1-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/2/2018 9:24 AM, Wright Feng wrote:
> The patches are for throughput enhancement with flow control mode enabled
> and introduce a new module parameter to enhance TX throughput as well.
>
> Changes since v1:
>    Remove the patch "calling skb_orphan before sending skb to SDIO bus"
>    Revise the patch "brcmfmac: add credit numbers updating support"

I also saw a patch Chi-Hsien Lin regarding fwsignal support. It would be 
good if that patch was part of this patch series as they seem dependent 
or at least related.

Regards,
Arend

> Wright Feng (2):
>   brcmfmac: add credit numbers updating support
>   brcmfmac: make firmware frameburst mode a module parameter
>
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    |  7 ++++++
>  .../broadcom/brcm80211/brcmfmac/common.c      |  5 ++++
>  .../broadcom/brcm80211/brcmfmac/common.h      |  2 ++
>  .../broadcom/brcm80211/brcmfmac/fwil.h        |  1 +
>  .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 23 ++++++++++++-------
>  5 files changed, 30 insertions(+), 8 deletions(-)
>

