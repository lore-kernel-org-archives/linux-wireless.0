Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A36CC77B60
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Apr 2023 14:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbjDZOaX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241106AbjDZOaW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2023 10:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF905449D
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2023 07:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B6E763044
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2023 14:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00022C433EF;
        Wed, 26 Apr 2023 14:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682519420;
        bh=Kp1TnWGnN/Kp/l9dZHy796dza+UltCAqyBeBTE3TkCw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FTvCYqqGklX3i/MbZJlLsiQs1XDzMuNOI9/SMvMjZSsxE/8/GOjJ29lL9iqnyWsWP
         7K1FxdWyfYO2O0uUbVwS+zQBe9+PCb45UPpbx3QktXLmEzkskV6vD34UNd2g4uIv8U
         0x0lP6iNm/QLADxWsRnyn1r8CHOQmEzPgccQwxT0SWpmlzCAu8gsCUsyZqa7dP0Tpk
         9zq8tI/dF02q8+T4Vz5rCOAqsMUtIg99qunj8h1LBcRKBB0tzcL1sCGltxSWq3rIO2
         IRg1kp7RjlJ9mX7y24RAZSpDv84iEh3x1msFgMIhAwfUDkj3D7tf5UuZq81dln/Edh
         hHx7dL1Og+JPA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] wifi: ath12k: add qmi_cnss_feature_bitmap field to
 hardware parameters
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230404032057.3236122-2-quic_cjhuang@quicinc.com>
References: <20230404032057.3236122-2-quic_cjhuang@quicinc.com>
To:     Carl Huang <quic_cjhuang@quicinc.com>
Cc:     <ath12k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <quic_cjhuang@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168251941703.11960.15779460259597957228.kvalo@kernel.org>
Date:   Wed, 26 Apr 2023 14:30:19 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Carl Huang <quic_cjhuang@quicinc.com> wrote:

> Currently the CNSS (Connectivity Subsystem) QMI feature is assigned to
> qmi_wlanfw_host_cap_req_msg_v01 request directly, this prevents chip-specific
> CNSS features from being added easily.
> 
> Solve this by adding a new field qmi_cnss_feature_bitmap to hw_params so
> chip-specific CNSS features can be assigned to this field and later assigned to
> qmi_wlanfw_host_cap_req_msg_v01 request.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4
> 
> Signed-off-by: Carl Huang <quic_cjhuang@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

9981a3ac5887 wifi: ath12k: add qmi_cnss_feature_bitmap field to hardware parameters
34c5625a459a wifi: ath12k: set PERST pin no pull request for WCN7850

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230404032057.3236122-2-quic_cjhuang@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

