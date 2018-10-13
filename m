Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0498C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C1B02077C
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:25:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FgHXwXoT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h1ZWv2Vw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C1B02077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbeJNBDD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 21:03:03 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbeJNBDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 21:03:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E440960116; Sat, 13 Oct 2018 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451503;
        bh=VNyj22sIbGtpvLpYggJjvyKcvSb6V794VUcOXZveriU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FgHXwXoTFgqi+QtX6UnuLlU9H7lM1uRePsG8SJifCcaErGrARMR8pQT1Po0ypTtlW
         f2IjhdasTOVf6lpmudkKJDD4jlLeEdkA9tkr6vinU/OtZOVUwxnhP9Xv8OK6xo5WQN
         u8jRYrzF9ybuTqEDN+S7Pc9sO39q5N/SU/jxHOfI=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA0D860A98;
        Sat, 13 Oct 2018 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539451503;
        bh=VNyj22sIbGtpvLpYggJjvyKcvSb6V794VUcOXZveriU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=h1ZWv2Vwxjm5vEDK1s5MUf/d6mDtKalYNI01T2SFyUg8+6rs4hMUsPRRynrEAd3/c
         4AZhYaoc5oCyhTrUk/wxEN5JX74acFmvZ9iovzKuAjpIAeKxS2E1TnIalSPK4zkDgR
         YWxbN8rb526eeQHsMTCeCWFmb4YeRcCmnvTtYgKk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA0D860A98
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add peer flush in ath10k_flush for STATION
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1538989363-12386-1-git-send-email-wgong@codeaurora.org>
References: <1538989363-12386-1-git-send-email-wgong@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013172503.E440960116@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:25:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> wrote:

> In the noisy environment, if there are packets in the queue and can't
> send out, the suspend timing will be more than 5 seconds due to the wait,
> flush the queue to optimize the suspend timing, and let the upper layer to
> retry the packets after resume.
> 
> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
> It's not a regression with new firmware releases.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

9de4162f0999 ath10k: add peer flush in ath10k_flush for STATION

-- 
https://patchwork.kernel.org/patch/10630271/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

