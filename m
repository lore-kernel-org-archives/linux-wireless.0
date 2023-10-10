Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F85CD68F5
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Oct 2023 07:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442437AbjJJHX2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Oct 2023 03:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442419AbjJJHX2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2023 03:23:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FF09F
        for <linux-wireless@vger.kernel.org>; Tue, 10 Oct 2023 00:23:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FECC433C8;
        Tue, 10 Oct 2023 07:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696922605;
        bh=ov8mQoiPuDvyppz0707yD4QUGRw0hSxq2OdsgOrCKjU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=cuszz+DrTvLMYNMq3EsgEVg8QixFxCtFFYMIgQog9aSg0jJyn95ilz9hS8ER6w0vw
         LEH4M8V+pylXhgkWaF8kOAh6JxtT0ScQzyZTnOXnvXWKzwp0ILRkGmDIV6cJ5P7jMy
         X8xSdv22wC98fxVZIr4CQlJLoiPOu3jdl2bwusPHO6CWo9lqeXlQc2FjPfmECHVPI4
         p4s0WUqFdHiOjcVWY/D6lKYSDiqDgrY3l8vY5yweLWbw5iKWkG9Wo7nTePSgAByYz2
         6xTAMyH5+ZxTo5Q3uncjEDJV1vOCsdoqdObxxiNWcnph2wPXPWeRwkLkDA+B4veMOD
         7ig8ofWKYxT6A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: call ath11k_mac_fils_discovery() without
 condition
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20231004044915.6817-1-quic_alokad@quicinc.com>
References: <20231004044915.6817-1-quic_alokad@quicinc.com>
To:     Aloka Dixit <quic_alokad@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Aloka Dixit <quic_alokad@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169692260273.2589238.2783908442272487567.kvalo@kernel.org>
Date:   Tue, 10 Oct 2023 07:23:24 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aloka Dixit <quic_alokad@quicinc.com> wrote:

> Mac80211 does not set flags BSS_CHANGED_FILS_DISCOVERY and
> BSS_CHANGED_UNSOL_BCAST_PROBE_RESP if there are no updates to
> FILS discovery and unsolicited broadcast probe response transmission
> configurations respectively. This results in the transmissions getting
> stopped during BSS change operations which do not include these
> attributes. Remove the checks for the flags and always send the existing
> configuration to firmware.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
> Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

e149353e6562 wifi: ath11k: call ath11k_mac_fils_discovery() without condition

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20231004044915.6817-1-quic_alokad@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

