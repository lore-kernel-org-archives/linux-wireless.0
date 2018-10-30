Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422D2C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 11:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB02A20823
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 11:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ctdoC8Sl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB02A20823
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbeJ3U0b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 16:26:31 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37776 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbeJ3U0a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 16:26:30 -0400
Received: by mail-yb1-f196.google.com with SMTP id d18-v6so4849816yba.4
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2018 04:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=6nqXQN7NxssDgAtly41B7ASun0shR5VGpnf0xJLyRvs=;
        b=ctdoC8SlATJum6s18E1WFH+TUvzGFC98AQ/4CvSWKdf+zEOuJHpZ90WRiJBdb54PcR
         ZtuLGor6LS7u2YzHtqQoM9PhYA0CehkGWBD7Q+SaQMd7SQQYYBqmVF/eQ9SRx5C2D/A0
         5cJw6NTZb33604eA9D/db/wJfFqVEmQh/0e+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=6nqXQN7NxssDgAtly41B7ASun0shR5VGpnf0xJLyRvs=;
        b=lioigbJYrk1Iq3EPq93BE0T5yx+QOhuvYhSNq8nZ0rTFzfjLKTL7+9f9Ooyjoxq61j
         ZBTXcSaf4tlP8e19NQsf4BMlH5z4h91We4up+nza0BRGYYzcG+SnuXNjrTco04FwJQHX
         wypdazJkKUlehdgG4hxhUsJa6arm7JSoVVXiQHjfDBGyWck3WvpEfb9X1RedOPnfPgFD
         soh0kZ1c1WPVEy9y1QbC2HTHpB2l2f9ilI7mxRcsEu1PgiEPXpgL4prHkDyxYU5MzMIS
         K3FmxmM6HQM8aPcWVPDcm5gPHMCg3jHD7pckXjTXmbn7P7P4gYc+hHl3SL3Oo/BsTxK4
         zvtA==
X-Gm-Message-State: AGRZ1gJoowi7T6kPUgEWT7Qix8CSO5F0SIzL6lZbuHXrvDNJ8zynl2Ei
        my1KEMuS13qHed3ZA1UFRf1NoQ==
X-Google-Smtp-Source: AJdET5eV2aGBJHtd1SFfObrst6MpYBGCiGLyd7BbGEhB4+8xKZpo6Y1Czb1Pt5RmWCr63l+A4Irl6w==
X-Received: by 2002:a25:504e:: with SMTP id e75-v6mr17532035ybb.41.1540899203457;
        Tue, 30 Oct 2018 04:33:23 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id g21-v6sm3812049ywk.5.2018.10.30.04.33.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Oct 2018 04:33:23 -0700 (PDT)
Subject: Re: [PATCH 3/3] brcmfmac: make firmware frameburst mode a module
 parameter
To:     Wright Feng <Wright.Feng@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1540808552-28738-1-git-send-email-wright.feng@cypress.com>
 <1540808552-28738-4-git-send-email-wright.feng@cypress.com>
Cc:     "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7292b499-96a6-96be-f9b7-e59df353427f@broadcom.com>
Date:   Tue, 30 Oct 2018 12:33:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1540808552-28738-4-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/29/2018 11:27 AM, Wright Feng wrote:
> This patch is for adding a new module parameter "frameburst".
> With setting "frameburst=1" in module parameters, firmware frameburst mode
> will be enabled. The feature can enable per-packet framebursting in
> firmware side and get higher TX throughput in High Throughput(HT) mode.

I am not sure about every firmware image, but in recent branches here I 
see firmware enables frameburst by default. So not sure about the 
motivation to add this. You could also consider adding this to the 
nl80211 api. I am sure other vendors have similar features.

Regards,
Arend

> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 +++++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c   | 5 +++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h   | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.h     | 1 +
>  4 files changed, 15 insertions(+)

