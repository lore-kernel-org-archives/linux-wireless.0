Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F289C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 10:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C9A20825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 10:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Y5sn4EgP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KL4mAdIc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45C9A20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbeKETZu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 14:25:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbeKETZt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 14:25:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 853B5607F7; Mon,  5 Nov 2018 10:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541412413;
        bh=y1p4N2u2PQVTeBCtUq+9BPj6iYMx+daYHsLYtB3VUag=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Y5sn4EgPZ23KG34lAxTjKiXYSQLagdUUr4gw2xHPMP2slsh0CDJikuhyuhRZba6ub
         Am3GYsOYVPQluik+1aWfD5YM1ShwnQnPytq5qUvuL303qhRbf53XYxW+//o3bFUmZM
         QYZC+tz+A6PKTwGNWGU91z1GU0GjP0BfbwKN6+tk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B5A2C6053B;
        Mon,  5 Nov 2018 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541412412;
        bh=y1p4N2u2PQVTeBCtUq+9BPj6iYMx+daYHsLYtB3VUag=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=KL4mAdIcgD/Z+JCE7hufWpPLC6/sfOYj3FJv3QhaGEMCOBqxQ4oSQ8mOjDNvpl94a
         KD0kS6IovDue+h9AllCgW0733yzKlp2yZGjL0UhGn22BnqPh5bLh9p2Y0PDxTP8Yyz
         UY+ehxqozsrEZlNZDw+31iyNr+mJh+AvNlRjaAb0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B5A2C6053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: Add support for WCN3990 firmware crash recovery
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1539323619-31358-1-git-send-email-pillair@codeaurora.org>
References: <1539323619-31358-1-git-send-email-pillair@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181105100653.853B5607F7@smtp.codeaurora.org>
Date:   Mon,  5 Nov 2018 10:06:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> wrote:

> Whenever the WCN3990 firmware becomes unavailable,
> the host driver receives a FW down indication, post
> which all the direct hardware register access should
> be avoided, in order to prevent improper behavior in
> the host driver.
> 
> Set the crash_flush flag when the host driver receives
> a FW_DOWN_IND via qmi, in order to stop the untimely
> hardware register access. Also handle the case, where
> we need to do core register only for the first FW_READY
> indication, which is when we initialize the host driver.
> All the subsequent FW_READY indication will be received
> in subsystem recovery case and we only need to do the
> restart work. The state of driver is maintained using
> flags to distinguish between first and subsequent FW_READY
> indication received.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0e622f67e041 ath10k: add support for WCN3990 firmware crash recovery

-- 
https://patchwork.kernel.org/patch/10637883/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

