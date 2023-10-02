Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28ABE743C3
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Oct 2023 16:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbjJBQCz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Oct 2023 12:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238083AbjJBQCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2023 12:02:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DED18E
        for <linux-wireless@vger.kernel.org>; Mon,  2 Oct 2023 09:02:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE3AC433C7;
        Mon,  2 Oct 2023 16:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696262571;
        bh=HuxJiuznms2W8lxP6HRykHp7BYb4KNtNZEOr+LscHgU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FL06NhOIuzHuu2zLbQ7BQ99cT9nnu8JCzArSJXRp/urU0or7BIpSD7A10PWo+UzN9
         EgwVhhCznoSyOUMlYpqg6QrlvNw0cPAdc/bLBCUAOhNMa/TC+sMEd4b3AHBODkF8IP
         zF+u4fVAsdoMndA4mPgPJZ3wyQuj1y4CBxNvLkrV1+b0nmIVgVZ4yUschuZfzbMgvk
         7ASI667rRPmexnoR7a4I8oPluTmjZwMe0qCpWbw4M3XTChBJlyyR78WulMG9jNNQN6
         7b/nrXyWoCAgJyiGI/dCg/IUQjK575q/CuJdjbJGg3W92YkRlgiihe4+frQeFmjXbH
         6ELVN8G6sYhcQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath12k: mhi: fix potential memory leak in
 ath12k_mhi_register()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230922021036.3604157-1-make_ruc2021@163.com>
References: <20230922021036.3604157-1-make_ruc2021@163.com>
To:     Ma Ke <make_ruc2021@163.com>
Cc:     quic_jjohnson@quicinc.com, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, Ma Ke <make_ruc2021@163.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169626256833.3917291.8799520274083808418.kvalo@kernel.org>
Date:   Mon,  2 Oct 2023 16:02:50 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ma Ke <make_ruc2021@163.com> wrote:

> mhi_alloc_controller() allocates a memory space for mhi_ctrl. When some
> errors occur, mhi_ctrl should be freed by mhi_free_controller() and set
> ab_pci->mhi_ctrl = NULL.
> 
> We can fix it by calling mhi_free_controller() when the failure happens
> and set ab_pci->mhi_ctrl = NULL in all of the places where we call
> mhi_free_controller().
> 
> Signed-off-by: Ma Ke <make_ruc2021@163.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

47c27aa7ded4 wifi: ath12k: mhi: fix potential memory leak in ath12k_mhi_register()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230922021036.3604157-1-make_ruc2021@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

