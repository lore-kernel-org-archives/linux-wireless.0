Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44212 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0DMUAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 16:00:13 -0400
Date: Tue, 13 Apr 2010 15:54:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 012/102] ath9k_hw: add a private callback for PLL
	control computation
Message-ID: <20100413195408.GC6722@tuxdriver.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com> <1270754858-26266-13-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1270754858-26266-13-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 08, 2010 at 03:26:08PM -0400, Luis R. Rodriguez wrote:
> The PLL control computation used to program the AR_RTC_PLL_CONTROL
> register varies between our harware so just add a private callback for it.
> AR9003 will use its own callback.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c |   55 +++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/ar9002_phy.c |   31 +++++++++++++
>  drivers/net/wireless/ath/ath9k/hw.c         |   64 +++------------------------
>  drivers/net/wireless/ath/ath9k/hw.h         |    4 ++
>  4 files changed, 97 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> index 4459d63..31ecea8 100644
> --- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
> @@ -961,6 +961,54 @@ static void ar5008_set_diversity(struct ath_hw *ah, bool value)

<snip>

drivers/net/wireless/ath/ath9k/ar5008_phy.c doesn't seem to exist...?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
