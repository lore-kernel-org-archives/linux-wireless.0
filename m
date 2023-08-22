Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C514DEE49A3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Aug 2023 13:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbjHVNiM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Aug 2023 09:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbjHVNiM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2023 09:38:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCA9CF8
        for <linux-wireless@vger.kernel.org>; Tue, 22 Aug 2023 06:38:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C91F1656FB
        for <linux-wireless@vger.kernel.org>; Tue, 22 Aug 2023 13:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25059C433C9;
        Tue, 22 Aug 2023 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692711487;
        bh=DSwAXQ3jWVOGiRaw2ZBAisLbcWtuySqLoO+GXRdcWBA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=czjPuNVsRHDgI61rGIHwfhVJ0O98yJWKinN/EXI1NqeBR0VflIG4+naXwG0w/mcbd
         SM8OQRLydPr8398SHhgTKISJHKDoD6tjExJdLK2VHHj+EOnnYZix00MymheemR/GJv
         edJF7uJ+FbxUNtZ3ULTLyqFKDE6yN/RZKdexTq9VUSDNobHzpedABRCTLecy9uiDSW
         E2KYrJlTuOKMuogU2BuvDqiA2IrkDTY7PKBfeDJMcrbesRiYrBrnY3U45uZxjOFaPc
         4hpE9I2bquu73ZNG7jdTUSWrQkiRuvf4LB6Xaq/gfb1YNB29u7js6ejR8ghxMmtmJZ
         53cvm4BfYQv/g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] wifi: ath9k: consistently use kstrtoX_from_user()
 functions
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230726185046.188225-1-dmantipov@yandex.ru>
References: <20230726185046.188225-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169271148442.680890.4701743094145598444.kvalo@kernel.org>
Date:   Tue, 22 Aug 2023 13:38:05 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Use 'kstrtoul_from_user()' and 'kstrtobool_from_user()'
> where appropriate and thus avoid some code duplication.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

8b804643f42d wifi: ath9k: consistently use kstrtoX_from_user() functions

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230726185046.188225-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

