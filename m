Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC151C77B75
	for <linux-wireless@archiver.kernel.org>; Fri,  5 May 2023 12:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjEEM6g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 May 2023 08:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbjEEM6f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2023 08:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8722F1A109
        for <linux-wireless@vger.kernel.org>; Fri,  5 May 2023 05:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C51763DE2
        for <linux-wireless@vger.kernel.org>; Fri,  5 May 2023 12:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F455C433EF;
        Fri,  5 May 2023 12:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683291513;
        bh=iv92TilbooBt2mzK/C7ordb4HzrXSGTFp8/jdDtq6bs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ul+XcD1eN+4+Hgs8HrTKFO7ehz+dBJfN3nxMzGZSgufOxznuKTquC3c+xw+fsz0i3
         Z9HDQeFD7xvkipp21RGfdUW1j8wK0kb0JCHKsBxU/QqtCNRHcHizARUUfxHc0dgZiw
         YM9v2AwWS0LTMZ7b7I+Lu0uJg7fDe7Jlxk3/GS1cDCK7G0lC61r2yr9SPvEZ2vh7WW
         zdAr1k74H7zDa5ZaIsp4ORhsHnmJ/H96UP7gAjHooEpR90SaBA7UqhLZw3PgszYXQH
         LvG5bqQ1KHRO92M/y4bYJfevim5Kd3NQVTdNSc2ggGYxuNw5KAB2V+wU5TtdpYA2hu
         bk1bb3yUbHlOQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: ath12k: fix potential wmi_mgmt_tx_queue race
 condition
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230419095758.19998-1-quic_rgnanase@quicinc.com>
References: <20230419095758.19998-1-quic_rgnanase@quicinc.com>
To:     Ramya Gnanasekar <quic_rgnanase@quicinc.com>
Cc:     ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Karthik M <quic_karm@quicinc.com>,
        Ramya Gnanasekar <quic_rgnanase@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168329151051.30600.2331645235698390250.kvalo@kernel.org>
Date:   Fri,  5 May 2023 12:58:32 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ramya Gnanasekar <quic_rgnanase@quicinc.com> wrote:

> During stress test with maximum VAPs and peer connected, below warning
> is seen:
> 
> [ 1079.110967] ath12k_pci 0004:01:00.0: mgmt tx queue is full
> [ 1079.117708] ath12k_pci 0004:01:00.0: failed to queue management frame -28
> [ 1079.123191] ath12k_pci 0004:01:00.0: mgmt tx queue is full
> [ 1079.129960] ath12k_pci 0004:01:00.0: failed to queue management frame -28
> [ 1079.135641] ath12k_pci 0004:01:00.0: mgmt tx queue is full
> 
> This is caused by potential race condition while accessing skb_queue_len().
> When ath12k_mgmt_over_wmi_tx_work() and ath12k_mac_mgmt_tx() is called concurrently,
> then skb_queue_len() might fetch list length which is modified by skb_queue_tail()
> or skb_dequeue().
> 
> Replace skb_queue_len() with skb_queue_len_lockless() which will
> prevent concurrent modified access using READ_ONCE(). And also use '>=',
> in case we queue a few SKBs simultaneously.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Karthik M <quic_karm@quicinc.com>
> Signed-off-by: Ramya Gnanasekar <quic_rgnanase@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

e995f3f602a3 wifi: ath12k: fix potential wmi_mgmt_tx_queue race condition

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230419095758.19998-1-quic_rgnanase@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

