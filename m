Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9840AC43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 11:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 542A820815
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 11:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ifUr0cMV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ifUr0cMV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 542A820815
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbeKQVaC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 16:30:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35444 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbeKQVaB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 16:30:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A18BD60791; Sat, 17 Nov 2018 11:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542453220;
        bh=5YW36BaMgabj51UfufySZzF/37VwdaOoWu4TJCS4NeA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ifUr0cMVJQuy1/u9ibhhc+yN+worXuUs3KxYE0hYwsUsy8VVasMKLOoLVI8UcMoLb
         GhW9X5mQF4QfwV43a+wGsiqisChYy+Y4Fqa5yZNCzL2FNXNcCekhIrivieutpqsrKm
         GFG65eHp3Mcyg9ZMk3tMqjSTJG2eRW/Y8qyJltc8=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 183C760386;
        Sat, 17 Nov 2018 11:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542453220;
        bh=5YW36BaMgabj51UfufySZzF/37VwdaOoWu4TJCS4NeA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ifUr0cMVJQuy1/u9ibhhc+yN+worXuUs3KxYE0hYwsUsy8VVasMKLOoLVI8UcMoLb
         GhW9X5mQF4QfwV43a+wGsiqisChYy+Y4Fqa5yZNCzL2FNXNcCekhIrivieutpqsrKm
         GFG65eHp3Mcyg9ZMk3tMqjSTJG2eRW/Y8qyJltc8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 183C760386
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues
References: <cover.1542384797.git.lorenzo.bianconi@redhat.com>
        <98cf4a8f8a7f7840803b91b7c9078d8b61febee9.1542384797.git.lorenzo.bianconi@redhat.com>
Date:   Sat, 17 Nov 2018 13:13:37 +0200
In-Reply-To: <98cf4a8f8a7f7840803b91b7c9078d8b61febee9.1542384797.git.lorenzo.bianconi@redhat.com>
        (Lorenzo Bianconi's message of "Fri, 16 Nov 2018 17:19:21 +0100")
Message-ID: <87zhu83qji.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Starting from mac80211 commit adf8ed01e4fd ("mac80211: add an optional
> TXQ for other PS-buffered frames") and commit 0eeb2b674f05 ("mac80211:
> add an option for station management TXQ") a new per-sta queue has been
> introduced for bufferable management frames.
> sta->txq[IEEE80211_NUM_TIDS] is initialized just if the driver reports
> the following hw flags:
> - IEEE80211_HW_STA_MMPDU_TXQ
> - IEEE80211_HW_BUFF_MMPDU_TXQ
> This can produce a NULL pointer dereference in mt76_stop_tx_queues
> since mt76 iterates on all available sta tx queues assuming they are
> initialized by mac80211. This issue has been spotted analyzing the code
> (it has not triggered any crash yet)
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

A very good commit log, thanks for that!

> This patch is for 4.20

Ok, I'll wait for review comments and then queue this for 4.20.

BTW, it would make my patch sorting easier if you could add a release
label in the subject:

[PATCH 4.20] mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues

More info:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#tree_labels

-- 
Kalle Valo
