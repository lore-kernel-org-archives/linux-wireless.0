Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbeB0QqO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:46:14 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath5k: remove duplicated re-assignment to pointer 'tq'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180201180327.23435-1-colin.king@canonical.com>
References: <20180201180327.23435-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R . Rodriguez" <mcgrof@do-not-panic.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180227164614.323FE60285@smtp.codeaurora.org> (sfid-20180227_174632_991626_FCE62ED0)
Date: Tue, 27 Feb 2018 16:46:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> Pointer tq is initialized with &ah->ah_txq[queue] and then a few
> lines later is re-assigned the same value, hence this duplicate
> assignment is redundant and can be removed.
> 
> Cleans up clang warning:
> drivers/net/wireless/ath/ath5k/qcu.c:326:25: warning: Value stored
> to 'tq' during its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

2571c081cb43 ath5k: remove duplicated re-assignment to pointer 'tq'

-- 
https://patchwork.kernel.org/patch/10195805/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
