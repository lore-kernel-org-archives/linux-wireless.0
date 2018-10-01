Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD57C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C80B9208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gr4KqjnS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HMWfdgxr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C80B9208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbeJAUpy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:45:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbeJAUpx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:45:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1EDA860C1B; Mon,  1 Oct 2018 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402875;
        bh=EP5gwSNsK5riLXUtONmQD9l27DYjkOAg7bY9V6clfXk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gr4KqjnSP56HMbMGl3il/e54DZ0Rac9X/fwuO9oRiuFSOlXog88DFV42rqIHoR9hw
         +4ka7Vtk4JtEsm3d6gzVPyYUnvIRFCuRgdbTbJNh+xwhSlZegr1Kjt2mypG7qp37/0
         YVrUyTLvXLAeP+1xDJUWl8tKPBEl66UcdJbziuAI=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 73F9260128;
        Mon,  1 Oct 2018 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402874;
        bh=EP5gwSNsK5riLXUtONmQD9l27DYjkOAg7bY9V6clfXk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HMWfdgxr0xdcuTdbPwQ2q4kjq77piqsFtYYuaT727z+H+mX3BJhkNqPuYSIx+gr/T
         LiRXTAD9x/cQYiWmIG4vqx5sZId6wVO2zWVxL58cprqSAr3YAL7C8VMZJG91URUJ8s
         iRQI9KCDFMvqeaqcMDjx5vm3bhzv0m9PBSN6liXE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 73F9260128
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/5] ath9k: fix reporting calculated new FFT upper max
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180919103711.19304-6-sw@simonwunderlich.de>
References: <20180919103711.19304-6-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Nick Kossifidis <mickflemm@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001140755.1EDA860C1B@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:07:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Simon Wunderlich <sw@simonwunderlich.de> wrote:

> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

No empty commit logs, please. But I can add that, just tell me what to add.

-- 
https://patchwork.kernel.org/patch/10605615/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

