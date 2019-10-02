Return-Path: <SRS0=/cM4=X3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B317C10F14
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 17:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E21DD21848
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 17:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l/zZEd+B";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QJbT69z8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbfJBRR7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Oct 2019 13:17:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59012 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfJBRR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Oct 2019 13:17:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 441DF60A37; Wed,  2 Oct 2019 17:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570036678;
        bh=wWnOggerler6dJ9pkdG54S8RTXnBrTKOSC+ryeyS81A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=l/zZEd+BDAkk14UBfITwUVeodzPqnVjCEpzmt3HsOoOKdzu4v0TZYa5QU9wLLwTbf
         xJw1aYPwAZwOPwR2OUEjPJJN1pIZ62pMGkf93ie+3gDVfq9q9AyvXgsyyK7Fd45/DQ
         1Oi3OBimjM4QD8NA9ceg4H5FlImQmzUvHjiphHBw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 644C860790;
        Wed,  2 Oct 2019 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570036677;
        bh=wWnOggerler6dJ9pkdG54S8RTXnBrTKOSC+ryeyS81A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QJbT69z8rrlt2f7T8EDGK271yboIJayzLAbdot5ZmyyNDT/R+my8NHsSNYL0yBsxv
         kBGMhxd1eUs88eEJ0IP12/AEoKJ7H+m3t7yArcAyOnReZZgzmbuLQFDPFhdBE7tj/f
         XQBmWTAgibPF2Nk3M3BPHdHNL0bFISl7o/f0nViw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 644C860790
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix offchannel tx failure when
 noath10k_mac_tx_frm_has_freq
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1508284992-3574-1-git-send-email-greearb@candelatech.com>
References: <1508284992-3574-1-git-send-email-greearb@candelatech.com>
To:     greearb@candelatech.com
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002171758.441DF60A37@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 17:17:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

greearb@candelatech.com wrote:

> Offchannel management frames were failing:
> 
> [18099.253732] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
> [18102.293686] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
> [18105.333653] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
> [18108.373712] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3780
> [18111.413687] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e36c0
> [18114.453726] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3f00
> [18117.493773] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e36c0
> [18120.533631] ath10k_pci 0000:01:00.0: timed out waiting for offchannel skb cf0e3f00
> 
> This bug appears to have been added between 4.0 (which works for us),
> and 4.4, which does not work.
> 
> I think this is because the tx-offchannel logic gets in a loop when
> ath10k_mac_tx_frm_has_freq(ar) is false, so pkt is never actually
> sent to the firmware for transmit.
> 
> This patch fixes the problem on 4.9 for me, and now HS20 clients
> can work again with my firmware.
> 
> Antonio: tested with 10.4-3.5.3-00057 on QCA4019 and QCA9888
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Tested-by: Antonio Quartulli <antonio.quartulli@kaiwoo.ai>
> [kvalo@codeaurora.org: improve commit log, remove unneeded parenthesis]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

cc6df017e557 ath10k: fix offchannel tx failure when no ath10k_mac_tx_frm_has_freq

-- 
https://patchwork.kernel.org/patch/10013117/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

