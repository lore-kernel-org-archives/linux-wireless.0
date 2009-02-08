Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752915AbZBHU3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 15:29:49 -0500
Date: Sun, 8 Feb 2009 12:25:27 -0800
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] mac80211: avoid possible buffer overrun in
	sta_agg_status_write
Message-ID: <20090208202527.GD17043@kroah.com> (sfid-20090208_212956_204439_E684751A)
References: <1226089619-726-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1226089619-726-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


John, the patch below seems to have David Miller's ack that he applied
it to a tree back in November, but I don't see it in Linus's tree
anywhere.  Did something happen to it?

confused,

greg k-h

On Fri, Nov 07, 2008 at 03:26:59PM -0500, John W. Linville wrote:
> This addresses the bug report here:
>=20
> 	http://bugzilla.kernel.org/show_bug.cgi?id=3D11975
>=20
> Reported-by: Daniel Marjam=E4ki <danielm77@spray.se>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: stable@kernel.org
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/debugfs_sta.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 189d0ba..2e6752a 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -184,7 +184,6 @@ static ssize_t sta_agg_status_write(struct file *=
file,
>  	char buf[32];
>  	int buf_size, rs;
>  	unsigned int tid_num;
> -	char state[4];
> =20
>  	memset(buf, 0x00, sizeof(buf));
>  	buf_size =3D min(count, (sizeof(buf)-1));
> @@ -199,35 +198,31 @@ static ssize_t sta_agg_status_write(struct file=
 *file,
>  		/* toggle Rx aggregation command */
>  		tid_num =3D tid_num - 100;
>  		if (tid_static_rx[tid_num] =3D=3D 1) {
> -			strcpy(state, "off ");
>  			ieee80211_sta_stop_rx_ba_session(sta->sdata, da, tid_num, 0,
>  					WLAN_REASON_QSTA_REQUIRE_SETUP);
>  			sta->ampdu_mlme.tid_state_rx[tid_num] |=3D
>  					HT_AGG_STATE_DEBUGFS_CTL;
>  			tid_static_rx[tid_num] =3D 0;
>  		} else {
> -			strcpy(state, "on ");
>  			sta->ampdu_mlme.tid_state_rx[tid_num] &=3D
>  					~HT_AGG_STATE_DEBUGFS_CTL;
>  			tid_static_rx[tid_num] =3D 1;
>  		}
>  		printk(KERN_DEBUG "debugfs - try switching tid %u %s\n",
> -				tid_num, state);
> +				tid_num, tid_static_rx[tid_num] ? "on" : "off");
>  	} else if ((tid_num >=3D 0) && (tid_num <=3D 15)) {
>  		/* toggle Tx aggregation command */
>  		if (tid_static_tx[tid_num] =3D=3D 0) {
> -			strcpy(state, "on ");
>  			rs =3D  ieee80211_start_tx_ba_session(hw, da, tid_num);
>  			if (rs =3D=3D 0)
>  				tid_static_tx[tid_num] =3D 1;
>  		} else {
> -			strcpy(state, "off");
>  			rs =3D  ieee80211_stop_tx_ba_session(hw, da, tid_num, 1);
>  			if (rs =3D=3D 0)
>  				tid_static_tx[tid_num] =3D 0;
>  		}
>  		printk(KERN_DEBUG "debugfs - switching tid %u %s, return=3D%d\n",
> -				tid_num, state, rs);
> +				tid_num, tid_static_tx[tid_num] ? "on" : "off", rs);
>  	}
> =20
>  	return count;
> --=20
> 1.5.4.3
>=20
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
