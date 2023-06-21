Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EDDEB64DD
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Jun 2023 09:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjFUJly (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Jun 2023 05:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjFUJlP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2023 05:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6129B
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2023 02:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3626B614D6
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2023 09:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E9C433C8;
        Wed, 21 Jun 2023 09:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687340449;
        bh=kx8wPX6HZiU2BmG+akCFgJU1lKDkwtpKilIrN+1LOY0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nwS1qRagxqVObn7UsgsnF9cb5634/A+zQrbf/vsT5Wl9dsHXtuY56rp1wE8PFyGop
         ZKNxOfMOp8qBfnzGJVJpZeDwrx+EoWYkNoKkSq/J+s/TD6Pt4fBuDoxDN4IS7sCIYj
         lfAMKS75k7DBCHZD3dqyz/6I+cIvvnF5huWHs2CcpJyqXW5tjxR0muRaT0zCfPHTT3
         3/GhOwiXhDGrYX5ulI6+fQOQ8v8xTJ9NijRrfX7EHSkiGQZd1z1woz54IOnSmNohsT
         sHkXOkSQHmh0iY+PBW+DXGRUZmQcqkQVGmO9ifSqQnZF6Qma0/7hEgUSIwkf8hNZPB
         4w0Wzynpel73w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw88: Fix action frame transmission fail before
 association
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230615114348.7193-1-pkshih@realtek.com>
References: <20230615114348.7193-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <tony0620emma@gmail.com>, <phhuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <168734044654.380100.17244143747732031239.kvalo@kernel.org>
Date:   Wed, 21 Jun 2023 09:40:48 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Po-Hao Huang <phhuang@realtek.com>
> 
> For combo chips, antennas were controlled by bluetooth only during
> power on. If WiFi wish to do transmission, notification to the coexistence
> module are required. Previously we only do this before authentication.
> To allow transmission before auth, such as management TX, now we start
> the initiation of coexistence earlier so antennas are shared between
> WiFi and bluetooth after set_channel(), and frames could then be sent.
> 
> Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

2ce9a91fe8bf wifi: rtw88: Fix action frame transmission fail before association

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230615114348.7193-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

