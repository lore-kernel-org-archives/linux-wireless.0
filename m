Return-Path: <SRS0=v6pW=XO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93501C3A5A6
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 18:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65DAE21907
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 18:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OK/yCCcw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AHauwgH4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392139AbfISS6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Sep 2019 14:58:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388943AbfISS6o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Sep 2019 14:58:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A308B61359; Thu, 19 Sep 2019 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568919523;
        bh=dG5mX7JocLh9XxgA0NIIRz0EESmdoJCFsaJgQeol7TQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OK/yCCcwGc705IIGsc+QSEdJJ3WbUVkglffVybDjj4AoB6vjJkJIroHD+crczKK9W
         JLJsCISrkTxpnXvUUlabJZOOGBoy5yDEzC1gndUb9tmXDdhxn37IQRlQqDMRMnRUFh
         bCnnC2sF047s03HleMmYLx0m8WsfTyllo2YzBtr8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4EAF6118C;
        Thu, 19 Sep 2019 18:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568919523;
        bh=dG5mX7JocLh9XxgA0NIIRz0EESmdoJCFsaJgQeol7TQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=AHauwgH40KXnT1k65Qih2u1feqKXZEskZTFRXKteamMVr8fa6sruhCg3dQiX0OfYW
         9cJgZ+1deWsg1WU8V5zifc1RDgg4jAbJZhyPytzneWafupMVpWzVK5uF+Mjt+wLKTc
         9BixhHde1CMmbBTsahgQNFGG28TaLDl9rGMngyaU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4EAF6118C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5.4] iwlwifi: mvm: fix build w/o CONFIG_THERMAL
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190918134903.10103-1-luca@coelho.fi>
References: <20190918134903.10103-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190919185843.A308B61359@smtp.codeaurora.org>
Date:   Thu, 19 Sep 2019 18:58:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Without CONFIG_THERMAL, the driver fails to link as it calls
> iwl_mvm_send_temp_report_ths_cmd() unconditionally. Fix this
> by making that function available, but do almost nothing but
> send the empty firmware command to enable CT-kill reporting.
> 
> While at it, also fix that function itself to not error out
> when the thermal zone hasn't been initialized, but instead
> just send the empty firmware command in this case as well.
> 
> Fixes: 242d9c8b9a93 ("iwlwifi: mvm: use FW thermal monitoring regardless of CONFIG_THERMAL")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

2d88b2cf2f00 iwlwifi: mvm: fix build w/o CONFIG_THERMAL

-- 
https://patchwork.kernel.org/patch/11150431/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

