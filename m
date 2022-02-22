Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0338EC433EF
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Feb 2022 14:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiBVO25 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiBVO24 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Feb 2022 09:28:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA7C248A
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2022 06:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2FDF614EB
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2022 14:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CD8C340F1;
        Tue, 22 Feb 2022 14:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645540110;
        bh=Vx/YhCWQL5CrKjxhn+hHvjwgVfIfMqKnqUz3/5kYuZQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dzM/2XVMrHIieX2HnPUwzHTuY907TpWUyr1TzfIqoorjsHSh/aZ8Ob+PfZyCS3sU/
         jDyR6igOI93OvIijFfszKqkl9lcsQR3VRBJvVczlAL99j3Z/NgyXLOzaGm4alLcU9x
         /Oe1hynDdo/QJkIirjToHb0oMo0udCjHFYT9AvcVmJdyZiNEazcbh5jkC/4nfKmCjN
         mVYoHWYS/dEl7GTTFS35xq/Qy+YQ2afwP+qAQYEjJ7NXsu95h3zrkIbdDfwh75iGvu
         Ni7KLN4F2PGtkxYBUySufEZaL5A6+tSsgss4Y4g7/jbE/F8aHxtcLGsdb51cDg9nGX
         JwWRvdvJnYDIA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Carl Huang <quic_cjhuang@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] ath11k: Add basic WoW functionalities
References: <1644308006-22784-2-git-send-email-quic_cjhuang@quicinc.com>
        <164553444424.23898.1586617399462118980.kvalo@kernel.org>
        <871qzvvw7c.fsf@kernel.org>
Date:   Tue, 22 Feb 2022 16:28:25 +0200
In-Reply-To: <871qzvvw7c.fsf@kernel.org> (Kalle Valo's message of "Tue, 22 Feb
        2022 15:59:19 +0200")
Message-ID: <87wnhnugae.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Kalle Valo <kvalo@kernel.org> writes:
>
>> Carl Huang <quic_cjhuang@quicinc.com> wrote:
>>
>>> Implement basic WoW functionalities such as magic-packet, disconnect
>>> and pattern. The logic is very similar to ath10k.
>>> 
>>> When WoW is configured, ath11k_core_suspend and ath11k_core_resume
>>> are skipped as WoW configuration and hif suspend/resume are done in
>>> ath11k_wow_op_suspend() and ath11k_wow_op_resume().
>>> 
>>> Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1
>>> 
>>> Signed-off-by: Carl Huang <quic_cjhuang@quicinc.com>
>>> Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
>>> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
>>
>> This patchset adds new warnings:
>>
>> drivers/net/wireless/ath/ath11k/mac.c:7284:5: warning: no previous
>> prototype for 'ath11k_mac_flush_tx_complete' [-Wmissing-prototypes]
>> drivers/net/wireless/ath/ath11k/mac.c:7284:5: warning: symbol
>> 'ath11k_mac_flush_tx_complete' was not declared. Should it be static?
>> drivers/net/wireless/ath/ath11k/mac.c:8218:34: warning: cast to restricted __be64
>> drivers/net/wireless/ath/ath11k/wow.c:409: line length of 98 exceeds 90 columns
>> drivers/net/wireless/ath/ath11k/wow.c:527: line length of 96 exceeds 90 columns
>> drivers/net/wireless/ath/ath11k/wow.c:528: line length of 92 exceeds 90 columns
>> drivers/net/wireless/ath/ath11k/mac.c:8111: line length of 96 exceeds 90 columns
>> drivers/net/wireless/ath/ath11k/mac.c:8168: line length of 92 exceeds 90 columns
>> drivers/net/wireless/ath/ath11k/mac.c:8188: line length of 92 exceeds 90 columns
>
> I fixed all these warnings in the pending branch.

I also cleaned up debug messages, changed some function names, change
ath11k_info() to ath11k_warn() etc.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
