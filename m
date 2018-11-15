Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A153C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 251052145D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SKqMaP8l";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SKqMaP8l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 251052145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbeKPBAy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 20:00:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54408 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388239AbeKPBAx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 20:00:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D83FB615E1; Thu, 15 Nov 2018 14:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542293564;
        bh=xHT6ATAUvBajjTVyIhSnjW4Hi3L7PcTcDLKIOsCKyL0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SKqMaP8lDlDzPmyCtodM2w0cS8M+aJWHCs3s2gZ4KtLo3+CZiQvMWo/jODT77Yjrl
         jsfBl9NNJ97FG7WGDC4nOJrESZE4TnkPDhj/Ybk04P0c5Zqx75uQFlqS+uaGMLp/1e
         A8Erqw+x5mO+3YNv9CW8MgTauOWAeHdMErjPUPvw=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EE9A0615DC;
        Thu, 15 Nov 2018 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542293564;
        bh=xHT6ATAUvBajjTVyIhSnjW4Hi3L7PcTcDLKIOsCKyL0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SKqMaP8lDlDzPmyCtodM2w0cS8M+aJWHCs3s2gZ4KtLo3+CZiQvMWo/jODT77Yjrl
         jsfBl9NNJ97FG7WGDC4nOJrESZE4TnkPDhj/Ybk04P0c5Zqx75uQFlqS+uaGMLp/1e
         A8Erqw+x5mO+3YNv9CW8MgTauOWAeHdMErjPUPvw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EE9A0615DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 08/16] iwlwifi: trans: parse and store debug ini TLVs
References: <20181111200732.8159-1-luca@coelho.fi>
        <20181111200732.8159-9-luca@coelho.fi>
Date:   Thu, 15 Nov 2018 16:52:40 +0200
In-Reply-To: <20181111200732.8159-9-luca@coelho.fi> (Luca Coelho's message of
        "Sun, 11 Nov 2018 22:07:24 +0200")
Message-ID: <87d0r69yvb.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Sara Sharon <sara.sharon@intel.com>
>
> The new debug ini TLVs can be either packed into firmware
> binary or written in external file. Support loading them
> from both. Store the data per apply point. Apply point is
> a point during driver runtime, where the TLV becomes active.
> For example, a trigger of hardware error may be configured
> to collect a subset of data pre-alive, as a opposed to HW
> error that occurs after alive.
>
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> @@ -1749,6 +1762,10 @@ MODULE_PARM_DESC(lar_disable, "disable LAR functionality (default: N)");
>  module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable, uint, 0644);
>  MODULE_PARM_DESC(uapsd_disable,
>  		 "disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3)");
> +module_param_named(enable_ini, iwlwifi_mod_params.enable_ini,
> +		   bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(enable_ini,
> +		 "Enable debug INI TLV FW debug infrastructure (default: 0");

The commit log doesn't mention anything about the module parameter and
how/when it's supposed to be used, that would be nice to have.

-- 
Kalle Valo
