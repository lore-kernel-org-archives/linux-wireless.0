Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A26C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 073A020827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gg4uxfsn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 073A020827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbeKEVAG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:00:06 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51415 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVAG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:00:06 -0500
Received: by mail-wm1-f66.google.com with SMTP id w7-v6so7956898wmc.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 03:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=sSZ+nY7Ow848u960m0/ZmyEF67VEMYHhqnuCGAwnKg8=;
        b=gg4uxfsnShQ8TXqSXtal+lPTNekA5YPmHLaB/c86G7B6Am6gwFG6hBupgW/41q9He3
         g3b6SEfG/tj3sxIMgUH2U3WcYF0g0DjXwdP+qTJcOcAdv4DrTDBZ7agwn11nM1PXj9Uf
         3QEyiHyiO5p4ZPByRwoPtuDJAyi2JqYUjbXDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=sSZ+nY7Ow848u960m0/ZmyEF67VEMYHhqnuCGAwnKg8=;
        b=dKonDOabMgAPu76VdJBXJpsDa45sDB908N2mryhXex3steM1tQd7Gj3tFyTXsDNeeG
         830u6E542NOZ1VdmLu2CsUhL7h5GFXIGSi/caq7dlNb1tyjkHmPj372JQ3pwDnhB/nUe
         KcnFr7zZlJGpWo3jYGMVCiB5HJEgqA+zGtvK9Vh2/DlPOXFvFPXMq6DUeCncyVzYmv2I
         P5AB6vcDGIJVDTpUBLPLwcBHPz0cZKtVqTDrFNpLlC2sMhnlXZ21RnY1pA4pl2zRDKgG
         Et4SXk0Hawz9PhJYQdMASe7HWgusncD9lXi1bxFVlTUc1bmqsrzcPUHlFDdYVpPuQf26
         ubjg==
X-Gm-Message-State: AGRZ1gL3lg0cIw/poicju24Jgt//qc40cjvqXBdOQyvLyswzIGbv9T43
        DOKMdvNWPSBG9gIyoFWr1+PfBw==
X-Google-Smtp-Source: AJdET5d9n1+YObIGDfcQf4JHyIE+qoHz5heAv8aFGKfAc1WGdjuYw2Zl5zkRMTWuBF23lPICqWIgtw==
X-Received: by 2002:a7b:c00a:: with SMTP id c10-v6mr5787565wmb.73.1541418046702;
        Mon, 05 Nov 2018 03:40:46 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id f67-v6sm21346858wme.22.2018.11.05.03.40.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 03:40:46 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 1/6] brcmfmac: Remove firmware-loading code duplication
To:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
References: <20181009124755.25402-1-hdegoede@redhat.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-ID: <c6dd19e3-58e2-2eb2-5724-e6718b3fb2cf@broadcom.com>
Date:   Mon, 5 Nov 2018 12:40:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181009124755.25402-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/9/2018 2:47 PM, Hans de Goede wrote:
> brcmf_fw_request_next_item and brcmf_fw_request_done both have identical
> code to complete the fw-request depending on the item-type.
>
> This commit adds a new brcmf_fw_complete_request helper removing this code
> duplication.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/firmware.c    | 62 +++++++++----------
>  1 file changed, 31 insertions(+), 31 deletions(-)

