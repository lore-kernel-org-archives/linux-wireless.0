Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40E9C77B79
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Apr 2023 13:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjDQNF1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Apr 2023 09:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjDQNFK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2023 09:05:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8541B762
        for <linux-wireless@vger.kernel.org>; Mon, 17 Apr 2023 06:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA59261CB2
        for <linux-wireless@vger.kernel.org>; Mon, 17 Apr 2023 13:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCE8C433D2;
        Mon, 17 Apr 2023 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681736478;
        bh=vBAfpOF39qoB/LjTpHJuu0BLFpzakopzM1Xko9cDe1Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=T/0MqB+/a4fdfVUVd2KPtRAXv4rRwo6YUfv/7DbpK/n/J511474q9GURGeTFEy4GU
         OIcXqLjtnQxtEeCXjy+67GD9qEVI+ZMa4JsJsRwQJwcRur3hBrkKZFnWPZSC9XiELG
         9YZ5gikTIoNrgcUD25bqNDoKYvQAr31U8j+7/+WNVuJMdHFKAzSqhMlKE1DquXcVyn
         FPZOG8Qbjo8QvPle0sgK01Ee9BaV6eeo+zaES8d4P0v36xvRBtoggqJf5CjAMRY6Xb
         lrLj1NpwNXYiqO72xGN6X71Q0Wf4rmq7yzR1NgK07Fr0KPAuELTyXL5xL5z53pcJYp
         CORrRlpOzT+dg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Aloka Dixit <quic_alokad@quicinc.com>
Cc:     <ath12k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
Subject: Re: [PATCH v3 03/11] wifi: ath12k: process EHT capabilities
References: <20230413215156.2649-1-quic_alokad@quicinc.com>
        <20230413215156.2649-4-quic_alokad@quicinc.com>
Date:   Mon, 17 Apr 2023 16:01:14 +0300
In-Reply-To: <20230413215156.2649-4-quic_alokad@quicinc.com> (Aloka Dixit's
        message of "Thu, 13 Apr 2023 14:51:48 -0700")
Message-ID: <87h6tewtlx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aloka Dixit <quic_alokad@quicinc.com> writes:

> Add WMI support to process the EHT capabilities passed by the firmware.
> Add required EHT specific definitions in structures ath12k_band_cap and
> ath12k_wmi_svc_rdy_ext_parse.
>
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
> Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
> Signed-off-by: Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>

This had a new warning:

drivers/net/wireless/ath/ath12k/wmi.c:4072: line length of 97 exceeds 90 columns

I fixed that in the pending branch. But please use ath12k-check before
you submit the patches.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
