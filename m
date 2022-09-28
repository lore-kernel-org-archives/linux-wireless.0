Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA01AC04A95
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Sep 2022 07:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiI1Hs4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Sep 2022 03:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiI1Hsf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2022 03:48:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5F6122076
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2022 00:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4663FB81E8A
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2022 07:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E85C433C1;
        Wed, 28 Sep 2022 07:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664351103;
        bh=6SQSuRMC+R7kxqaZdTa6Rn0P4+/7LiIcZwMuBTCDzDc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IYgh5dEN6FoWcOdJgKFGwshdH5xYxJYWLajRdzgfyhmbgAQkkiaWhUCgOhGlCWBRv
         XjPRri4VGzN19lBWOX9svGTg2uVOJDZehHn1mx1XrroguzjNrRv15xQUBEDr549ooZ
         y5lKqr3oW52FAiurIeT16u7pckcAw1qoK4wY2q1Nvzr6tRoXrw3ip+6yR33USqSCwU
         u/jLOUeABAoioLCl2LgE5gJ+tMXjc9duu8ZIRJzxrwLMqCsQTvBu8IK8OsVylXMQjL
         /TBqrVqlMLxbCwuF7BxakpwWcEPS0XbdxcuV/1tdySoduHEBnpzh/Q5z/48owNeL3h
         plKoDqP+DsATg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath11k: stop tx queues immediately upon firmware
 exit
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220923170235.18873-1-quic_adisi@quicinc.com>
References: <20220923170235.18873-1-quic_adisi@quicinc.com>
To:     Aditya Kumar Singh <quic_adisi@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        Aditya Kumar Singh <quic_adisi@quicinc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166435109959.3623.15599848077820461188.kvalo@kernel.org>
Date:   Wed, 28 Sep 2022 07:45:02 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aditya Kumar Singh <quic_adisi@quicinc.com> wrote:

> Currently, recovery flag is set immediately upon firmware
> exit but tx queues are stopped once firmware arrives back
> and is ready which is during ath11k_core_restart. Once
> ieee80211 hw restart is completed, tx queues are resumed.
> If during the time delta between firmware exit and firmware
> ready, mac80211 send packets, currently ath11k will drop it
> since recovery flag will be set. But warning prints will
> come -
>   "ath11k c000000.wifi: failed to transmit frame -108"
> 
> If more tx packets are there, this could lead to flooding
> of above print.
> 
> However, actually tx queues should be stopped immediately
> when firmware leaves. This will prevent packets to get
> dropped when firmware is recovering.
> 
> Add fix to stop tx queues immediately after firmware exit.
> 
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1
> 
> Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

81e60b2dfb27 wifi: ath11k: stop tx queues immediately upon firmware exit

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220923170235.18873-1-quic_adisi@quicinc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

