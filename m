Return-Path: <SRS0=wavk=CJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1667C433E2
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Aug 2020 15:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C65AB20767
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Aug 2020 15:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="UB6lb4Ap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgHaPTx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 Aug 2020 11:19:53 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:23676 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728109AbgHaPTx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Aug 2020 11:19:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598887193; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=RWOS40LHxnB4cN9/rrpLElSswicob5Pl/GeeENE0Pmw=;
 b=UB6lb4Apb6RZ6i8Hss0PRSCuDsxJwwcmYq1WZA9ciIAfJWKH+cxqmAnLhsZIEVDOg71bQESM
 wSy05Dv2e1rIkUboBDtMj73VHD1ZBOd16KNSjS0ErMjNuL9oJNrDE5fITwhKuacZjY77i/aX
 O5t3kS2TU1M1fkrpe0ZwtH2mwXs=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f4d150eba408b30cedd9717 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 31 Aug 2020 15:19:42
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5D233C43387; Mon, 31 Aug 2020 15:19:41 +0000 (UTC)
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0AFC7C433C6;
        Mon, 31 Aug 2020 15:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0AFC7C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 08/30] net: wireless: ath: carl9170: Convert
 'ar9170_qmap'
 to inline function
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200827093351.GA1627017@dell>
References: <20200827093351.GA1627017@dell>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200831151941.5D233C43387@smtp.codeaurora.org>
Date:   Mon, 31 Aug 2020 15:19:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> 'ar9170_qmap' is used in some source files which include carl9170.h,
> but not all of them.  A 'defined but not used' warning is thrown when
> compiling the ones which do not use it.
> 
> Fixes the following W=1 kernel build warning(s)
> 
>  from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>  In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
>  drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning: ‘ar9170_qmap’ defined but not used [-Wunused-const-variable=]
> 
>  NB: Snipped - lots of these repeat
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

859228a3ae82 carl9170: Convert 'ar9170_qmap' to inline function

-- 
https://patchwork.kernel.org/patch/11740469/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

