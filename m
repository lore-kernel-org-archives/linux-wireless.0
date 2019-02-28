Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A4CC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F0C21850
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iaL2YK3X";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K1mN1KDp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732045AbfB1JF1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:05:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731463AbfB1JF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 04:05:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2335B60A0A; Thu, 28 Feb 2019 09:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551344726;
        bh=sKqjLPDqxlDIOoBaQ1jBtCTNYZ+dWFJe8lwfrGSfgM0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iaL2YK3X7GVrDiTAPRSrhu8mj18dGBV6g924quT4NC6KubZhooFHQ4l0zIdjkn4/w
         ao2itiyNDqb9KOa8QIcZPa2mWytrbYCrjMPIFKPTRjQqK79F9RwBWqduJwySF9brMC
         QEu4jQEEoU/INKU9rfMVOCQhZccpA2O9HEbrTxp0=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B92916055A;
        Thu, 28 Feb 2019 09:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551344725;
        bh=sKqjLPDqxlDIOoBaQ1jBtCTNYZ+dWFJe8lwfrGSfgM0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=K1mN1KDptUamcVtaF+Vs+qQtzW4sizI2ZuPnOAVgTANLLTb8h2i5Hzu5312QcmBbu
         NqM4Jeb0l75dTc7wUVqNG/GVsDawA9VKWkeWoxZ/HHLU3CyEJrzk5ap6nWWz0QU03i
         90TPhowGyLc66EcNZpGaK3RnTaZM97fPNFoQSPSE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B92916055A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 00/21] wil6210 patches
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Date:   Thu, 28 Feb 2019 11:05:21 +0200
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org> (Maya
        Erez's message of "Fri, 22 Feb 2019 16:20:58 +0200")
Message-ID: <8736o81dwu.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> writes:

> The following set of patches include:
> - support up to 20 stations in AP mode
> - add support for ucode tracing
> - various wil6210 fixes

21 patches is just too much to review. I'll review (and apply) these in
smaller sets. Ideally these should have been split into 3 smaller sets
and only one set at a time in review queue, that they would be applied a
lot faster.

-- 
Kalle Valo
