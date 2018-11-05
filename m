Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E572AC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46EB204FD
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YAhmPIaN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A46EB204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbeKERxn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 12:53:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36398 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeKERxn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 12:53:43 -0500
Received: by mail-wm1-f68.google.com with SMTP id a8-v6so7103531wmf.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 00:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding;
        bh=ooNFWb/txfomn8OH+hL7QNNBEDhnVZN621YhYUYxfAo=;
        b=YAhmPIaNSrJTXougFNUeXZeLAA7jzYWNi0HxSGs2q9j1Ax8IonnRJs5Zckh935QC87
         Usd5M9bNK6xCOLJtCZAM+3muYgxCCteikJLBVoQrOL6BEiySmU5SzrKukpV4PlT9srBr
         iMRIqjkJbe27h1DgbWAtzrKugaJmGWUxKF0gM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ooNFWb/txfomn8OH+hL7QNNBEDhnVZN621YhYUYxfAo=;
        b=Cr41exR2SyN0kj2UuvAnw2epymBwB6JXi4ZCZIADxKYa3zvJBg3D8KCI7CnrSHK9jC
         Tg5fH4f5SserldFo3h4V+QbXNv/ztpxOKNyw7L+3a/MpumLXCvMSWVEXpGxSiVUjDJF7
         P4VTr4nwgRze3J0Eblvp7iVQ/GnIUDouzR73KhoMgQ3a7UWQE3iEaWRWJmlOibRULFGX
         UzABiaoig3hQXzbJa5hQuGwH36LUHlTPuQhPAsmmG4OBcAsl6AtXL8NuYibdZrX7INEq
         8uPO97SDIU52B8sFl1syiiuyxbQyXFSifT//9/LMmbix5xkxKIxMtROGg2oyoCtJrPDj
         c/DQ==
X-Gm-Message-State: AGRZ1gKuX+O0p19jwoW2KPfAl5MQgXc7XGotOPbAad0HBqhnj3mzTRXZ
        La0th0UomQof2Z+ieZynT4Pzp4DjFAslMA==
X-Google-Smtp-Source: AJdET5d4KdVm0EPYVrNxOhrZYhupk5Rln6iXpv5NUMFeq4tkyeh5rsH85MFbbTdulRbYrGSPBMc5hQ==
X-Received: by 2002:a1c:da82:: with SMTP id r124-v6mr5605327wmg.54.1541406909136;
        Mon, 05 Nov 2018 00:35:09 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y64-v6sm25380882wmy.35.2018.11.05.00.35.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 00:35:08 -0800 (PST)
Subject: Re: 7f9a3e150ec7d breaks brcmfmac with modparam roamoff=1
To:     Stijn Tintel <stijn@linux-ipv6.be>, linux-wireless@vger.kernel.org
References: <109f9a63-55ff-7a39-a710-e78e562950f3@linux-ipv6.be>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b1b06121-a1db-3aae-2d7f-5ec4175e202e@broadcom.com>
Date:   Mon, 5 Nov 2018 09:35:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <109f9a63-55ff-7a39-a710-e78e562950f3@linux-ipv6.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/4/2018 8:04 PM, Stijn Tintel wrote:
> [  259.240131] WARNING: CPU: 0 PID: 50 at
> /home/build/lede/build_dir/target-arm_arm1176jzf-s+vfp_musl_eabi/linux-brcm2708_bcm2708/backports-4.19-rc5-1/net/wireless/core.c:736
> wiphy_register+0x280/0xa58 [cfg80211]
> [  259.274067] Modules linked in: brcmfmac(+) pppoe ppp_async pppox

Hi Stijn,

Thanks for the report. The code fails on the check below:

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c0fd8a85e7f7..5fe35aafdd9c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -725,6 +725,10 @@ int wiphy_register(struct wiphy *wiphy)
  		    (!rdev->ops->set_pmk || !rdev->ops->del_pmk)))
  		return -EINVAL;

+	if (WARN_ON(!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FW_ROAM) &&
+		    rdev->ops->update_connect_params))
+		return -EINVAL;
+
  	if (wiphy->addresses)
  		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);

It seemed to makes sense to me at the time to have this check and I 
would say it still does. So I probably need to fix brcmfmac for this.

Regards,
Arend
