Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B98BECAAA1
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Sep 2022 11:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiILL03 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Sep 2022 07:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiILL02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2022 07:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6BC22B1C;
        Mon, 12 Sep 2022 04:26:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AED95611BD;
        Mon, 12 Sep 2022 11:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1B2C433C1;
        Mon, 12 Sep 2022 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662981987;
        bh=36oftSX0a8AnDIM/hua8IqdsFvfq84oTzRMTwfAJZy4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lWbdCkXkJQLNKozdj/i4ML86uGUZiko1dJWLfPISnSHjqzhe2Uk4pLKvE055iJhct
         ZX5uOOJI96tj8qZH6x8UxuVGGRpZKDiKOTV8+O2deJPVqP3fowY2VH48xvnV0YuWbA
         BkJtEZCs3WJ+xZlu6XCd6Vqip+wB6j4vCZBq8xQbSEXEwDRJVPKrdypdaswRcWiHVc
         F2ya7Zc68YuvedE/EdGjZsC5alRXSd0CO5qeOzAEzPR0e9Gh81Wk9OIGLyJLfcU3WF
         ajIzudYSv4Qd3seEaT/r4+3PRgGLddcJp6WAcxPqSlTC+Odvp4tZdVoqSqZY3d1E/Y
         YJUFAQLyXyexA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [6.0] wifi: mt76: fix 5 GHz connection regression on
 mt76x0/mt76x2
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220907095228.82072-1-nbd@nbd.name>
References: <20220907095228.82072-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166298198430.17348.590164994315301024.kvalo@kernel.org>
Date:   Mon, 12 Sep 2022 11:26:26 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:

> Some users have reported being unable to connect to MT76x0 APs running mt76
> after a commit enabling the VHT extneded NSS BW feature.
> Fix this regression by ensuring that this feature only gets enabled on drivers
> that support it
> 
> Cc: stable@vger.kernel.org
> Fixes: d9fcfc1424aa ("mt76: enable the VHT extended NSS BW feature")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless.git, thanks.

781b80f452fc wifi: mt76: fix 5 GHz connection regression on mt76x0/mt76x2

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220907095228.82072-1-nbd@nbd.name/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

