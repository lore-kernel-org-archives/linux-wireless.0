Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85B2C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 11:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 716BD205C9
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 11:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CDpNfC15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfAGL7B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:59:01 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39567 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfAGL7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 06:59:01 -0500
Received: by mail-yb1-f193.google.com with SMTP id n187so35616yba.6
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2019 03:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PimXPrn3y+06NYUJ8g1+BV7d5GEyzx96HNW3LOi2r8Q=;
        b=CDpNfC15q2yLsKkzG2+M022ScGfm9I+6To0ID+9ubEMTsYC+K7zIEk0TMIIpLqxTBb
         VRLXuGPrtojtAMwRumuL+1PPywj4VY7aAuNxIUWj/Y4BgrK7RUIBwichvd4YHaYtoDil
         RIo+UVYhDFVWpoRR89wZQo1wAcUZKxW3h0/8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PimXPrn3y+06NYUJ8g1+BV7d5GEyzx96HNW3LOi2r8Q=;
        b=egDePcgKT3aiFe8HBtgoFV+HY17iSYc2MykcKzXafkhI4VvWWwsuaA9UNk7IJ8gw35
         pqULW5XcW+bZ5QyLdMedeAfD+k8WGu1378v4xqfBltMbcggkbbAXsonLs4eDcmscu5kT
         XmjSJX7K/OpBrk4fStnjvi4xBLm8UZujMnirGtQM3QywFWEf77Gq1/Hv0JPOMs5l+keW
         LRQZl4Q3O0db5vAZhKz/VLrWY9E1uDsf9E6dRIrgSUtnC0Naf5XulfRlQwr0/7/HHLJ7
         XMSN8s665sDVuN66NJMTEZcLqmY2Zizny9RkY/8T2xfKMh5PSDhK0N5xPNCaKwNj5ta5
         4hdg==
X-Gm-Message-State: AJcUukf7d7h0n+o14XAbEfcVvigiXmZPNl9GY3LyNcMd9kDTNatBsSEh
        ibMc6rR1XY+jdSd7RBc3pO4PCQ==
X-Google-Smtp-Source: ALg8bN5YAc16f7ItP6ARxvW4Tk9dFBLKK0QL/PlTDM+E5vJjkUdXDCLk6aR0cEw1wAlpQh7uANU0TQ==
X-Received: by 2002:a5b:b8e:: with SMTP id l14mr48155334ybq.86.1546862340075;
        Mon, 07 Jan 2019 03:59:00 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id u4sm30644068ywu.92.2019.01.07.03.58.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jan 2019 03:58:59 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use request_firmware_direct for the clm_blob
To:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20190107113401.6824-1-hdegoede@redhat.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d6dafb19-4e88-c2c7-9547-2ebd5b4bec2e@broadcom.com>
Date:   Mon, 7 Jan 2019 12:58:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190107113401.6824-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/7/2019 12:34 PM, Hans de Goede wrote:
> The linux-firmware brcmfmac firmware files contain an embedded table with
> per country allowed channels and strength info.
> 
> These versions of the firmware are specially build for linux-firmware,
> the firmware files directly available from Broadcom / Cypress rely on
> a separate clm_blob file for this info.

Hi Hans,

It is a bit more subtle than how you put it here. It is more of an 
historical thing. The table used to be embedded in firmware only. Much 
later the clm_blob loading functionality was added so customers could 
get an updated blob file while using the same firmware. In our router 
business we still provide firmwares with embedded table. Cypress decided 
to move to a model in which the firmware contains a null table and needs 
clm_blob to get things going.

> For some unknown reason Broadcom / Cypress refuse to provide the standard
> firmware files + clm_blob files it uses elsewhere for inclusion into
> linux-firmware, instead relying on these special builds with the clm_blob
> info embedded. This means that the linux-firmware firmware versions often
> lag behind, but I digress.

Most of them are not special builds and provided to AOSP as well.

> The brcmfmac driver does support the separate clm_blob file and always
> tries to load this. Currently we use request_firmware for this. This means
> that on any standard install, using the standard combo of linux-kernel +
> linux-firmware, we will get a warning:
> "Direct firmware load for ... failed with error -2"
> 
> On top of this, brcmfmac itself prints: "no clm_blob available (err=-2),
> device may have limited channels available" and we will get a slow
> fallback to the userspace firmware loading mechanism.
> 
> This commit fixes both almost any brcmfmac device logging the warning
> (leaving the brcmfmac info message in pace), as well as the slow and

'pace' should probably be 'place' here.

> unnecesary fallback by switching to request_firmware_direct for
> the clm_blob.

As Kalle mentioned it is probably better to use the 'nowarn' api.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
