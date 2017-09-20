Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48556 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdITMlZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:41:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] b43: fix unitialized reads of ret by initializing the array
 to zero
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170905181550.23839-1-colin.king@canonical.com>
References: <20170905181550.23839-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170920124124.7B32460725@smtp.codeaurora.org> (sfid-20170920_144141_986971_2951D13F)
Date: Wed, 20 Sep 2017 12:41:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The u8 char array ret is not being initialized and elements outside
> the range start to end contain just garbage values from the stack.
> This results in a later scan of the array to read potentially
> uninitialized values.  Fix this by initializing the array to zero.
> This seems to have been an issue since the very first commit.
> 
> Detected by CoverityScan CID#139652 ("Uninitialized scalar variable")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Michael Buesch <m@bues.ch>

2 patches applied to wireless-drivers-next.git, thanks.

e31fbe1034d9 b43: fix unitialized reads of ret by initializing the array to zero
e3ae1c772046 b43legacy: fix unitialized reads of ret by initializing the array to zero

-- 
https://patchwork.kernel.org/patch/9939435/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
