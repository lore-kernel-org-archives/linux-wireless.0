Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46795 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2LCPbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 10:31:43 -0500
Date: Mon, 3 Dec 2012 10:27:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Francisco Pina Martins <f.pinamartins@gmail.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] Revert: "rt2x00: Don't let mac80211 send a BAR when
 an AMPDU subframe fails"
Message-ID: <20121203152723.GB26027@tuxdriver.com> (sfid-20121203_163145_816891_54BD7E1F)
References: <20121203115632.GA2490@redhat.com>
 <20121203115903.GB2490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121203115903.GB2490@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes, maybe you should take this through the mac80211 tree,
since it depens on the other patch?

John

On Mon, Dec 03, 2012 at 12:59:04PM +0100, Stanislaw Gruszka wrote:
> This revert:
> 
> commit be03d4a45c09ee5100d3aaaedd087f19bc20d01f
> Author: Andreas Hartmann <andihartmann@01019freenet.de>
> Date:   Tue Apr 17 00:25:28 2012 +0200
> 
>     rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails
> 
> To fix problem workaround by above commit use
> IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL flag (see change log for
> "mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL" patch).
> 
> Resolve: https://bugzilla.kernel.org/show_bug.cgi?id=42828
> Bisected-by: Francisco Pina Martins <f.pinamartins@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 59474ae..175a9b9 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -5036,7 +5036,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	    IEEE80211_HW_SUPPORTS_PS |
>  	    IEEE80211_HW_PS_NULLFUNC_STACK |
>  	    IEEE80211_HW_AMPDU_AGGREGATION |
> -	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
> +	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> +	    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL;
>  
>  	/*
>  	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 69097d1..b0183d1 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -391,10 +391,9 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
>  		tx_info->status.ampdu_len = 1;
>  		tx_info->status.ampdu_ack_len = success ? 1 : 0;
> -		/*
> -		 * TODO: Need to tear down BA session here
> -		 * if not successful.
> -		 */
> +
> +		if (!success)
> +			tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
>  	}
>  
>  	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
