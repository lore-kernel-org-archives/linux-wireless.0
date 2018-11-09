Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247F7C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B332081C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fTN+vJo9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6B332081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbeKIWaC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:30:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55892 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbeKIWaC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:30:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10-v6so1905490wmc.5
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 04:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=zAnMdBE4YwsTBbatsiaJMrRZ890a8jjA1NLQW4u6kZs=;
        b=fTN+vJo9DOUer4BWHwJr+faBmjLTnjxXxY785ccNKxdZRDmaDv2sVJqgPRhzKTRYFq
         osMaEIoYgSe/S1yric2qi/hjvvR0aTgHXhaPiuHe+4+EDrfiXDAfjHAN+FA8iamVojMG
         BWYAnrrnBrZPFutP7POjggSfoa7NqGu3Sp2wQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=zAnMdBE4YwsTBbatsiaJMrRZ890a8jjA1NLQW4u6kZs=;
        b=jWwNAQfDrQXd2N/0NbpboHOT2UeiSuYJSbabzWKD3+vSJbqMiTBBzni9lU+uiiuwnl
         hQLtrpr2D0dE4T+NXqFa4B8d9oiT+9y0M4f4W2pUxUEpmXa9b4zpMbhQUkPLninvCYw/
         kO354LfrLYmlAHPY6kHAtyiKVTDvFYcbP+SsRIt2RUv0BGb7a5gYZzX3bPlMkE5vIi6d
         sz5+AstqP7IaWqOLQ1Uuy/y86fJfU7THC9umaNOxZzb/+drC5wHMNeigpVbR0MbI6MlP
         Ccq+nZ0ZJFlMsDDfyFJdp0QnTILYPsmeMOstyEVU4tZlsxhxVw67LLvZxxQiBSf7FFlD
         /jog==
X-Gm-Message-State: AGRZ1gJnPWEE3c6R0CmeMp8Hmt9+bpBGQTw2taiHJUrBX+PkNi4Jine1
        XM6kSTFNJECJPzI9S7VBboeqAA==
X-Google-Smtp-Source: AJdET5d14AtsmBGfHJr6e4DRImpvred8p4/jKsEt3uM7FESJD4TiYPSlm5Ls/0wsUoHg5oSbi/GRdA==
X-Received: by 2002:a1c:930d:: with SMTP id v13-v6mr4605902wmd.26.1541767772020;
        Fri, 09 Nov 2018 04:49:32 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id v3-v6sm1033836wmf.2.2018.11.09.04.49.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 04:49:31 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 5/5] brcmfmac: add vendor ie for association responses
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541648845-194984-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541648845-194984-6-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ryohei Kondo <Ryohei.Kondo@cypress.com>
Message-ID: <c4a98211-496b-c3ef-dfa0-bcce53129be4@broadcom.com>
Date:   Fri, 9 Nov 2018 13:49:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541648845-194984-6-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/8/2018 4:48 AM, Chi-Hsien Lin wrote:
> From: Ryohei Kondo <ryohei.kondo@cypress.com>
>
> Miracast Certification clause 6.1.2 may fail if there is no WFD IE in
> p2p assoc response. This change allows WFD IE to be added to p2p assoc
> response.
>
> Related WFA certification:
> 6.1.2 P-SnUT operating as a Group Owner accepts a WFD Session with a
> Reference Source

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ryohei Kondo <ryohei.kondo@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14 ++++++++++++++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h    |  4 ++++
>  2 files changed, 18 insertions(+)

