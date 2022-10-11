Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D15DC433FE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Oct 2022 08:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJKImH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Oct 2022 04:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJKImF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Oct 2022 04:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613E174CFB
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2022 01:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB19E6114D
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2022 08:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74678C433C1;
        Tue, 11 Oct 2022 08:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665477723;
        bh=OMYmx/26nbOXubts18uFutcbJVA+GFfR3LxpIn/FKTk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=mwgZlUBVLiZsbDVfFEtbwusG/BWOqS0fFeE8PJj2d+q4dVchPgi+zfO8Kka0MDNd8
         Wq5/pz1M2biD8FBHW+uA1RpMqpGHJn6wz8AnGaAGDL1XpgMA+GLX2iBEG87Y4/VUoM
         u05PFazy6uY8b189wyyiqQCyWzRvejvTwWFpH32889FlWWJqtti5OCrOoYsC4xH6WO
         Fb6XPupQX1mo0VBjY+53o0Xm1qHCKkUBr8UEELCUINAVjDkT44o+Ix8NUuDvw33+R3
         PaMJ8cWh80Gg34RQx6GhEriOwBxAQaySrxWfCr+R34ow0MQGyBChjRqqd40m1EhIH1
         avxGCcf+kwjnQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 6.1 1/2] wifi: mt76: fix receiving LLC packets on
 mt7615/mt7915
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221005130824.23371-1-nbd@nbd.name>
References: <20221005130824.23371-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Chad Monroe <chad.monroe@smartrg.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166547771808.14345.12170744535376568553.kvalo@kernel.org>
Date:   Tue, 11 Oct 2022 08:42:02 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:

> When 802.3 decap offload is enabled, the hardware indicates header translation
> failure, whenever either the LLC-SNAP header was not found, or a VLAN header
> with an unregcognized tag is present.
> In that case, the hardware inserts a 2-byte length fields after the MAC
> addresses. For VLAN packets, this tag needs to be removed. However,
> for 802.3 LLC packets, the length bytes should be preserved, since there
> is no separate ethertype field in the data.
> This fixes an issue where the length field was omitted for LLC frames, causing
> them to be malformed after hardware decap.
> 
> Fixes: 1eeff0b4c1a6 ("mt76: mt7915: fix decap offload corner case with 4-addr VLAN frames")
> Reported-by: Chad Monroe <chad.monroe@smartrg.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

2 patches applied to wireless.git, thanks.

47c44088ac08 wifi: mt76: fix receiving LLC packets on mt7615/mt7915
443dc85ad13e wifi: mt76: fix rx checksum offload on mt7615/mt7915/mt7921

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221005130824.23371-1-nbd@nbd.name/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

