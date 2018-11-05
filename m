Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388C1C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01BDE20827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PY2+rD10"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01BDE20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbeKEVAP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:00:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33002 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbeKEVAO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:00:14 -0500
Received: by mail-wr1-f65.google.com with SMTP id u1-v6so9160975wrn.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 03:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=u1mmEXPFJsh3KfKjo58ws4rr8Qb/SY5orzs+Tu46uJc=;
        b=PY2+rD10HvEqs8WEsOkjuMrjh9tmmgakuFUYZtOUJkYsvquZUYffvQ/Oq0Qx0dsNxy
         A4Npv54myEAViaCtxGu7tmrxZjT9yIgHDYiAowsJmEpuE1AQpj69dU/SV38No+2JUIWA
         R7dJpYGrsQp+rXSAYkwPTTvt5NMxSOvGG4kf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=u1mmEXPFJsh3KfKjo58ws4rr8Qb/SY5orzs+Tu46uJc=;
        b=rggx6F38yNdsJ8RzmwpFcSTYnLHUZOp3XLXSg92baPn0uorwjYsfQDAzjGSRi24Uew
         pvCHvAzdReM0wE1lOPd4gOFJ9PgRiosF6Ma6PzKCrIgdZk46hNSUo7KL+Is/cQ/pA3CJ
         pTCW23aEuOskANaK4M0g5xlK5ON7auu+LoJFgK2vhlzpouAHKVDOZ01MgkqPr0dTY2FE
         Cnm2vPyCEOIp844ztAs6Poe+5MpnuB9YKauNTvEYQfBfOZQbUITmBAo1ntiv+4yN38Iv
         R4jUndZuAkRkqAUVJHBGCTnuhpaIOMPsSuLFmbUBmZnJdD74Jbxifx+01eGMO4PMRAWI
         jBHQ==
X-Gm-Message-State: AGRZ1gLO/C+iGRRi0Gw22w0Na/nD/Dtr/qSI+Yc0Ao6CL8YTE0z76Xsr
        NYNTxrVpCTXukxmgBZGBDz8OvQ==
X-Google-Smtp-Source: AJdET5dP57098nV2RUnW3xynfSRXLDDsyjbCb5wiiXAw66DKGcZ/MPjfCn0y8dg3DRbfBYNo2vjIeQ==
X-Received: by 2002:adf:ba52:: with SMTP id t18-v6mr3853872wrg.325.1541418055064;
        Mon, 05 Nov 2018 03:40:55 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id q4-v6sm1010496wrr.43.2018.11.05.03.40.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 03:40:54 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 2/6] brcmfmac: Remove recursion from firmware load error
 handling
To:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-2-hdegoede@redhat.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-ID: <cb4731f4-6609-553a-bd5c-2a8f0129dc3e@broadcom.com>
Date:   Mon, 5 Nov 2018 12:40:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181009124755.25402-2-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/9/2018 2:47 PM, Hans de Goede wrote:
> Before this commit brcmf_fw_request_done would call
> brcmf_fw_request_next_item to load the next item, which on an error would
> call brcmf_fw_request_done, which if the error is recoverable (*) will
> then continue calling brcmf_fw_request_next_item for the next item again
> which on an error will call brcmf_fw_request_done again...
>
> This does not blow up because we only have a limited number of items so
> we never recurse too deep. But the recursion is still quite ugly and
> frankly is giving me a headache, so lets fix this.
>
> This commit fixes this by removing brcmf_fw_request_next_item and by
> making brcmf_fw_get_firmwares and brcmf_fw_request_done directly call
> firmware_request_nowait resp. firmware_request themselves.
>
> *) brcmf_fw_request_nvram_done fallback path succeeds or
>    BRCMF_FW_REQF_OPTIONAL is set

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/firmware.c    | 65 ++++++-------------
>  1 file changed, 19 insertions(+), 46 deletions(-)

