Return-Path: <SRS0=dvfj=ZF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE67C43331
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 13:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695DF222CD
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Nov 2019 13:21:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IyYClfHP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NE5RaZov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKMNVI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:21:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKMNVI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Nov 2019 08:21:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5A294602DE; Wed, 13 Nov 2019 13:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573651267;
        bh=UZZlIPG1F3ce1hp8xylekHHIqVwKGJS+ZVzp7vOy+SA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IyYClfHPTksca+R2cEaWEMhw/0JchDd6YHffegu1LfkrscbzGBt2k1FmuPA3exGNx
         vSZOtIu9hbtMU7z5WiTRziyhesILEZ0XWxeHDWOYvYQRNa31hDwwSQZyBiW1a6ecEZ
         2XXm/H5qywm2NtUKUZnvIhoEEqA6re4TYAHo38Z0=
Received: from x230.qca.qualcomm.com (85-76-109-196-nat.elisa-mobile.fi [85.76.109.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47C29602DE;
        Wed, 13 Nov 2019 13:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573651264;
        bh=UZZlIPG1F3ce1hp8xylekHHIqVwKGJS+ZVzp7vOy+SA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NE5RaZov4BHrxLS3BTlMlTBXeYg43yWdAnU6/ev+cCu+Lc61cuJp7mlQQI9Pvsqoy
         cCiOELL8a+gz2Pwnz/PNmkS03Q68EleZjU4zEm736vml2Snh13TadDoRP6scYFUVLN
         q4Urcx/aRLCtjV5/h7a5QPv5wE6jwmw+pwBZaFpw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47C29602DE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] iwlwifi: nvm: update iwl_uhb_nvm_channels
References: <20191019093902.29823-2-luca@coelho.fi>
        <20191113092938.13921-1-luca@coelho.fi>
Date:   Wed, 13 Nov 2019 15:20:56 +0200
In-Reply-To: <20191113092938.13921-1-luca@coelho.fi> (Luca Coelho's message of
        "Wed, 13 Nov 2019 11:29:38 +0200")
Message-ID: <87muczx687.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Tova Mussai <tova.mussai@intel.com>
>
> Change the UHB channels to start from 1 to match the specs (11ax Draft 5.0).
>
> Signed-off-by: Tova Mussai <tova.mussai@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

Thanks, this is better.

-- 
Kalle Valo
