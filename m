Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FBBC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7047720834
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 10:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QKGjnHDB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QKGjnHDB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7047720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbeK2VGW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 16:06:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbeK2VGW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 16:06:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 752A360B1E; Thu, 29 Nov 2018 10:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543485694;
        bh=4FKm0EmoAXrBQ13LexaviIbhGiCHqRiGEH47pOk3H0g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QKGjnHDBnUr0ztD/nF21fYbwz/PnWy45VWGIgXyOSBXBeQ1QMDmwsIno45m6jGo77
         WM3lvtk9EtEunxcHjIeL2cKqxRPAlYPZJPC8unTD8nUzPUMDGINkVsDfXESJNdVaU2
         jpI8WyzDJ7mUwCm7cB3akLNgDdkYAttjeZzy9cJQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 03EE9601D1;
        Thu, 29 Nov 2018 10:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543485694;
        bh=4FKm0EmoAXrBQ13LexaviIbhGiCHqRiGEH47pOk3H0g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QKGjnHDBnUr0ztD/nF21fYbwz/PnWy45VWGIgXyOSBXBeQ1QMDmwsIno45m6jGo77
         WM3lvtk9EtEunxcHjIeL2cKqxRPAlYPZJPC8unTD8nUzPUMDGINkVsDfXESJNdVaU2
         jpI8WyzDJ7mUwCm7cB3akLNgDdkYAttjeZzy9cJQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 03EE9601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 05/15] iwlwifi: don't define OTP_LOW_IMAGE_SIZE per family, but per size
References: <20181123112631.29360-1-luca@coelho.fi>
        <20181123112631.29360-6-luca@coelho.fi>
Date:   Thu, 29 Nov 2018 12:01:30 +0200
In-Reply-To: <20181123112631.29360-6-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 23 Nov 2018 13:26:21 +0200")
Message-ID: <874lc06w3p.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> Using OTP_LOW_IMAGE_SIZE_FAMILY_8000/9000/22000 only obfuscates the
> actual values, since these 3 are the same.  Redefine the values per
> size so it's easier to understand and compare the different
> configurations.
>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> --- a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
> +++ b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
> @@ -48,7 +48,7 @@
>  static const struct iwl_base_params iwl1000_base_params = {
>  	.num_of_queues = IWLAGN_NUM_QUEUES,
>  	.max_tfd_queue_size = 256,
> -	.eeprom_size = OTP_LOW_IMAGE_SIZE,
> +	/* .eeprom_size = OTP_LOW_IMAGE_SIZE_2K, */

Why this is commented out?

-- 
Kalle Valo
