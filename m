Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:43385 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYJGKpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 06:45:19 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
References: <b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	<87od23mo08.fsf@denkblock.local>
	<b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	<20081002144600.M31352@bobcopeland.com>
	<87bpy32c1w.fsf@denkblock.local>
	<b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	<20081003134648.M45120@bobcopeland.com>
	<87fxnd2112.fsf@denkblock.local>
	<20081003193739.M19356@bobcopeland.com>
	<877i8nky65.fsf@denkblock.local> <20081007013529.GA9691@hash.localnet>
Date: Tue, 07 Oct 2008 12:44:58 +0200
In-Reply-To: <20081007013529.GA9691@hash.localnet> (Bob Copeland's message of
	"Mon, 6 Oct 2008 21:35:29 -0400")
Message-ID: <873aj8vg45.fsf@denkblock.local> (sfid-20081007_124526_095834_75ECD75F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
[...]
> Subject: [PATCH] ath5k: correct hardware startup sequence in resume
>
> Based on a patch by Elias Oltmanns, we call ath5k_init in resume even
> if we didn't previously open the device.  Besides starting up the
> device unnecessarily, this also causes an oops on rmmod because
> mac80211 will not invoke ath5k_stop and softirqs are left running after
> the module has been unloaded.  Add a new state bit, ATH_STAT_STARTED,
> to indicate that we have been started up.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   28 ++++++++++++++++++++--------
>  drivers/net/wireless/ath5k/base.h |    3 ++-
>  2 files changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index c151588..5388de8 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
[...]
> @@ -2248,7 +2257,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
>   * stop is preempted).
>   */
>  static int
> -ath5k_stop_hw(struct ath5k_softc *sc)
> +ath5k_stop_hw(struct ath5k_softc *sc, bool update_status)
                                              ^^^^^^^^^^^^^
That should be is_suspend for the sake of consistency.

>  {
>  	int ret;
>  
> @@ -2280,6 +2289,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
>  	}
>  	ath5k_txbuf_free(sc, sc->bbuf);
>  	mmiowb();
> +
> +	if (update_status)
> +		__clear_bit(ATH_STAT_STARTED, sc->status);

This cannot possibly be right. The condition has to be

	if (!is_suspend)

>  	mutex_unlock(&sc->lock);
>  
>  	del_timer_sync(&sc->calib_tim);
> @@ -2676,12 +2688,12 @@ ath5k_reset_wake(struct ath5k_softc *sc)
>  
>  static int ath5k_start(struct ieee80211_hw *hw)
>  {
> -	return ath5k_init(hw->priv);
> +	return ath5k_init(hw->priv, false);
>  }
>  
>  static void ath5k_stop(struct ieee80211_hw *hw)
>  {
> -	ath5k_stop_hw(hw->priv);
> +	ath5k_stop_hw(hw->priv, false);
>  }
>  
>  static int ath5k_add_interface(struct ieee80211_hw *hw,

Looking through the code, I'm wondering about the atomicity requirements
of sc->status. In my opinion, __set_bit() is not permissible in various
places (including your use case). But since this is a problem that has
been around before, I will send a separate patch once yours has been
merged.

Regards,

Elias
