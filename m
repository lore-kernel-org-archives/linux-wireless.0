Return-Path: <SRS0=lMj3=ZV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7BBC432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 07:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D586721736
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 07:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bWt2chu9";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="FwbdqY6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfK2Hnn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Nov 2019 02:43:43 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:38814
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbfK2Hnn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Nov 2019 02:43:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575013422;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date;
        bh=Gl2HS0wMAc+GGWoRiF/CrG8/d3aqFmKjJTUTFg3bnxI=;
        b=bWt2chu9AYQIqm3fNQnyv6DCmBeferJrL/pLe/45NEWBCYJArZulgDw9w1SM3A1D
        xdCHj0gFj/1Yn5lD7VYigtnfv2GEbrkRHjyiMHbG6rbFS9Id2rBVd6DLkxaQa8y4evJ
        8DwlfZ33a2l5uhKyyl3Y7AeQLn6zC4Ca2NR6pBDg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575013422;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:From:In-Reply-To:References:To:Cc:Message-Id:Date:Feedback-ID;
        bh=Gl2HS0wMAc+GGWoRiF/CrG8/d3aqFmKjJTUTFg3bnxI=;
        b=FwbdqY6yTbHJ404vUYvFl9AinNCIOOh2LdCvL6TAHZ/6YiOBvjLZUAvrA9I/iDfO
        akEbMhL6xUXIzxMH556NtuwJqJJrd9+ghI+XwlVmzNkA71HIHmrC4i8Bz+SZ69JhmSo
        KuNNly1PZ0VGcOpPzzfJz4mhrul8aVZ1/I4a86uY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 144D4C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: set WMI_PEER_AUTHORIZE after a firmware crash
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <0101016eaadee57a-54500c6d-4751-423f-8bab-5acd8fad2175-000000@us-west-2.amazonses.com>
References: <0101016eaadee57a-54500c6d-4751-423f-8bab-5acd8fad2175-000000@us-west-2.amazonses.com>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-ID: <0101016eb61d9520-b0306a23-c9b9-4b57-b708-9f80ac47eef1-000000@us-west-2.amazonses.com>
Date:   Fri, 29 Nov 2019 07:43:42 +0000
X-SES-Outgoing: 2019.11.29-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> After the firmware crashes ath10k recovers via ieee80211_reconfig(),
> which eventually leads to firmware configuration and including the
> encryption keys. However, because there is no new auth/assoc and
> 4-way-handshake, and firmware set the authorize flag after
> 4-way-handshake, so the authorize flag in firmware is not set in
> firmware without 4-way-handshake. This will lead to a failure of data
> transmission after recovery done when using encrypted connections like
> WPA-PSK. Set authorize flag after installing keys to firmware will fix
> the issue.
> 
> This was noticed by testing firmware crashing using simulate_fw_crash
> debugfs file.
> 
> Tested with QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

382e51c139ef ath10k: set WMI_PEER_AUTHORIZE after a firmware crash

-- 
https://patchwork.kernel.org/patch/11263357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

