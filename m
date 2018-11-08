Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F52C32789
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E36A20892
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 11:54:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PwQL7TB5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E36A20892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbeKHV3K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 16:29:10 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46782 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbeKHV3K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 16:29:10 -0500
Received: by mail-yw1-f66.google.com with SMTP id v5-v6so3414905ywa.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 03:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=QnKwAS/O7/QJYTTf1HOArIKn5CNHrCM7LVjGr2wVPds=;
        b=PwQL7TB5Zq0H6zswLQ07bh8/GLQSGhYtBRQTAJKiJl1keO8/DjO8eBW5Z/bxwzrK2f
         tc3STK82OKQ0nXEuAlUqqHmqix5BqRd4BqgFHqJpIJH9iwOos1dzxzopPtzmmbENgF+s
         JfpeV7dyPo1J9Ljjp1scYCIvLpba+NcS5JSNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=QnKwAS/O7/QJYTTf1HOArIKn5CNHrCM7LVjGr2wVPds=;
        b=Dg7I3HBF4RdnSi+S4THui3PVjILsXQRzc4f7Zjx7J+varVBcvSayq1UgEoK5ZbL1o6
         wdk21sPKjtdZa8CAKPOmsrTuABS2+9Vg4m2qlfuAljWSV0aK/4PgpXQoaHi6E8ZOKj0M
         dq04fHVHIN/ftOpWem2g9LXGEyFU+UyrQ/UTUyoG7tXpYeUQnRiIrU4MNHAXCNXkuQ9y
         vkpJbC8Ep0eC7tZIzPm/FR9e5bUbpWpTuPwZKMgsgKaOMZzBVGAk2BW1SDX1WYO30/Rg
         GGuAnImJObXskT6vmLKE2jpB81Lf2LF7Ers17E5kXOmAR1YLo6+BuJ7G2MqSu34G2WaX
         4l1Q==
X-Gm-Message-State: AGRZ1gL2HULcjFZLGy4twnqUJpx6gJfHEVRKd3CkDDlkd1TDlMLBv0BW
        JUXDffgJ+wRK3mtjzql5L+UWOw==
X-Google-Smtp-Source: AJdET5dNSBzBOSIJb7PGmU2LKxswPifNP82bBdYOpj4510Y8ss+VPFnWRuOy/ZsX3tym4ETAYTAtow==
X-Received: by 2002:a81:130c:: with SMTP id 12-v6mr3816721ywt.340.1541678041196;
        Thu, 08 Nov 2018 03:54:01 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id r185-v6sm1542848ywd.40.2018.11.08.03.53.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 03:54:00 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 07/11] brcmfmac: update 43012 F2 watermark setting to fix
 DMA Error during UDP RX Traffic
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1541476188-75475-1-git-send-email-chi-hsien.lin@cypress.com>
 <1541476188-75475-8-git-send-email-chi-hsien.lin@cypress.com>
Cc:     "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <Naveen.Gupta@cypress.com>
Message-ID: <85794718-5269-1dae-1b04-bc89b83f8e44@broadcom.com>
Date:   Thu, 8 Nov 2018 12:53:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1541476188-75475-8-git-send-email-chi-hsien.lin@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/6/2018 4:50 AM, Chi-Hsien Lin wrote:
> From: Naveen Gupta <naveen.gupta@cypress.com>
>
> The number of words that the read FIFO has to contain except
> the end of frame before sends data back to the host.
> Max watermark = (512B - 2* (BurstLength))/4 =
> (512 - 128)/4 = 384/4 = 0x60
> so if burst length (i.e. BurstLength = 64) is increased,
> watermark has to be reduced. This is the optimal setting for this chip.

Nice formula. So could the BurstLength be retrieved from firmware so the 
driver can determine and update the F2 watermark in 
brcmf_sdio_bus_preinit().

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Naveen Gupta <naveen.gupta@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

