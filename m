Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FD5C77B76
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Apr 2023 12:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjDQM4m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Apr 2023 08:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQM4k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2023 08:56:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1AF5FF1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Apr 2023 05:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3630261EB1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Apr 2023 12:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EBBC433EF;
        Mon, 17 Apr 2023 12:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681736187;
        bh=4C03S7tkBjOO7SnCpEldDUbKLnjxgFdc4gzMvtDUVB8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=V0UIPqULyCPUlXr/DnZZqwAuzD9iOa4I+RwFRXWfqMr93g6jBbHPnsdC4zffe0FXF
         3dUkDJe4NsHJEbVWKrwJmTaIGZv+winXn8BorJFJLLsU4EgdDeuxZbPImSX3wV83Mv
         d+WBRGYUGmCpHHvXFcKEnKcWeSpbcSOoObJO5rC+F+i/z8ZV0+BSH3zpD7lx8yQws6
         EHYy1r8ONYQbxSIeIaOfEHRsel21jbswSPMjrSJBCZXbRsuEZ6hj/DZxJRg8mJf1N2
         dQ+ig9NDqq1xVxxuqsJrV5aq9iQCddgS9sUULzAxTSGCkhrugbTYp1a/RuQRUCanMA
         +BQeS1mMEdImA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ramya Gnanasekar <quic_rgnanase@quicinc.com>
Cc:     ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Karthik M <quic_karm@quicinc.com>
Subject: Re: [PATCH] wifi: ath12k: add wait operation for tx management packets for flush from mac80211
References: <20230405054646.7300-1-quic_rgnanase@quicinc.com>
Date:   Mon, 17 Apr 2023 15:56:24 +0300
In-Reply-To: <20230405054646.7300-1-quic_rgnanase@quicinc.com> (Ramya
        Gnanasekar's message of "Wed, 5 Apr 2023 11:16:46 +0530")
Message-ID: <87leiqwttz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ramya Gnanasekar <quic_rgnanase@quicinc.com> writes:

> From: Karthik M <quic_karm@quicinc.com>
>
> Transmission of management packets are done in a work queue. Sometimes
> the workqueue does not finish Tx immediately, then it lead after the next
> step of vdev delete finished, it start to send the management packet to
> firmware and lead firmware crash.
>
> ieee80211_set_disassoc() have logic of ieee80211_flush_queues() after
> it send_deauth_disassoc() to ath12k, its purpose is make sure the
> deauth was actually sent, so it need to change ath12k to match the
> purpose of mac80211.
>
> To address these issues wait for Tx management as well as Tx data packets.
>
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
>
> Signed-off-by: Karthik M <quic_karm@quicinc.com>
> Signed-off-by: Ramya Gnanasekar <quic_rgnanase@quicinc.com>
>
> diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
> index a89e66653f04..499b81cd938e 100644

Ramya, how do you submit your patches? Your patches are missing the
"---" line which breaks my scripts. I have asked this already before but
no reply from you:

https://lore.kernel.org/all/87edqot8m4.fsf@kernel.org/

Please do not ignore my questions. If you continue to do that I will
just stop taking patches from you.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
