Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2B3C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 14:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C637920843
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 14:12:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oGzER0UV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hzdzcExs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C637920843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbeIZUZR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 16:25:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbeIZUZR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 16:25:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3026060C83; Wed, 26 Sep 2018 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537971128;
        bh=sZow61VKqeDHhG41Zf69iA2RVyOFJvJcifNxVHLyDf0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=oGzER0UVMkc1YkXUY9fIU15IY7AI9odHd2Au06bSCrzsDP28UHFyaydOs49UC9vL0
         EHQJjJ+P+DcilSI7kM/MID4fOMcZt6wE25eP0Ln3DF1Tjs27YkeVb/pRI/9Vcdchic
         rAi70Ph+SR+/rHRzKpdSWbzPQGHQA7rXjYpTj0xQ=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2CECE60134;
        Wed, 26 Sep 2018 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1537971123;
        bh=sZow61VKqeDHhG41Zf69iA2RVyOFJvJcifNxVHLyDf0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hzdzcExs9hqKqWId0HN32CM+nodtM27G3L6OfAE43XM1cRBjTksDTmQy8lGEjKX3n
         Kb6yGFaaacmSB858kGtQi9r8PNjbny02AjQpEkKnvUS5ypTpQDo8snlC9XfI0nN7W2
         LN9zHadOFkUmgJLTad/0gB9oOGHcsyhEzlKXeyWY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2CECE60134
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
Message-Id: <20180926141208.3026060C83@smtp.codeaurora.org>
Date:   Wed, 26 Sep 2018 14:12:08 +0000 (UTC)
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

This introduced a new warning:

drivers/net/wireless/ath/ath10k/wmi.c:5061:1: warning: symbol 'ath10k_wmi_event_peer_sta_ps_state_chg' was not declared. Should it be static?

I fixed this in the pending branch.

-- 
https://patchwork.kernel.org/patch/10603779/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

