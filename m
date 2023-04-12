Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F4EC77B6E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Apr 2023 09:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjDLJ7E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Apr 2023 05:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjDLJ7D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2023 05:59:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC32730CB
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2023 02:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A12C62D44
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2023 09:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFBAC433EF;
        Wed, 12 Apr 2023 09:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681293541;
        bh=DkbdkJrCIGKo6sV6b92AMSs4dyTp3F0mcGn6aU5aGz0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Kmc8KbfDorBPScEa8DazjKwdSUc4LEMuOO5/q6m5ssC3xMf5tk5qyQCaUgL5QGEEF
         C1C9qPE+kYZGDAj8VBzMa2BIUS4cxnW54MpZGo8Ml/gDDO9LHmo1hU/1sG7VfO2/ee
         GYwS4bvRcbTlJ4DC0S7JW2kzZT9u7/QbaqH00aVgYeID0+wmMF56+FY8RfATnmXP74
         iVIVZKeT4PiNfogmYMLOFnIWzP/aESORb8JBl6g4Y7goV09a4KLDq1a814KvTH62GW
         FSgmcjVDDBxKxi6bEyQ+E4zp73eYAR1DvYgLKzmqz+qJ/qBz6BU+IPU30lXGSh8fnN
         lWbyrV8oG/yGw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: fix rssi station dump not updated in
 QCN9074
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230320110312.20639-1-quic_ppranees@quicinc.com>
References: <20230320110312.20639-1-quic_ppranees@quicinc.com>
To:     P Praneesh <quic_ppranees@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        P Praneesh <quic_ppranees@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168129353877.14673.14171521280937840187.kvalo@kernel.org>
Date:   Wed, 12 Apr 2023 09:59:00 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

P Praneesh <quic_ppranees@quicinc.com> wrote:

> In QCN9074, station dump signal values display default value which
> is -95 dbm, since there is firmware header change for HAL_RX_MPDU_START
> between QCN9074 and IPQ8074 which cause wrong peer_id fetch from msdu.
> Fix this by updating hal_rx_mpdu_info with corresponding QCN9074 tlv
> format.
> 
> Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01695-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

031ffa6c2cd3 wifi: ath11k: fix rssi station dump not updated in QCN9074

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230320110312.20639-1-quic_ppranees@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

