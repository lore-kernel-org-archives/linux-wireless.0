Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E6AC00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC7DB20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fOeoExF/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NckRf9/H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC7DB20875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbeJEP1t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:27:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35006 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbeJEP1s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:27:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8ED9460227; Fri,  5 Oct 2018 08:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728209;
        bh=FF/V6NXH8mEkrPTQUsOGhxlyq8mnODQdbmmva9P+an4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fOeoExF/+yFSR/qHZTZR8L5XOl/45A4DVh2q18gWQhpyZwhxtOdAnvCtVfVagO+Sy
         haLrSopfKkEp2fiG2kGbVcLohALVK17w4hLVcWcRd9qKohl2FpwYp4QJP/2enNxNTo
         Y7/oJ+0eHo+VnuhyCp6oDiuGFSkF0qXcwMHW40wE=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA3AF601A0;
        Fri,  5 Oct 2018 08:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538728205;
        bh=FF/V6NXH8mEkrPTQUsOGhxlyq8mnODQdbmmva9P+an4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NckRf9/HG6uX8OVChWIYclyDh1B6X/zPJU3i9TiUKINDco1XDIP4b4mTw7Xl1VYzW
         ynSEt33qcJv+t1Nhbt2IKJYtc5NikY5sr+cgDS0nq/8658VxZ5PFKqXuo9iv/UBYLn
         UmQNQH/q97QC2HZIZQZ52kzTfn/x41EwT009tXZs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA3AF601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] brcmfmac: reduce timeout for action frame scan
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1538060351-12827-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1538060351-12827-2-git-send-email-chi-hsien.lin@cypress.com>
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>,
        Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181005083009.8ED9460227@smtp.codeaurora.org>
Date:   Fri,  5 Oct 2018 08:30:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com> wrote:

> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> Finding a common channel to send an action frame out is required for
> some action types. Since a loop with several scan retry is used to find
> the channel, a short wait time could be considered for each attempt.
> This patch reduces the wait time from 1500 to 450 msec for each action
> frame scan.
> 
> This patch fixes the WFA p2p certification 5.1.20 failure caused by the
> long action frame send time.
> 
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

2 patches applied to wireless-drivers-next.git, thanks.

edb6d6885bef brcmfmac: reduce timeout for action frame scan
fbf07000960d brcmfmac: fix full timeout waiting for action frame on-channel tx

-- 
https://patchwork.kernel.org/patch/10618131/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

