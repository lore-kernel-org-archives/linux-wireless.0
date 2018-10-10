Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46A7C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 03:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 764912087D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 03:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z2NQqgSY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z2NQqgSY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 764912087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbeJJKtU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 06:49:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53068 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbeJJKtU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 06:49:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B2B5560C62; Wed, 10 Oct 2018 03:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539142155;
        bh=TsskvNQx1Pw8DNJQazB1xXrScq3e5R5AU+sRHPwoIGk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Z2NQqgSYmHUWpKbWOecJGkJDhlnu/bDLPI9W5DKwwxaH4+ETTAi/GWFnYRmS3f2HD
         GKJOZ/+dTQzROlm5eqJZEjZ3lnE8w3kON9PbcSLSbzKW60u6OdjV/RKyup1OLXE/DJ
         xqGMnB8Qn43ernwRlEYc4grTMmZmj3Bfe8GUi+UA=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0547C60209;
        Wed, 10 Oct 2018 03:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539142155;
        bh=TsskvNQx1Pw8DNJQazB1xXrScq3e5R5AU+sRHPwoIGk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Z2NQqgSYmHUWpKbWOecJGkJDhlnu/bDLPI9W5DKwwxaH4+ETTAi/GWFnYRmS3f2HD
         GKJOZ/+dTQzROlm5eqJZEjZ3lnE8w3kON9PbcSLSbzKW60u6OdjV/RKyup1OLXE/DJ
         xqGMnB8Qn43ernwRlEYc4grTMmZmj3Bfe8GUi+UA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0547C60209
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     James Prestwood <james.prestwood@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: allow setting custom features/iftypes
References: <20181009174829.15163-1-james.prestwood@linux.intel.com>
Date:   Wed, 10 Oct 2018 06:29:12 +0300
In-Reply-To: <20181009174829.15163-1-james.prestwood@linux.intel.com> (James
        Prestwood's message of "Tue, 9 Oct 2018 10:48:29 -0700")
Message-ID: <87a7nmqy2f.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

James Prestwood <james.prestwood@linux.intel.com> writes:

> The current driver hard codes various features, ext features and supported
> interface types when a new radio is created. This patch adds several new
> hwsim attributes so user space can specify specific features the radio should
> have:
>
> - HWSIM_ATTR_FEATURE_SUPPORT
> 	Bit field of nl80211_feature_flags flags
> - HWSIM_ATTR_EXT_FEATURE_SUPPORT
> 	Variable length bit field where bits map to nl80211_ext_feature_index
> 	values.
> - HWSIM_ATTR_IFTYPE_SUPPORT
> 	Nested attribute of flags containing all supported interface types.
> 	Each flag attribute sets support for an interface type.
>
> Each attribute data format matches a corresponding NL80211 attribute:
>
> HWSIM_ATTR_FEATURE_SUPPORT --> NL80211_ATTR_FEATURE_FLAGS
> HWSIM_ATTR_EXT_FEATURE_SUPPORT --> NL80211_ATTR_EXT_FEATURES
> HWSIM_ATTR_IFTYPE_SUPPORT --> NL80211_ATTR_SUPPORTED_IFTYPES

Signed-off-by is missing.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing

-- 
Kalle Valo
