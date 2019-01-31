Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CDBC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FE3C2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RiGKLrxV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RlUjJNfk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfAaNet (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:34:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33668 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfAaNet (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 08:34:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AB603605FC; Thu, 31 Jan 2019 13:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548941688;
        bh=M3DCYNIJNV1WsHVRQel+T3Iz2fw9UwqRQfKz93ghgx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RiGKLrxVh9ci5c72VYgrWnKB2ljxDshCHfC9N3Rpyfpb5K/FpOY2zqqSJz/7MxZx2
         HGcurLK0xcGyxcwF2o7zhdsyJmLnwskkLyYoX5cuvVihihboz6BBxDKw6gsFFhIdhq
         82H5YYU/oIwuf3dPNY62CWA061Ot9zV641Fs6vg4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3E7EC60265;
        Thu, 31 Jan 2019 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548941688;
        bh=M3DCYNIJNV1WsHVRQel+T3Iz2fw9UwqRQfKz93ghgx8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=RlUjJNfkbUKmYVa7bmQ25r5hmNqYOtFiXX5Y9chTX++YGnfpVeRHbAn64cwK1FViO
         1v9xZCYOhu/usdhay/ByNahVOHBNmzYuJb1+pgaNyryxARZ/wVSaiXrJDXlJ6TvxEA
         fWsd6y+TL//QSRn1eDEznU2LakxCFz9qyrWAaCdQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3E7EC60265
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: mvm: fix merge damage in iwl_mvm_rx_mpdu_mq()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190130123811.26839-1-luca@coelho.fi>
References: <20190130123811.26839-1-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190131133448.AB603605FC@smtp.codeaurora.org>
Date:   Thu, 31 Jan 2019 13:34:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Luca Coelho <luciano.coelho@intel.com>
> 
> A call to iwl_mvm_add_rtap_sniffer_config() was missing due to a merge
> damage when I submitted the patch mentioned below.  And this causes
> the following compilation warning:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:195:13: warning: 'iwl_mvm_add_rtap_sniffer_config' defined but not used [-Wunused-function]
>  static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix it by adding the if block that calls this function.
> 
> Fixes: 9bf13bee2d74 ("iwlwifi: mvm: include configured sniffer AID in radiotap")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

3864be551405 iwlwifi: mvm: fix merge damage in iwl_mvm_rx_mpdu_mq()

-- 
https://patchwork.kernel.org/patch/10788503/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

