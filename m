Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24402 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaIWEVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 00:21:01 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	wil6210 <wil6210@qca.qualcomm.com>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH] ath: change logging functions to return void
References: <1411407334.2952.46.camel@joe-AO725>
Date: Tue, 23 Sep 2014 07:20:53 +0300
In-Reply-To: <1411407334.2952.46.camel@joe-AO725> (Joe Perches's message of
	"Mon, 22 Sep 2014 10:35:34 -0700")
Message-ID: <874mvzj7bu.fsf@kamboji.qca.qualcomm.com> (sfid-20140923_062128_338927_9077BF21)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> The return values are not used by callers of these functions
> so change the functions to return void.
>
> Other miscellanea:
>
> o add __printf verification to wil6210 logging functions
>   No format/argument mismatches found
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> This change is associated to a desire to eventually
> change printk to return void.
>
>  drivers/net/wireless/ath/ath10k/debug.c    | 18 +++++-------------
>  drivers/net/wireless/ath/ath10k/debug.h    |  6 +++---
>  drivers/net/wireless/ath/ath6kl/common.h   |  2 +-
>  drivers/net/wireless/ath/ath6kl/debug.c    | 28 ++++++++--------------------
>  drivers/net/wireless/ath/ath6kl/debug.h    | 13 ++++++-------

For ath6kl and ath10k:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

>  drivers/net/wireless/ath/wil6210/debug.c   | 14 ++++----------
>  drivers/net/wireless/ath/wil6210/wil6210.h |  7 +++++--
>  7 files changed, 32 insertions(+), 56 deletions(-)

John, as this patch also contains a wil6210 change how do you want to
handle this?

-- 
Kalle Valo
