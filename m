Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:40347 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYJCOme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 10:42:34 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "Bob Copeland" <me@bobcopeland.com>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
References: <200808101401.03339.toralf.foerster@gmx.de>
	<200810012055.58085.toralf.foerster@gmx.de>
	<87ej30m376.fsf@denkblock.local>
	<b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	<87ljx8ndw1.fsf@denkblock.local>
	<b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
	<87od23mo08.fsf@denkblock.local>
	<b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	<20081002144600.M31352@bobcopeland.com>
	<87bpy32c1w.fsf@denkblock.local>
	<b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	<20081003134648.M45120@bobcopeland.com>
Date: Fri, 03 Oct 2008 16:42:17 +0200
In-Reply-To: <20081003134648.M45120@bobcopeland.com> (Bob Copeland's message
	of "Fri, 3 Oct 2008 10:13:33 -0400")
Message-ID: <87fxnd2112.fsf@denkblock.local> (sfid-20081003_164238_731501_2005205C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <me@bobcopeland.com> wrote:
> On Thu, 2 Oct 2008 14:37:17 -0400, Bob Copeland wrote
>> On Thu, Oct 2, 2008 at 12:31 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
>
>> > Sorry, but I don't think this is safe. Checking and restoring the
>> > started flag has to be protected too, otherwise there can be races
>> > against ->stop().
>> 
>> Yes, it's a bit of a mess.  Even if it were serialized, a ->stop()
>> happening between suspend's call to hw_stop and actually powering down
>> the device would clear the flag.  Ho hum.
>
> Okay, as usual I'm wrong here; it will clear the flag but we don't care
> since then we just wouldn't power up on resume.
>
> Since no one else chimed in, here's take two with more chewing gum and 
> baling wire to fix the suspend/stop race.
>
> ---
>  drivers/net/wireless/ath5k/base.c |   24 +++++++++++++++++-------
>  drivers/net/wireless/ath5k/base.h |    3 ++-
>  2 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index e09ed2c..7e8fa2e 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
[...]
> @@ -666,9 +666,12 @@ ath5k_pci_resume(struct pci_dev *pdev)
>  		goto err_no_irq;
>  	}
>  
> -	err = ath5k_init(sc);
> -	if (err)
> -		goto err_irq;
> +	if (test_bit(ATH_STAT_STARTED, sc->status)) {
> +		err = ath5k_init(sc);

I still feel uneasy about this. Granted, I haven't thought this through
too carefully, but I'd rather not rely on the fact that ath5k_stop_hw()
will not get called between the check for ATH_STAT_STARTED and the call
to ath5k_init if I can help it. Perhaps you can add an argument `reinit'
to ath5k_init() and do something like this under the mutex:

	if (reinit && !test_bit(ATH_STAT_STARTED, sc->status)) {
		mutex_unlock(...);
		return;
	}

Regards,

Elias
