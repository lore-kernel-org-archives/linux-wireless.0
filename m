Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA8BC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 18:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFE4020821
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 18:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="laqf/MYO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="laqf/MYO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfBFSME (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 13:12:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35768 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbfBFSME (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 13:12:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C850B6074F; Wed,  6 Feb 2019 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549476723;
        bh=Nn9KkcpiAc0PfbSHcFNKg2HCbnImpzz3ThOxTb3d94M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=laqf/MYOWiAe+FeyCgLHgwp1orsPAIVqo1yfn2fE0f4Um2Oq76CNPuaWZFdsw05hL
         vPNqnyKeh76Ej+d9bZ7AAdEHew/iBwys+H6datbLbFmzuXYj3GjN34XOHA9OmFvUsZ
         FxwG8WoJDLkFqRnb7+aVYnZY3pZC/dx+mHXNOAWE=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 982E46032C;
        Wed,  6 Feb 2019 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549476723;
        bh=Nn9KkcpiAc0PfbSHcFNKg2HCbnImpzz3ThOxTb3d94M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=laqf/MYOWiAe+FeyCgLHgwp1orsPAIVqo1yfn2fE0f4Um2Oq76CNPuaWZFdsw05hL
         vPNqnyKeh76Ej+d9bZ7AAdEHew/iBwys+H6datbLbFmzuXYj3GjN34XOHA9OmFvUsZ
         FxwG8WoJDLkFqRnb7+aVYnZY3pZC/dx+mHXNOAWE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 982E46032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 07/21] iwlwifi: mvm: add HE TB PPDU SIG-A BW to radiotap
References: <20190131202206.15903-1-luca@coelho.fi>
        <20190131202206.15903-8-luca@coelho.fi>
Date:   Wed, 06 Feb 2019 20:11:59 +0200
In-Reply-To: <20190131202206.15903-8-luca@coelho.fi> (Luca Coelho's message of
        "Thu, 31 Jan 2019 22:21:52 +0200")
Message-ID: <875ztwss5s.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Expose the trigger-based PPDU SIG-A bandwidth to radiotap in
> the newly defined bits thereof.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> --- a/include/net/ieee80211_radiotap.h
> +++ b/include/net/ieee80211_radiotap.h
> @@ -291,6 +291,12 @@ enum ieee80211_radiotap_he_bits {
>  
>  	IEEE80211_RADIOTAP_HE_DATA6_NSTS		= 0x000f,
>  	IEEE80211_RADIOTAP_HE_DATA6_DOPPLER		= 0x0010,
> +	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_KNOWN	= 0x0020,
> +	IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW		= 0x00c0,
> +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_20MHZ	= 0,
> +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_40MHZ	= 1,
> +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_80MHZ	= 2,
> +		IEEE80211_RADIOTAP_HE_DATA6_TB_PPDU_BW_160MHZ	= 3,
>  	IEEE80211_RADIOTAP_HE_DATA6_TXOP		= 0x7f00,
>  	IEEE80211_RADIOTAP_HE_DATA6_MIDAMBLE_PDCTY	= 0x8000,
>  };

Johannes, as you wrote the patch I take it that you are ok to push this
via wireless-drivers-next?

-- 
Kalle Valo
