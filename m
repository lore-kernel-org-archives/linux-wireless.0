Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54077 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762286AbcINRCH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 13:02:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [06/26] ath: constify local structures
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473599168-30561-7-git-send-email-Julia.Lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, joe@perches.com,
        kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160914170206.10A9B613FB@smtp.codeaurora.org> (sfid-20160914_190230_902502_1F40A214)
Date: Wed, 14 Sep 2016 17:02:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> For structure types defined in the same file or local header files, find
> top-level static structure declarations that have the following
> properties:
> 1. Never reassigned.
> 2. Address never taken
> 3. Not passed to a top-level macro call
> 4. No pointer or array-typed field passed to a function or stored in a
> variable.
> Declare structures having all of these properties as const.
> 
> Done using Coccinelle.
> Based on a suggestion by Joe Perches <joe@perches.com>.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks, 3 patches applied to wireless-drivers-next.git:

8136fd58ad60 ath: constify local structures
1dc80798a8ca iwlegacy: constify local structures
d86e64768859 rtlwifi: rtl818x: constify local structures

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9325363/
