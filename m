Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974F6C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66B172084D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cdfdUVW9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vd36I42B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfDLMyK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:54:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42706 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfDLMyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:54:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 292FB61344; Fri, 12 Apr 2019 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555073649;
        bh=mdWkiXx+14e+0pLx0ImYb4ENtK0Lji6cAw06cKzmhNE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cdfdUVW9H419jECzZ39VxCZI2S4b6Gc+65xJ7vtUmmzbdvCMum+d8dwmx54FraEYW
         J64EYfPufjX/EWsjlzbE3m9nmW+vpjnLM4rmEAYyzXl/sHcLC1QCDFj6NMRUbeHPFE
         B/Prx0RY+1MFmz0HYZ5XGU8Z3MesE60Z4BiT0IVU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0046E615BE;
        Fri, 12 Apr 2019 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555073647;
        bh=mdWkiXx+14e+0pLx0ImYb4ENtK0Lji6cAw06cKzmhNE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Vd36I42BHM57/zwlKEa2eKdzcW2UpgN117qBY9CLSnuY5NmIwqXzunCNUlYLDqw9D
         jgvvg74MfhYfsQ4oABqxO0+ji9MTGAGGY5t24l0AKGLMmsMHprzKoP+UIzIAw/5gqn
         WkxkADQcw4Jk/bx4wNoUqbHEMBWOiMeuysrNv/9g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0046E615BE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Alagu Sankar <alagusankar@silex-india.com>
Subject: Re: [PATCH 1/6] ath10k: use clean packet headers
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
        <20190409190851.4557-2-erik.stromdahl@gmail.com>
Date:   Fri, 12 Apr 2019 15:54:03 +0300
In-Reply-To: <20190409190851.4557-2-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Tue, 9 Apr 2019 21:08:46 +0200")
Message-ID: <878swfe650.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> From: Alagu Sankar <alagusankar@silex-india.com>
>
> HTC header carries junk values that may be interpreted by the firmware
> differently. Enable credit update only if flow control is enabled for
> the corresponding endpoint.
>
> PLL clock setting sequence does not mask the PLL_CONTROL
> register value. Side effect of not masking the values is not known as
> the entire pll clock setting sequence is undocumented.

One logical change per patch, please. So this should be split to two.

> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>

Erik's s-o-b missing. 

> --- a/drivers/net/wireless/ath/ath10k/hw.c
> +++ b/drivers/net/wireless/ath/ath10k/hw.c
> @@ -814,6 +814,8 @@ static int ath10k_hw_qca6174_enable_pll_clock(struct ath10k *ar)
>  	if (ret)
>  		return -EINVAL;
>  
> +	reg_val &= ~(WLAN_PLL_CONTROL_REFDIV_MASK | WLAN_PLL_CONTROL_DIV_MASK |
> +		     WLAN_PLL_CONTROL_NOPWD_MASK);
>  	reg_val |= (SM(hw_clk->refdiv, WLAN_PLL_CONTROL_REFDIV) |
>  		    SM(hw_clk->div, WLAN_PLL_CONTROL_DIV) |
>  		    SM(1, WLAN_PLL_CONTROL_NOPWD));

The commit log mentions that there are no visible changes after this
patch. So why add it? :)

And do note that this also changes functionality for QCA6174 and QCA9377
PCI devices, so we have to be careful here.

-- 
Kalle Valo
