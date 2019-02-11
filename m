Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A250EC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F7B6218F0
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LRp/FMDN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F2Fu4ZEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfBKQ1I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:27:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39184 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfBKQ1I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 11:27:08 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D11696090F; Mon, 11 Feb 2019 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902427;
        bh=oVvXh7tIByhC+snP3f5a/BDfTZBot/uyODa+Tg148OA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LRp/FMDNvcbV1+3NtAorZVUVdRKKDwq81BRahPaFJ3nfdW0xvMRgnOJEDZYmTOttl
         6Qx5shWkgpmtF2gpynSme4XuRFhuOEG5thlVsZP6uFgWZahynzVJ6dr5r0rg+u7L/f
         3jD7uR43AcRiC2Il7jTuncO0j3PX7QTJYUaoT1Yc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 223496090F;
        Mon, 11 Feb 2019 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549902425;
        bh=oVvXh7tIByhC+snP3f5a/BDfTZBot/uyODa+Tg148OA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=F2Fu4ZEjDSYDQHDmDtWbN1QjRPH9BWGvEDKAvXpe2XfswMp+RZWfnHcIJvjcI4ynr
         e8V345429hVfyPVqRNLwV0W3+0dEd6nQjwn6By1b9vXau1CWyBWyzq5AtGOT744SdH
         xWPYeF2YrcgmhwjX8GfUoc2H8GrqYGFYntnespwI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 223496090F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] ath10k: Assign 'n_cipher_suites = 11' for WCN3990 to
 enable WPA3
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548339697-17766-2-git-send-email-aambure@codeaurora.org>
References: <1548339697-17766-2-git-send-email-aambure@codeaurora.org>
To:     Abhishek Ambure <aambure@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211162706.D11696090F@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 16:27:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Abhishek Ambure <aambure@codeaurora.org> wrote:

> Hostapd uses CCMP, GCMP & GCMP-256 as 'wpa_pairwise' option to run WPA3.
> In WCN3990 firmware cipher suite numbers 9 to 11 are for CCMP,
> GCMP & GCMP-256.
> 
> To enable CCMP, GCMP & GCMP-256 cipher suites in WCN3990 firmware,
> host sets 'n_cipher_suites = 11' while initializing hardware parameters.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

7ba31e6e0cdc ath10k: assign 'n_cipher_suites = 11' for WCN3990 to enable WPA3
7d94f862d648 ath10k: update GCMP & GCMP-256 cipher suite number for WCN3990

-- 
https://patchwork.kernel.org/patch/10779097/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

