Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7234C636CC
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Feb 2023 07:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbjBOHva (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Feb 2023 02:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjBOHv3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2023 02:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE3535264
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2023 23:51:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA54B81FF3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2023 07:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9683C433D2;
        Wed, 15 Feb 2023 07:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676447485;
        bh=xL5VH96zn6omdwziIXVX2igQ5FKduu5R9j3RaQetoa0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ZFPdgUVVYKF5g1slbbf5Nz6S/AR4ccAafylQ7aoqaQPCP8no6rpcPrk8UHXCKpy4R
         8aV/Nsb0MDpQzUHe+qkR8XT0wXNh9XNT53/Rt1gaLbbNc6+x5GfQxCVxqKK4j2ZJDE
         6CfXdCQ0ElTvPsnVxZsZuW9bPI7Z80gY86ZeKIjtN8HNPKFgxqK6fTIXwOoVRz8hO5
         oX4ty7yk8ctby0tIa8gcGufvHqGnX1e1Nt3engKcZxn+0KYoMItf9s/gZ2q61XScOP
         uxhkAskhXgR/n3jXAgJTz/mdYNptemXBcDFPqb1dPTUcUMsIy2JZAD8TiZz1SgN0P6
         HH10maJrwXJrw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: move H2C of del_pkt_offload before polling
 FW
 status ready
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230214114314.5268-1-pkshih@realtek.com>
References: <20230214114314.5268-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <timlee@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167644748279.2758.17616836371192957389.kvalo@kernel.org>
Date:   Wed, 15 Feb 2023 07:51:24 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chin-Yen Lee <timlee@realtek.com>
> 
> The H2C of del_pkt_offload must be called before polling FW status
> ready, otherwise the following downloading normal FW will fail.
> 
> Fixes: 5c12bb66b79d ("wifi: rtw89: refine packet offload flow")
> Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

ce1ba4d782d9 wifi: rtw89: move H2C of del_pkt_offload before polling FW status ready

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230214114314.5268-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

