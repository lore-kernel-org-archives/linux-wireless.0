Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC13C433FE
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Apr 2022 15:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbiDFPOi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Apr 2022 11:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbiDFPOU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Apr 2022 11:14:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E22163557C;
        Wed,  6 Apr 2022 05:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2351F61A3E;
        Wed,  6 Apr 2022 12:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B37C385B2;
        Wed,  6 Apr 2022 12:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649247293;
        bh=QSlo+VJNovr4VoLpiSbiM+XDM/hycOOPvzYC9iV7eyc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XURuD0d/JRDUQCDejgT53UdP1HXPuSU/EQ+CAZVtuNr+TLiQaWeuDte7SkRWtrboB
         g02bzFYk8z/SUWh+qNtMIpDFz2K6jvU3Rf05q9i3h6BFfA5pQT2Xh/S1AHDrPb2NxB
         Ri3oloUX6wHbdguXtW4zkhXnJpi07czbKNx7M9WNjsvgBjELoEEwpVoIXg2hEwxQIQ
         Bou1jAfocBEGzIORPAD1yIPi0mdLEawDYafJMJahK9F6SnNqzOrkBqykpaRkRuYmP4
         gkqWrUTgseiuD1Imbd9Ud1FEHxmt1a+8hye8EUot/TlK3lk7oVlSKMxjqAGsB48YVz
         kfxf8rOf2AoDg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2x00: Fix potential NULL dereference in libipw_xmit()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1648797055-25730-1-git-send-email-baihaowen@meizu.com>
References: <1648797055-25730-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowen Bai <baihaowen@meizu.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924728954.19026.2659969788331477081.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 12:14:51 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Haowen Bai <baihaowen@meizu.com> wrote:

> crypt and crypt->ops could be null, so we need to checking null
> before dereference
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>

Patch applied to wireless-next.git, thanks.

e8366bbabe1d ipw2x00: Fix potential NULL dereference in libipw_xmit()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1648797055-25730-1-git-send-email-baihaowen@meizu.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

