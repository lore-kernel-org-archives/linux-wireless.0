Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB43C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Apr 2022 11:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345565AbiDALkH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Apr 2022 07:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344937AbiDALkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Apr 2022 07:40:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1389D1DB89E
        for <linux-wireless@vger.kernel.org>; Fri,  1 Apr 2022 04:38:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDD10B8245D
        for <linux-wireless@vger.kernel.org>; Fri,  1 Apr 2022 11:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0F5C2BBE4;
        Fri,  1 Apr 2022 11:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648813093;
        bh=JeZ02QkfWVzX6ts+UvtEHBfdA9PpxWAQowCGmjr19R0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=P7yd6E74dtHmw5gQgplfq0oqYqm9HXuoAt+DAPxAekQjzUHm6Mmcm+nyL9wX6Ij5u
         4x6kDEZQdJyHO1mb3VCraxt1SXA01L6IiqVeSG8Kz6YVeF0QrnGznpiUG99FwRqBiw
         JjUHzmDemt/o6nUHKE2bOGjc/96S5gdJp0oVyIMHdabOebJT9GACwEojM8re73qMjK
         bnWuIN7fn4tZLkSC1hJjXo4V0Et99sRLElNOMQoYUCs5z86fM+nKCu+5EgPp9zcdUv
         5ccoKK3SYXNXGXy9k3+o3p2tuyS0OO7K3Ff/xLBkqsZ+iu8V/V+Jw7ny56282suNZ9
         GUZEBvodhBE3w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Baochen Qiang <quic_bqiang@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] ath11k: add support for extended wmi service bit
References: <20220401073200.1195070-1-quic_bqiang@quicinc.com>
Date:   Fri, 01 Apr 2022 14:38:10 +0300
In-Reply-To: <20220401073200.1195070-1-quic_bqiang@quicinc.com> (Baochen
        Qiang's message of "Fri, 1 Apr 2022 15:31:59 +0800")
Message-ID: <875yntuj8d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Baochen Qiang <quic_bqiang@quicinc.com> writes:

> From: Wen Gong <quic_wgong@quicinc.com>
>
> Currently the wmi service bis is report from firmware, it is divided
> to 128 bits for each segment. The first segment is processed by
> ath11k_wmi_service_bitmap_copy(), the second segment is processed by
> ath11k_service_available_event() with WMI_TAG_SERVICE_AVAILABLE_EVENT,
> When the service bit exceed 256 bits, then firmware report it by tag
> WMI_TAG_ARRAY_UINT32 in WMI_SERVICE_AVAILABLE_EVENTID.
>
> ath11k does not process the third segment, this is to extend the wmi
> service bits from 256 to 384 for the third 128 bits. The 3 enum value
> WMI_MAX_SERVICE(128)/WMI_MAX_EXT_SERVICE(256)/WMI_MAX_EXT2_SERVICE(384)
> are convenient to process the service bits.
>
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
>
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>

Baochen, you need to add your own s-o-b in the end. Please read:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

But remember to keep Wen's s-o-b, they should be never removed.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
