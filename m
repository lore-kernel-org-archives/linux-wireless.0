Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229DBC4332F
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Nov 2023 15:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347591AbjKBPdm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347641AbjKBPd3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2023 11:33:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B74194
        for <linux-wireless@vger.kernel.org>; Thu,  2 Nov 2023 08:33:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B5EC433CA;
        Thu,  2 Nov 2023 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698939206;
        bh=YSkyxTlpftdDqfkFADcgeMcrGL2jgJI037pt5vjQbnQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=uP+ZFFDt6A60vU/c+ND9HCqauis7ntCATYz7mBF0HL86s9MkY6+WQwyvgGJIe4z6g
         CRlwRDO4UuTLIG/3nRk1kH2EdI8/h+YmFgIdzudTx6koiJexaXr1Z+FB3CchQlR6nG
         pj3v9ohBBJD5yL9AySEXmUCW4lR72dhBZKRf+cgNAx0GzkuhJx3MZZ7qdd6uDd003v
         s9dsOucSWUZlNm+hQ2R+CSY7VbirFQf/bbrlR+3M1cC6HcGxAHVXIKm7m1wfRAwmdD
         uJr0aLfARWz6iwl1MlFsO03Ov0pgBynVV+YVx35bMAf07V2/gUnuliF+8euZSIi4qF
         Yl3ZbCNGwMiTg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
Cc:     <ath12k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        P Praneesh <quic_ppranees@quicinc.com>
Subject: Re: [PATCH 06/13] wifi: ath12k: Add logic to write QRTR node id to
 scratch
References: <20231030222700.18914-1-quic_rajkbhag@quicinc.com>
        <20231030222700.18914-7-quic_rajkbhag@quicinc.com>
Date:   Thu, 02 Nov 2023 17:33:22 +0200
In-Reply-To: <20231030222700.18914-7-quic_rajkbhag@quicinc.com> (Raj Kumar
        Bhagat's message of "Tue, 31 Oct 2023 03:56:53 +0530")
Message-ID: <87v8akuq4d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Raj Kumar Bhagat <quic_rajkbhag@quicinc.com> writes:

> From: P Praneesh <quic_ppranees@quicinc.com>
>
> Currently only one MHI device is registered successfully on platform
> having two or more identical MHI devices. This is beacuse QMI service
> runs with identical QRTR node ID. And, qrtr-lookup cannot register
> more than one QMI service with identical node ID.
>
> Hence, generate a unique QRTR instance ID from PCIe domain number and
> bus number. QMI allows node id to be written on scratch register.
> Add logic to write QRTR node id to the register. It is available for
> firmware to uniquely identify an instance.
>
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00188-QCAHKSWPL_SILICONZ-1
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
>
> Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
> Signed-off-by: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>

BTW we got a test report that this breaks WCN7850 support.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
