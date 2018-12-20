Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EC2C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE75620815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EVZxc2Xh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NJD3rYJj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbeLTRB4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:01:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbeLTRBz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:01:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1F321606CF; Thu, 20 Dec 2018 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325315;
        bh=Wkwgop6T7zUmz8iX+jIm6Rh3PJbRKeK+lx5DTz8AafU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EVZxc2XhgxQDjCfISwZ3GlKO34PLhsjdo1udDMcq7cew+i1d51RfR53sdE2nomcxE
         5Q5Ddh4cajMRcuiMvnfCQ9bDg1AN8VuYUIK77gL/VNrfm72IIAFsZHYKym+8YVvMba
         +Nnc4feGpSI2UOWP5eN2SHKnTUiwaMr4eMHOt5bc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CD16A602CB;
        Thu, 20 Dec 2018 17:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325314;
        bh=Wkwgop6T7zUmz8iX+jIm6Rh3PJbRKeK+lx5DTz8AafU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NJD3rYJjnlSfZsO1qYh9PpPQZ2VmJ/8tgUgKwcbToEBNQXR5a8scCQBagE2PJNWUS
         H300DHBRCxqRzLW6qzbSgPXyrFQNBPhDINpdZxROLgV02ONg1D+Prqr15ebN52UkSl
         PHp2jYueE656V5faJcdGJk65yaLEnBL3BBo9jUXg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CD16A602CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Disable 4addr source port learning in 10.4 FW
 by default
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181112064008.3610-1-murugana@codeaurora.org>
References: <20181112064008.3610-1-murugana@codeaurora.org>
To:     Sathishkumar Muruganandam <murugana@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170155.1F321606CF@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:01:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sathishkumar Muruganandam <murugana@codeaurora.org> wrote:

> Currently in 10.4 FW, all the received 4addr frames are processed for
> source port learning which is enabled by default. This learning can't be
> disabled by default in FW since it breaks backward compatibility.
> 
> Since ath10k uses mac80211 based 4addr mode, source port learning done in
> 10.4 FW is redundant and also causes issues when 3addr frames are
> transmitted/received for a 4addr station.
> 
> One such visible functional impact is when GTK rekey frame from
> hostapd based AP to 4addr STA is dropped in AP's 10.4 FW. This is since
> GTK rekey EAPOL frame is 3addr frame on AP interface and STA enabled
> with 4addr is already allowed for receiving 3addr EAPOL frames.
> 
> Source port learning implementation in 10.4 FW drops this 3addr GTK rekey
> frame in AP destinated for 4addr STA causing disassociation and
> re-association for every GTK rekey session. GTK rekey issue is not seen
> when learning is disabled in FW.
> 
> To prevent such issues without breaking backward compatibility, FW
> advertises new service bit making the source port learning configurable and
> this learning is being currently disabled during ath10k vdev creation.
> 
> * Tested HW: QCA9984
> * Tested FW: 10.4-3.6.0.1-00004
> 
> Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

68c295f21abc ath10k: disable 4addr source port learning in 10.4 FW by default

-- 
https://patchwork.kernel.org/patch/10678191/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

