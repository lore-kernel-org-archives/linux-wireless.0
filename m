Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD530C001E0
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Aug 2023 14:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbjHAOri (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Aug 2023 10:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbjHAOri (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2023 10:47:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F85B1BCF
        for <linux-wireless@vger.kernel.org>; Tue,  1 Aug 2023 07:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E21F6615D3
        for <linux-wireless@vger.kernel.org>; Tue,  1 Aug 2023 14:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072D2C433C8;
        Tue,  1 Aug 2023 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690901256;
        bh=A6d4S4Wf0mfkNxaD8pMeDfYCvT82PGNAf+8GL8JCK9o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JLMVXFpeVkQTRdfh5syOy/aSgmoS2G5FrKdmEGp58UjyJadahjTUGwlA3gcC1/FNH
         Drc41jqOb2Pfxs4ZTLiv1lqmWj5LRn8/ywS/ZywbgsQiTHIwn4uVFs56PVYnGMv491
         q75ytQ+ZVWBTGZtfOu0sbzJ1ufidQVvKzPIkHKneabf5GUm3aufbLMHzmlHj4XompQ
         4mvXv4T5Xs9GxXSkCbbfUkIeXVoxQLrs1QdJ/0QKWvXyJEvkN+j4LvsUZAXW6Rd6mr
         28GuZmZXe5iMBxHpC4ZqYKTwWAahrptX5Du63/kcathxLx5KQx1yNgEEPIHBGogUZ9
         3h+oxMEvwepdQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7] wifi: mwifiex: Fix OOB and integer underflow when rx
 packets
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230723070741.1544662-1-pinkperfect2021@gmail.com>
References: <20230723070741.1544662-1-pinkperfect2021@gmail.com>
To:     Polaris Pi <pinkperfect2021@gmail.com>
Cc:     matthewmwang@chromium.org, briannorris@chromium.org,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        Polaris Pi <pinkperfect2021@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169090125328.212423.6884831819316913937.kvalo@kernel.org>
Date:   Tue,  1 Aug 2023 14:47:34 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Polaris Pi <pinkperfect2021@gmail.com> wrote:

> Make sure mwifiex_process_mgmt_packet,
> mwifiex_process_sta_rx_packet and mwifiex_process_uap_rx_packet,
> mwifiex_uap_queue_bridged_pkt and mwifiex_process_rx_packet
> not out-of-bounds access the skb->data buffer.
> 
> Fixes: 2dbaf751b1de ("mwifiex: report received management frames to cfg80211")
> Signed-off-by: Polaris Pi <pinkperfect2021@gmail.com>
> Reviewed-by: Matthew Wang <matthewmwang@chromium.org>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-next.git, thanks.

119585281617 wifi: mwifiex: Fix OOB and integer underflow when rx packets

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230723070741.1544662-1-pinkperfect2021@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

