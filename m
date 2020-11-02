Return-Path: <SRS0=EpEU=EI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FA9C00A89
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 17:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18E8C20657
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Nov 2020 17:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="S/VqbvB7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgKBRPd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:15:33 -0500
Received: from z5.mailgun.us ([104.130.96.5]:17191 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbgKBRPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Nov 2020 12:15:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604337332; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=GK/1Mr2kF0Nc9OODRidv+8GJ+vdyOPdP+l+eWo/8/U0=; b=S/VqbvB7rMD+dsFV6U/ZIgrqkhlM6sU9Iy3JrFIsnK+NSBsjQq9bQGBQf50a9SOGzKnFvkAb
 q95hcQknmjwfmmkt76t1kkUgWz5jDLBiud23lFxud60fCv/YEh/8UaXJSWc/u+tp7ckikvGA
 H4lFFSzR+yHmwsh6JsHcmddPrtc=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5fa03eb493c4278c7237355b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Nov 2020 17:15:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6AED4C433A1; Mon,  2 Nov 2020 17:15:32 +0000 (UTC)
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C038EC433C6;
        Mon,  2 Nov 2020 17:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C038EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Seung-Woo Kim <sw0312.kim@samsung.com>
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, smoch@web.de,
        sandals@crustytoothpaste.net, rafal@milecki.pl, digetx@gmail.com,
        double.lo@cypress.com, amsr@cypress.com, stanley.hsu@cypress.com,
        saravanan.shanmugham@cypress.com, jean-philippe@linaro.org,
        frank.kao@cypress.com, netdev@vger.kernel.org,
        jh80.chung@samsung.com
Subject: Re: [PATCH v2] brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}
References: <CGME20201028015033epcas1p4f3d9b38b037ff6d4432e1a2866544e38@epcas1p4.samsung.com>
        <1603849967-22817-1-git-send-email-sw0312.kim@samsung.com>
Date:   Mon, 02 Nov 2020 19:15:23 +0200
In-Reply-To: <1603849967-22817-1-git-send-email-sw0312.kim@samsung.com>
        (Seung-Woo Kim's message of "Wed, 28 Oct 2020 10:52:47 +0900")
Message-ID: <87pn4vof2s.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Seung-Woo Kim <sw0312.kim@samsung.com> writes:

> There are missig brcmf_free() for brcmf_alloc(). Fix memory leak
> by adding missed brcmf_free().
>
> Reported-by: Jaehoon Chung <jh80.chung@samsung.com>
> Fixes: commit 450914c39f88 ("brcmfmac: split brcmf_attach() and brcmf_detach() functions")

This should be:

Fixes: 450914c39f88 ("brcmfmac: split brcmf_attach() and brcmf_detach() functions")

But I can fix that, no need to resend because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
