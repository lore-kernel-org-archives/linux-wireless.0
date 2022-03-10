Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CB9C433EF
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Mar 2022 16:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbiCJQTD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Mar 2022 11:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241454AbiCJQSf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Mar 2022 11:18:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBAD31517;
        Thu, 10 Mar 2022 08:17:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE68B61B6F;
        Thu, 10 Mar 2022 16:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E5AC340E8;
        Thu, 10 Mar 2022 16:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646929053;
        bh=LaOV0j/x9Amby2EM8lBbbXKfuM6QPKkp+ClgxYC4yjE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=uSz4+RoqLWE4eDp+meGyQRuG2Qvh3IIkMBHUVovWq9uWQrhIQUoInFQ0cH3c8+/zs
         a/aOL1GoJ9aQqasSwZYrBJUJY/QJC0FpwojUwv5eew7X8rhczh8+C3jyLo7mXd24yh
         WvoRWfqkYF8oQF4M+OpyUuKZOknKKwkERomYRhopc3HMQKVOA2yNxJQpTRiWPnhQ7+
         aVlRwrHLthrS492Y8sph8fJJbBRdLo0BHZthyh9KPbqbILSbX2JhNfuOA8BywcduDL
         yeJGxZkXclz7S9g8HhZuSaYA7OLgIGypQCjWK0q+qCNiEacpsObqK0p0OdQu09O4UK
         +JqRnpptgoEcA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: cw1200: use time_is_after_jiffies() instead of open coding it
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1646018060-61275-1-git-send-email-wangqing@vivo.com>
References: <1646018060-61275-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Qing <wangqing@vivo.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692904615.6056.11614692881749190170.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 16:17:31 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Qing Wang <wangqing@vivo.com> wrote:

> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Patch applied to wireless-next.git, thanks.

8cbc3d51b4ae cw1200: use time_is_after_jiffies() instead of open coding it

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1646018060-61275-1-git-send-email-wangqing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

