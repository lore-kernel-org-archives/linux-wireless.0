Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3361AC07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF2CE2084A
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 12:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dN+Rkdcx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF2CE2084A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbeLKMon (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 07:44:43 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40400 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbeLKMon (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 07:44:43 -0500
Received: by mail-yw1-f66.google.com with SMTP id r130so5356912ywg.7
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 04:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CxA7/fBzVRTtDg+3DEDlaUKVQ1UPYACwDSBUey13GHg=;
        b=dN+Rkdcx/x/Cs34rlDRQC5UB36D+NJwR2CFhYLSrDemNJkR/ljqX9CnaxxXgnZKOL0
         ZQifXF2tXYunAhfh1CPHQOBLocYgegw68kWQsT7WLwnBICYrT8KvmUauuT1Z7252zKLr
         6TFmSGwF/atrgKdqA0ThIVTY9zpv7Gi5jPvwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CxA7/fBzVRTtDg+3DEDlaUKVQ1UPYACwDSBUey13GHg=;
        b=Im/4I2DSBSEEbkTGB2gPHLRvFA82mC+V5bdeBAGpfanekFKfOlLiG4RGKzm+OIKlrP
         RWXWFmwdMZ71OtqpAs4JrMJzV3goH+RrPXh3VmsC3VJXdwGdV1PP6mkmnV3G7MVPiLJv
         9QufJQgxQYxlR9oOrYwtYBDp0O8M77lpIoR7qfnzkjq7j0QP426lTtZM6KEsBxJkU3w0
         p2D0SCWKfnlpZDXap7H3FbTp3qNlJ6f243i7Ymx/cxPIp1tBmgkEPCWGHhRIMwkvFveb
         cc7zAr5pWcZIwaN5UT6s5sQ6Inb6uTfFMG52HjHDqSr7UOd+0y8b4hdKBX/t91TzM7Ti
         3RJQ==
X-Gm-Message-State: AA+aEWaLfplUwXhsnxh9yIkqz8cBJwm4r4X4LTF01c6tHZWnYuIdLM3D
        kttrFbAMHdXCoQ3VGMa2gSx+1Q==
X-Google-Smtp-Source: AFSGD/VJoViiw4zIxpX5sQrwAxfBAaGnMXqHJQ/iic32UEEklFr2sYNl0Nln5tIPmykayq77B+xwkQ==
X-Received: by 2002:a81:2548:: with SMTP id l69mr16158169ywl.397.1544532281842;
        Tue, 11 Dec 2018 04:44:41 -0800 (PST)
Received: from [10.176.51.60] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y1sm4653554ywe.86.2018.12.11.04.44.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 04:44:41 -0800 (PST)
Subject: Re: [PATCH v3 3/3] brcmfmac: handle compressed tx status signal
To:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>
References: <20181105055137.13333-1-wright.feng@cypress.com>
 <20181105055137.13333-4-wright.feng@cypress.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <961a7059-7940-fbdf-caab-2a37a06059fb@broadcom.com>
Date:   Tue, 11 Dec 2018 13:44:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181105055137.13333-4-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/5/2018 6:52 AM, Wright Feng wrote:
> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> Firmware inform the driver about tx status by normal tx status signal
> or compressed tx status signal. This patch adds support to handle the
> compressed tx status signal.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v3: Add this patch into this series
> ---
>   .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 121 ++++++++++--------
>   1 file changed, 71 insertions(+), 50 deletions(-)
