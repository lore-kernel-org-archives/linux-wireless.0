Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B93C433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Feb 2022 10:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345230AbiBUK7X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Feb 2022 05:59:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344498AbiBUK60 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Feb 2022 05:58:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C2831927
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2022 02:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0977EB80DA4
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2022 10:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BA4C340E9;
        Mon, 21 Feb 2022 10:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645439324;
        bh=yTf6jL73vntZaHIBChTJh2VJ4HOTz4q/XMDKDrjD3Bw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ByCHktconmI8ixmMLXfyosbEkfgu/TDiUnLkP5aZ7+h5ecqwjOFdlcS9rsSlRXU1O
         gN+34kG8XOpJTgFn6wfIyQH5TXOc8lgAeIQf8v4IbPrC1wL68ynkjtpgYUFLxuz/zf
         zeQ03TOfTU5SQDfFm/u1xG6lwsNkSt/2Uie1bteBfw76eWii6g2gxMC+Mi5Kqj1jkA
         CuYfryIMsQVcoDs5m2W98F42Lecikrfx3IqgxS65Hye1eCwTmX6UfRYKh2Y1becDLH
         C4gQLLCLGSaodcJL4OZIV/7R52j8rRlwICM/tTm0zemuFJblhkgjZhxOV5PVu0Xjk8
         Qoh2gA0T77AwQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: Handle failure in qmi firmware ready
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1645079195-13564-1-git-send-email-quic_seevalam@quicinc.com>
References: <1645079195-13564-1-git-send-email-quic_seevalam@quicinc.com>
To:     Seevalamuthu Mariappan <quic_seevalam@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Seevalamuthu Mariappan <quic_seevalam@quicinc.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164543932220.26423.15078831707395923545.kvalo@kernel.org>
Date:   Mon, 21 Feb 2022 10:28:43 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Seevalamuthu Mariappan <quic_seevalam@quicinc.com> wrote:

> In some scenarios like firmware crashes during init time
> and hardware gets restarted after qmi firmware ready event.
> During restart, ath11k_core_qmi_firmware_ready() returns timeout.
> But, this failure is not handled and ATH11K_FLAG_REGISTERED is set.
> 
> When hardware restart completed, firmware sends firmware ready event
> again. Since ATH11K_FLAG_REGISTERED is already set, ath11k handles
> this as core restart. Inits are not done because of previous timeout.
> But ath11k_core_restart does deinit's which causes NULL pointer crash.
> 
> Fix this by handling failure from ath11k_core_qmi_firmware_ready().
> 
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-00881-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Seevalamuthu Mariappan <quic_seevalam@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

a19c0e104db9 ath11k: Handle failure in qmi firmware ready

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1645079195-13564-1-git-send-email-quic_seevalam@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

