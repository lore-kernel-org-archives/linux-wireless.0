Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D9AC64E7C
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Dec 2020 18:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 741B022249
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Dec 2020 18:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbgLBS3O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Dec 2020 13:29:14 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:49292 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389487AbgLBS3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Dec 2020 13:29:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606933729; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=0Yojjsqx1Zc13osDLIGhsE8pvvq8XrNhxySyf/S6H98=;
 b=k0htDf9Qz+mSB+XvsddATEMEjdDJe4FWwd5tLiJL0zQ9agjHlCkcvvrL9s/RJsKm+pk/7EP3
 QT+Xy+kcyp8GCzA7B2rPzTCE0UIZOFgwcBk2Jvrz24ewMKqwSkZHrl+eeY5dQYORvggpXcHN
 mkGeJKVpaJTm+rPqIMrG0K2N9VQ=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fc7dcc62ef3e1355ff9e667 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 18:28:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 37D46C43464; Wed,  2 Dec 2020 18:28:22 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0205C43460;
        Wed,  2 Dec 2020 18:28:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0205C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] ath10k: Fix the parsing error in service available
 event
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1605501291-23040-1-git-send-email-pillair@codeaurora.org>
References: <1605501291-23040-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201202182822.37D46C43464@smtp.codeaurora.org>
Date:   Wed,  2 Dec 2020 18:28:22 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> The wmi service available event has been
> extended to contain extra 128 bit for new services
> to be indicated by firmware.
> 
> Currently the presence of any optional TLVs in
> the wmi service available event leads to a parsing
> error with the below error message:
> ath10k_snoc 18800000.wifi: failed to parse svc_avail tlv: -71
> 
> The wmi service available event parsing should
> not return error for the newly added optional TLV.
> Fix this parsing for service available event message.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00720-QCAHLSWMTPL-1
> 
> Fixes: cea19a6ce8bf ("ath10k: add WMI_SERVICE_AVAILABLE_EVENT support")
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c7cee9c0f499 ath10k: Fix the parsing error in service available event

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1605501291-23040-1-git-send-email-pillair@codeaurora.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

