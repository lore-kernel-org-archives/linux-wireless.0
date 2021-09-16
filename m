Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B7DC4332F
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Sep 2021 17:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD61D60F23
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Sep 2021 17:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351445AbhIPRRT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:17:19 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:48888 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348477AbhIPRDG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1631811706; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=EfcnZrTuZpgen+YAamOSlpSJfZcIIanLDvLagHPxaRI=;
 b=Lakc9xTtDt0AfG8SlUEtOBJJrfT1Xgsjm2koDAJcAv6qxCh8kQiixNLPCk7EFBMJ7UWQj1l1
 wTLpA5U7OglOdD4aOFuVBF4sSbjZZfgQr880f46vIaGn7tew+X+2R51R0Mx4FWeq6QjZwBcj
 6QISmrIQMU3JhPGY86R6mF4mrts=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6143785865c3cc8c63ef6c76 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 16 Sep 2021 17:01:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 04F6FC4361A; Thu, 16 Sep 2021 17:01:12 +0000 (UTC)
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94964C4338F;
        Thu, 16 Sep 2021 17:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 94964C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mvm: Fix possible NULL dereference
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <iwlwifi.20210907143156.e80e52167d93.Ie2247f43f8acb2cee6dff5b07a3947c79a772835@changeid>
References: <iwlwifi.20210907143156.e80e52167d93.Ie2247f43f8acb2cee6dff5b07a3947c79a772835@changeid>
To:     Luca Coelho <luca@coelho.fi>
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org,
        dan.carpenter@oracle.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210916170112.04F6FC4361A@smtp.codeaurora.org>
Date:   Thu, 16 Sep 2021 17:01:12 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Ilan Peer <ilan.peer@intel.com>
> 
> In __iwl_mvm_remove_time_event() check that 'te_data->vif' is NULL
> before dereferencing it.
> 
> Fixes: 7b3954a1d69a ("iwlwifi: mvm: Explicitly stop session protection before unbinding")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

24d5f16e407b iwlwifi: mvm: Fix possible NULL dereference

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/iwlwifi.20210907143156.e80e52167d93.Ie2247f43f8acb2cee6dff5b07a3947c79a772835@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

