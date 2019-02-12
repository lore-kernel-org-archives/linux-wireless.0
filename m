Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93C7C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 20:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B60E8222C1
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 20:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L8qCl0Yh";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QEgh6LJR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbfBLUCU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 15:02:20 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41092 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731104AbfBLUCU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 15:02:20 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E5AB760AD8; Tue, 12 Feb 2019 20:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550001738;
        bh=jKT03a08Z30mEnYMARbltaWxzfCWnE1YtlEckHE2t54=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=L8qCl0YhQ6OwA6PuMvcPRnh7DycwkAcOGSZK0A7dMLlhcsSvcwdGInsJC3kNaYxLr
         +rgHnAyT2RyBVtAkm+F780BavyHAVO4DdfgTMZdW/Kwu+vT/zGC5H2jrLJW8Te5oFw
         rmItTxVfyxUuNbT4NC5PMZT5MEWQ4FnNTXa8gmL0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21AEF608CC;
        Tue, 12 Feb 2019 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550001734;
        bh=jKT03a08Z30mEnYMARbltaWxzfCWnE1YtlEckHE2t54=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QEgh6LJRWJUoL+B2Z0xF4DHdTs4crW8XMBSjZWfEJlc3LNFmhIME9U0ea2eJYmCuJ
         8SDyXIqVIu0UoI9YQU9R1lrABHCAjS+90ashKjSQ2aozz0lQmqva+sDIOE69uesMPO
         BUCbxYZUwgx9e3qv83bP8/YSQ4TPR/eJ/wGf06/4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 21AEF608CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] ath10k: Add support for ack rssi value of
 management tx packets
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549975191-20912-2-git-send-email-aambure@codeaurora.org>
References: <1549975191-20912-2-git-send-email-aambure@codeaurora.org>
To:     Abhishek Ambure <aambure@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212200218.E5AB760AD8@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 20:02:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Abhishek Ambure <aambure@codeaurora.org> wrote:

> In WCN3990, WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI service Indicates that
> the firmware has the capability to send the RSSI value of the ACK for all
> data and management packets transmitted.
> 
> If WMI_RSRC_CFG_FLAG_TX_ACK_RSSI is set in host capability then firmware
> sends RSSI value in "management" tx completion event. Host extracts ack
> rssi values of management packets from their tx completion event.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01617-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
> V2: Tested HW & Tested FW added

Does not apply. Also the sha1 information was incorrect so 3-way merge
didn't work. Did you use ath.git master branch as the baseline for these
patches?

error: patch failed: drivers/net/wireless/ath/ath10k/wmi-tlv.c:1619
error: drivers/net/wireless/ath/ath10k/wmi-tlv.c: patch does not apply
error: patch failed: drivers/net/wireless/ath/ath10k/wmi-tlv.h:1578
error: drivers/net/wireless/ath/ath10k/wmi-tlv.h: patch does not apply
error: patch failed: drivers/net/wireless/ath/ath10k/wmi.c:2369
error: drivers/net/wireless/ath/ath10k/wmi.c: patch does not apply
stg import: Diff does not apply cleanly

2 patches set to Changes Requested.

10807833 [v2,1/2] ath10k: Add support for ack rssi value of management tx packets
10807837 [v2,2/2] ath10k: Add support for ack rssi value of data tx packets

-- 
https://patchwork.kernel.org/patch/10807833/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

