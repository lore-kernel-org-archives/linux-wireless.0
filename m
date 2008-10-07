Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:54269 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYJGUsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 16:48:36 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
References: <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	<20081002144600.M31352@bobcopeland.com>
	<87bpy32c1w.fsf@denkblock.local>
	<b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	<20081003134648.M45120@bobcopeland.com>
	<87fxnd2112.fsf@denkblock.local>
	<20081003193739.M19356@bobcopeland.com>
	<877i8nky65.fsf@denkblock.local> <20081007013529.GA9691@hash.localnet>
	<873aj8vg45.fsf@denkblock.local>
	<20081007125742.GA10693@hash.localnet>
Date: Tue, 07 Oct 2008 22:48:17 +0200
In-Reply-To: <20081007125742.GA10693@hash.localnet> (Bob Copeland's message of
	"Tue, 7 Oct 2008 08:57:42 -0400")
Message-ID: <87prmct9m6.fsf@denkblock.local> (sfid-20081007_224839_252518_B436C702)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Oct 07, 2008 at 12:44:58PM +0200, Elias Oltmanns wrote:
>> Bob Copeland <me@bobcopeland.com> wrote:
>> > -ath5k_stop_hw(struct ath5k_softc *sc)
>> > +ath5k_stop_hw(struct ath5k_softc *sc, bool update_status)
>
> Now with more git-add action...
>
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
> index c151588..ae1c152 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
[...]
> @@ -2280,6 +2289,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
>  	}
>  	ath5k_txbuf_free(sc, sc->bbuf);
>  	mmiowb();
> +
> +	if (!is_suspend)
> +		__clear_bit(ATH_STAT_STARTED, sc->status);
>  	mutex_unlock(&sc->lock);

Personally, I'd prefer keeping the memory barrier right next to the
mutex_unlock(), i.e.

 	ath5k_txbuf_free(sc, sc->bbuf);
+	if (!is_suspend)
+		__clear_bit(ATH_STAT_STARTED, sc->status);
+
 	mmiowb();
 	mutex_unlock(&sc->lock);

even though this is purely a matter of style in this particular case.
Otherwise:

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
