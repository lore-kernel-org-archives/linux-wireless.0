Return-Path: <SRS0=l1pt=YR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9202CA9EBC
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Oct 2019 05:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEDB120679
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Oct 2019 05:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JXfTjsRH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CiVk3fls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437581AbfJXFuX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Oct 2019 01:50:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404449AbfJXFuX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Oct 2019 01:50:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 35EDA60DCE; Thu, 24 Oct 2019 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896222;
        bh=sntYvzeJGBcKz/3sm81RPEnwd/LVuuEDNDh2otjkO2M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JXfTjsRHoobw+opiGrDK76Y75ExfFiDMzNY7ovZBJsUsgKq3zD94eRfBKa89a+wmw
         Sl8hikEA73nr1gTIL8RIRpLySBaVFP05hwjIp50b/FOCEpfoKtUxhCJ9hi6yExzuZF
         3y5d3X9FVXuAXwSoOIFjXkfW0shhpJXU2V0OMvic=
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 436BE60B6E;
        Thu, 24 Oct 2019 05:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896221;
        bh=sntYvzeJGBcKz/3sm81RPEnwd/LVuuEDNDh2otjkO2M=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CiVk3flsX0J1Rg3SbR2jPoKOZEn0jCC/sTxbon5oaIFQSnrLRat2l7JGFPCOirzkp
         6s7JmUT/IL0sx9gk4eKnsjTFCHNaKn/41KuwC+MQRdA6mwOk9gz5vIfqgu5PkWfFeM
         0nK6IhYK5iBwY+iYmF2sUorfm+fBETAbRylYtJtM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 436BE60B6E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: fix warnings for symbol not declared
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191023105407.92131-1-chiu@endlessm.com>
References: <20191023105407.92131-1-chiu@endlessm.com>
To:     Chris Chiu <chiu@endlessm.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191024055022.35EDA60DCE@smtp.codeaurora.org>
Date:   Thu, 24 Oct 2019 05:50:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Chris Chiu <chiu@endlessm.com> wrote:

> Fix the following sparse warnings.
> sparse: symbol 'rtl8723bu_set_coex_with_type' was not declared.
> Should it be static?
> sparse: symbol 'rtl8723bu_update_bt_link_info' was not declared.
> Should it be static?
> sparse: symbol 'rtl8723bu_handle_bt_inquiry' was not declared.
> Should it be static?
> sparse: symbol 'rtl8723bu_handle_bt_info' was not declared.
> Should it be static?
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>

Patch applied to wireless-drivers-next.git, thanks.

b298800dd8ee rtl8xxxu: fix warnings for symbol not declared

-- 
https://patchwork.kernel.org/patch/11206331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

