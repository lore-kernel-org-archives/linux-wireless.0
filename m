Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55596C0015E
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Jun 2023 07:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245139AbjFOHrE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Jun 2023 03:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245137AbjFOHq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2023 03:46:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1323910E9;
        Thu, 15 Jun 2023 00:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0D8608D5;
        Thu, 15 Jun 2023 07:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB15C433C0;
        Thu, 15 Jun 2023 07:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686815212;
        bh=IYlGV4RSFt1d+yJKhbAG5tqp/00HgK+xkhxKb186tE0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=u1V90meL+tFm5DgrOOqjff/GVRY8lAfJVHrtgcGEo5XQtqy/ZCHtQOYyWPE63jiuJ
         9CNXltDmqldmCvhlH5x6+RmrMm6dDN7MLsKmSj4/yBFdOjR1uM8zlaVYXkJK6t62Qy
         rjAslRDTddXv05RVMtLk3Zjx4o4mkKsifBNiu9F72ey5saEm2Nx+CdE0nFcualSGwy
         rRFKTGhSnG40ptlAcczJshlIfErMUeXwsAAhWTQsHac9wEQRSDl3yDmwZ8Mzo1zJDY
         ZznhnEYIjjq6lvQ+QyGW6AvgSzK1asOeDEaS09cYninfqEB4cN3VAqQ7gbu7vO92e4
         up/2YEOgDeIsg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: mt7601u: replace strlcpy() with strscpy()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230613003458.3538812-1-azeemshaikh38@gmail.com>
References: <20230613003458.3538812-1-azeemshaikh38@gmail.com>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-hardening@vger.kernel.org,
        Azeem Shaikh <azeemshaikh38@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168681520789.8111.6922167548842826655.kvalo@kernel.org>
Date:   Thu, 15 Jun 2023 07:46:49 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Azeem Shaikh <azeemshaikh38@gmail.com> wrote:

> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since DEV_ASSIGN is only used by
> TRACE macros and the return values are ignored.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

7edbd53a58a8 wifi: mt7601u: replace strlcpy() with strscpy()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230613003458.3538812-1-azeemshaikh38@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

