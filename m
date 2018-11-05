Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8E6C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF8D20827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UeMiiSPl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BF8D20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbeKEVBR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:01:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40048 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:01:17 -0500
Received: by mail-wm1-f67.google.com with SMTP id b203-v6so7731494wme.5
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 03:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=//z7l6DVI1abFt+VPZmQMCRCvkAOn/Gt6m2fzAYppIk=;
        b=UeMiiSPlElqs74M8QCMrX6Ubetabguwxwrl9787k+aUv+5AJOu1PjTK9pxQWlgnOQk
         GooC73zLeVtAmKdalNpZd/DECIUT7eZthv9ZoU0BWWRjVNLDPaYMD6pt05b3utf2lFCb
         mB38aBB5UHivVoeCCHSTO52McVhkwyph11jiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=//z7l6DVI1abFt+VPZmQMCRCvkAOn/Gt6m2fzAYppIk=;
        b=d4ndK+ioDwJPZeqykDMIN6aviuLuqz4wWbFPURfPv6qt4Z6xmQDfb3PBL/oRxw1gsQ
         fY1zyqE8I4W3u4XUqCKebUSl+IxKnEczcNlUTpavQXAsMYwqPz00HnxYH9NG9GwPIMqL
         Zv+OjZU0y/GEh3tFVo6l3mlrB44XU8Y0c6uav6T5mPtPvIOYwXssiZBxvt2s0P4uFPoP
         ISqmbAqLQumFn/YRXSUqMk43z/BHXRqlZKx2+hJqX6z5xDVvyVZsDQMAtXW0OxDjcifb
         NJaxY+qv5MMQOfN90meIow9WVChgc51rjBTKNJaP9RfOClxfAd73KARo93eKPO8pdUmp
         viYw==
X-Gm-Message-State: AGRZ1gKw9qKu03k8xLDO1seJUU7cmy5tg+GIE54FcD5aURFVtOKBA96a
        zVEnu/ypKS2c1rh14TJUPpkhfoOG3yGUjA==
X-Google-Smtp-Source: AJdET5eqQAtEt8cFCI1ZR+PSB9OXXjYClxzc/59kpzNvxA8SZObGV2RjBYG/MHzHwF7t6iGZgmtSpw==
X-Received: by 2002:a1c:b7c4:: with SMTP id h187-v6mr5677831wmf.70.1541418116823;
        Mon, 05 Nov 2018 03:41:56 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id o130-v6sm41217244wmd.11.2018.11.05.03.41.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 03:41:56 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 4/6] brcmfmac: Set board_type used for nvram file
 selection to machine-compatible
To:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-4-hdegoede@redhat.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-ID: <455259e6-91b2-53fd-b9aa-758fcdf777a7@broadcom.com>
Date:   Mon, 5 Nov 2018 12:41:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181009124755.25402-4-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/9/2018 2:47 PM, Hans de Goede wrote:
> For of/devicetree using machines, set the board_type used for nvram file
> selection to the first string listed in the top-level's node compatible
> string, aka the machine-compatible as used by of_machine_is_compatible().
>
> The board_type setting is used to load the board-specific nvram file with
> a board-specific name so that we can ship files for each supported board
> in linux-firmware.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/common.h |  1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 11 ++++++++++-
>  .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   |  1 +
>  .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |  1 +
>  4 files changed, 13 insertions(+), 1 deletion(-)

