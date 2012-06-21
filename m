Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59761 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2FUSnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:43:00 -0400
Message-ID: <4FE36B2D.4000407@candelatech.com> (sfid-20120621_204304_637791_19984CDB)
Date: Thu, 21 Jun 2012 11:42:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath9k: fix 'side effect in macro' smatch warning
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com> <1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1340303492-30947-4-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2012 11:31 AM, Rajkumar Manoharan wrote:
> ath9k_get_et_stats() warn: side effect in macro
> 'AWDATA' doing 'i++'
>
> Cc: Ben Greear<greearb@candelatech.com>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/main.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 85f9ab4..32474b0 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -2003,10 +2003,11 @@ static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
>   #define PR_QNUM(_n) (sc->tx.txq_map[_n]->axq_qnum)
>   #define AWDATA(elem)							\
>   	do {								\
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> -		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> +		data[i+0] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
> +		data[i+1] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
> +		data[i+2] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
> +		data[i+3] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
> +		i += 4; \
>   	} while (0)

The macro is still changing i.  So, whatever smatch is, seems it
should still warn, or it's broken :P

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

