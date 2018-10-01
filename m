Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F18BC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1825F208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aLael4Xa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N+hm/UxH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1825F208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbeJAUkh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:40:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbeJAUkh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:40:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ABA9060866; Mon,  1 Oct 2018 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402559;
        bh=L+EzL15x9EE3jcu9wgQUgn+nLY4MsOQmI6sEmlH1QBI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aLael4XajDnC/bM1jjo1jjBvayj0+IfdexrM2F4ZUXq9xiN9NxYjy3qp0N4ILr0pY
         jfHkC09U3yxrnBJOIAKPoY6SV9eW3VAjoYlekZWor4vaFHQ0ONkKbaj0XZWAinK/ug
         GgKnlglSzCvsm9j2JV4NTetkrZtWefqlv9UhHZG0=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3AF676079B;
        Mon,  1 Oct 2018 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402559;
        bh=L+EzL15x9EE3jcu9wgQUgn+nLY4MsOQmI6sEmlH1QBI=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=N+hm/UxHlBrzxT9rs4uNVVrlxM7mJMxO5SuX3jlsnZVecDksxntenEUx9LH/a1ULF
         5GJY27MTltjpzmB9hu5y9fsK1RvNXo35L9K8UNYK8cenasVr8ujwV8snJY+O1IMIMQ
         2tEG+Nh47bLIv0xTNu7MhFuUKFi38cI4N+Gc82Uk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3AF676079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add debugfs support to get power save state
 change of STA
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1537252467-17353-1-git-send-email-mkenna@codeaurora.org>
References: <1537252467-17353-1-git-send-email-mkenna@codeaurora.org>
To:     Maharaja Kennadyrajan <mkenna@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001140239.ABA9060866@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:02:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maharaja Kennadyrajan <mkenna@codeaurora.org> wrote:

> This patch helps to get the power save state change of each peer
> connected to the AP. With WMI_10_4_PEER_STA_PS_STATECHG_EVENTID
> event, ps state of each peer is reported to user space via
> debugfs.
> 
> Use the below command to get the ps state of each sta:
> cat /sys/kernel/debug/ieee80211/phyX/netdev::wlanX/stations/
> XX:XX:XX:XX:XX:XX/peer_ps_state
> 
> If STA is in power save state, we get the peer_ps_state value as 1.
> if STA is not in power save state, we get the peer_ps_state value as 0.
> If ps_state event is disabled, we get the peer_ps_state value as 2.
> 
> We can enable/disable the ps_state events using the debugfs flag
> "ps_state_enable"
> 
> echo Y > /sys/kernel/debug/ieee80211/phyX/ath10k/ps_state_enable
> 
> Y = 1 to enable and Y = 0 to disable
> 
> Tested in QCA4019 with firmware ver 10.4-3.2.1.1-00011
> 
> Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d70c0d463f9d ath10k: add debugfs support to get power save state change of STA

-- 
https://patchwork.kernel.org/patch/10603779/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

