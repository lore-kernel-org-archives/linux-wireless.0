Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083C5C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 11:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C5920895
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 11:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CZtvVFGH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fv/Jffjb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2C5920895
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbeJMT0X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 15:26:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38234 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbeJMT0X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 15:26:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9E73F60A98; Sat, 13 Oct 2018 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539431373;
        bh=lWDaZVSl6HjgZSzAzB4rgL0a6BAyWssEjUr6oOlGjTU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=CZtvVFGH86SVg4BVSLnJbt9Zaa7q374RDaKN5e4VT4O7q2oMqREcCYRvKiL3/1lwR
         B1okSBSssS2gG4j4W8jCR38AULTu+nGG9pmR9318EEZ+BeHS9uL9NRLefzPDcJmpYA
         S7EvgGJm9Q21Edw2NfftTHeR3kVNynws18fYLYcg=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37E8260209;
        Sat, 13 Oct 2018 11:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539431373;
        bh=lWDaZVSl6HjgZSzAzB4rgL0a6BAyWssEjUr6oOlGjTU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Fv/Jffjbfc+olw18ireNnkITAUTDNWFRbbzg4ZHCB/XxvfN+2nXFKbLWDPveDz0Ww
         4kdtWXnTjgscPiAaap6uUguNVxirO1qoW7iQlKXZIB1kcCZ3FBwVUFN2mmUAqdych3
         3LCx0X5+SZtd5Du7hD2+xd/5GmnXQXlVRv7HmPvc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 37E8260209
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mvm: check return value of
 rs_rate_from_ucode_rate()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181013064608.31952-1-luca@coelho.fi>
References: <20181013064608.31952-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013114933.9E73F60A98@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 11:49:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> The rs_rate_from_ucode_rate() function may return -EINVAL if the rate
> is invalid, but none of the callsites check for the error, potentially
> making us access arrays with index IWL_RATE_INVALID, which is larger
> than the arrays, causing an out-of-bounds access.  This will trigger
> KASAN warnings, such as the one reported in the bugzilla issue
> mentioned below.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=200659
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

3d71c3f1f50c iwlwifi: mvm: check return value of rs_rate_from_ucode_rate()

-- 
https://patchwork.kernel.org/patch/10639957/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

