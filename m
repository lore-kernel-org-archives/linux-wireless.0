Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D87FEE4993
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Aug 2023 16:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbjHUQKf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Aug 2023 12:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjHUQKe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2023 12:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F9BFA;
        Mon, 21 Aug 2023 09:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0672763CFA;
        Mon, 21 Aug 2023 16:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5198C433C7;
        Mon, 21 Aug 2023 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692634220;
        bh=j1YPIsTdbsf0lmArJKt2cdkeFhMJztdIoqNq9bY/8bo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TJNLBFXO8X1hbuC9YV1EFSWfxthl92bm8kScXAZXWWBqkBe5pvZqB9GVuqqEGA2f+
         QCxeZvUBeWGwMv1zcy/pqfUggEYl6/tnzbmH1uWAURlL9eiqi0UXdTJhICjxVndXnF
         7cT1tMLU20vuqSZELQTWpT/jUjIBAfEks5EjgcO5CL5OaiSBw5q+cZkmiQmstcWYyS
         mY6wCzqV3fwzu6BxWi9nYC3FYo76s7BvzVdvyvDkn5SETdacHLZ0a9GIHpP6edps0u
         KjlLwBLxxMnOkxeRDWClAqlOIvhsWGOmLMNRLbCvStEPfo/JGeDp+l9r75YOAhOzd0
         VjnX41W4yDgXQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: ipw2x00: refactor to use kstrtoul
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230802-wifi-ipw2x00-refactor-v2-1-d33f765e9cd5@google.com>
References: <20230802-wifi-ipw2x00-refactor-v2-1-d33f765e9cd5@google.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Justin Stitt <justinstitt@google.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169263421674.572263.16005174999269308938.kvalo@kernel.org>
Date:   Mon, 21 Aug 2023 16:10:18 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Justin Stitt <justinstitt@google.com> wrote:

> The current implementation seems to reinvent what `kstrtoul` already does
> in terms of functionality and error handling. Remove uses of `simple_strtoul()`
> in favor of `kstrtoul()`.
> 
> There is the following note at `lib/vsprintf.c:simple_strtoull()` which
> further backs this change:
> | * This function has caveats. Please use kstrtoull (or kstrtoul) instead.
> 
> And here, simple_str* are explicitly deprecated [3].
> 
> This patch also removes an instance of the deprecated `strncpy` which helps [2].
> 
> Compile tested only.
> 
> Link: https://lore.kernel.org/all/202308011602.3CC1C0244C@keescook/ [1]
> Link: https://github.com/KSPP/linux/issues/90 [2]
> Link: https://docs.kernel.org/process/deprecated.html#simple-strtol-simple-strtoll-simple-strtoul-simple-strtoull [3]
> Cc: linux-hardening@vger.kernel.org
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

876777494634 wifi: ipw2x00: refactor to use kstrtoul

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230802-wifi-ipw2x00-refactor-v2-1-d33f765e9cd5@google.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

