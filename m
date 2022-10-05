Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B81BC433F5
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Oct 2022 07:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiJEHfd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Oct 2022 03:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJEHfW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2022 03:35:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44A5601C
        for <linux-wireless@vger.kernel.org>; Wed,  5 Oct 2022 00:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28381B81C3D
        for <linux-wireless@vger.kernel.org>; Wed,  5 Oct 2022 07:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDA5C433C1;
        Wed,  5 Oct 2022 07:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664955317;
        bh=p4woCVGWHzecdrGTgc/9LRqQ+NRGJ6R43ovHpW9QVS8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=A5my8fhzN3QCerS0npVoPKn1UhMhJ2Uf6JxWi3SV1B5mrpGquKDciz5H2w8lfihM2
         RtUlRz/KISVO/5uAjHfAVOMEt7p3RWXAy8Ex+jMVYY4ksfqZv0bBTg6UJPT2BKnWDt
         wlxXKb05X21kKZ8kRzOughFlh9LS05CMnRg8FBW1YcfRCILg4CEe0qVURDbwVO+1pX
         i0O8qACV1EqO6jxrwNoZY+VjtkY1G4WRWH2Fo8ztgasmoEm1vKk+779uo9665k1NxA
         PTymHuow1CfFzsXjlAaE8cTRDP94wkh4Q7SksC9vxIAuzxp76+C4KLWcGRN5hYx+Qv
         TztmxXTCy5Prw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/4] brcmfmac: revise SoftAP channel setting
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220929050614.31518-5-ian.lin@infineon.com>
References: <20220929050614.31518-5-ian.lin@infineon.com>
To:     Ian Lin <ian.lin@infineon.com>
Cc:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <Double.Lo@infineon.com>,
        <ian.lin@infineon.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166495531224.5945.8900458651808305145.kvalo@kernel.org>
Date:   Wed,  5 Oct 2022 07:35:15 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ian Lin <ian.lin@infineon.com> wrote:

> From: Ting-Ying Li <tingying.li@cypress.com>
> 
> We need to update "chanspec" iovar for each SoftAP creation
> because firmware will update the chanspec to current bsscfg
> for each bss. If we do not update it then the wrong chanspec
> will be shown on the result of 'wl -i [interface] status'
> command. No need to handle channel resource reusing for mbss
> mode by the host driver, it should be covered by firmware.
> 
> Signed-off-by: Ting-Ying Li <tingying.li@cypress.com>
> Signed-off-by: Ian Lin <ian.lin@infineon.com>

The term "SoftAP" is a bit confusing. From an upstream driver point of view
it's just AP mode, right?

What's wl? Is that some proprietary tool or what?

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220929050614.31518-5-ian.lin@infineon.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

