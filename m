Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A9DC001DF
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Aug 2023 14:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbjHAOtX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Aug 2023 10:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbjHAOtW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2023 10:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC2B1BD2
        for <linux-wireless@vger.kernel.org>; Tue,  1 Aug 2023 07:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57EDF615D3
        for <linux-wireless@vger.kernel.org>; Tue,  1 Aug 2023 14:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0811C433C8;
        Tue,  1 Aug 2023 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690901360;
        bh=TmcQzokzbfNlGwb1PRHI0/vw8eFP4tWvB0kA6dJSBhw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IIKYWHNV1VSATB9TIUkUdgf2mS3QGjsIIjbifuLkem3eDKBD0C6I0oqgoCzAAXrcq
         CWFQGP3sQhZc3xObtlwH1jH53/qk9IwEK8xOZJKjV+hJ9991VBiuQEuwyU7OHKRIvQ
         kEunAykfxIh2FuYOXppouW4GhBSvHFeWefkfBjl0BGgGo1fEB4Gwcy+gQv03LiDZr2
         l1+b/Qn6aQMN0e3MRoCSUxJimuVmjAUVXWZ/Js24rNaxDatblzpQuTvTf63tmvjBII
         zMRxj+1WryjjjTlXgnunVdHTTazf2UTfOEytqki/cmPVUEMVMCgABLvszgvTABLgEu
         O2ykfU3bRTgZQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/6] [v2] wifi: libertas: add missing calls to
 cancel_work_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230725060531.72968-1-dmantipov@yandex.ru>
References: <20230725060531.72968-1-dmantipov@yandex.ru>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
        lvc-project@linuxtesting.org, Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169090135787.212423.3155582035319329087.kvalo@kernel.org>
Date:   Tue,  1 Aug 2023 14:49:19 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> wrote:

> Add missing 'cancel_work_sync()' in 'if_sdio_remove()'
> and on error handling path in 'if_sdio_probe()'.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> Tested-by: Dan Williams <dcbw@redhat.com>

6 patches applied to wireless-next.git, thanks.

c1861ff1d63d wifi: libertas: add missing calls to cancel_work_sync()
ce44fdf9c9d2 wifi: libertas: use convenient lists to manage SDIO packets
2c531d28f8e9 wifi: libertas: simplify list operations in free_if_spi_card()
6c968e90198f wifi: libertas: cleanup SDIO reset
3e14212f79fd wifi: libertas: handle possible spu_write_u16() errors
f5343efdf5b5 wifi: libertas: prefer kstrtoX() for simple integer conversions

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230725060531.72968-1-dmantipov@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

