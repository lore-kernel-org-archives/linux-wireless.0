Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC03C4320E
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Aug 2021 13:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3255160EE0
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Aug 2021 13:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239943AbhHQNmU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Aug 2021 09:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239955AbhHQNmJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Aug 2021 09:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CD3D60FBF;
        Tue, 17 Aug 2021 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629207606;
        bh=sEyoYkgf+LK3AB8PmeLeHrmxFSc+SRKOIWZbv+8dyeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DkwmgfolEyDi9xhFXhBIjo56UqXglcCX9LFIsU7QWCRIPD2sFjpFvpwE1p2PRtCvW
         R4bTCUxUeqZq37K74D1POWKXPsLN4/AzkA0X66pvV1UeAg2XSTeumHW/yeyvziQijN
         A8dQup3msDjEKxeWN+j2zKyL43d792LGaejvvA5ZVSPwWQoxnoo85Fgu4f73WTrRwy
         ph3oAh+0hXVK5KW4tKIJiBunphVPhiM3hkha4MYQg6xcU3gmxHPUBEKeQQGqSwP5Bf
         hDphuxMqw/LjU31s+l0qHcbufqsymK7EQohzf7ScasdkhzSkseU/2PRe5AMFi3XPRh
         pUH1TC9eBeS3A==
Date:   Tue, 17 Aug 2021 06:40:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] ethtool: extend coalesce setting uAPI with
 CQE mode
Message-ID: <20210817064003.00733801@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
References: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
        <1629167767-7550-3-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 17 Aug 2021 10:36:05 +0800 Yufeng Mo wrote:
>  include/linux/ethtool.h                            | 16 ++++++++++--
>  net/ethtool/coalesce.c                             | 29 ++++++++++++++++++----
>  net/ethtool/ioctl.c                                | 15 ++++++++---
>  net/ethtool/netlink.h                              |  2 +-

I'd move changes to these files to the first patch, otherwise 
they're hard to find in all the driver modifications.
