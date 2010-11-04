Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:18354 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754775Ab0KDKFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 06:05:19 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0576755116
	for <linux-wireless@vger.kernel.org>; Thu,  4 Nov 2010 19:05:17 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Rajkumar Manoharan <rmanoharan@atheros.com>, lrodriguez@atheros.com
Subject: Re: [PATCH v2] ath9k_htc: Fix beacon distribution in IBSS mode
Date: Thu, 4 Nov 2010 19:05:26 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
References: <1285054089-6707-1-git-send-email-rmanoharan@atheros.com> <201009271018.42232.br1@einfach.org>
In-Reply-To: <201009271018.42232.br1@einfach.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201011041905.26464.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon September 27 2010 10:18:42 Bruno Randolf wrote:
> On Tue September 21 2010 16:28:09 Rajkumar Manoharan wrote:
> > This patch ensures fair beacon distribution in IBSS mode
> > by configuring proper CWmin based on slot time.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> > ---
> > 
> >  drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    9 ++++++++-
> >  1 files changed, 8 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> > b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c index bd1506e..1b72aa4
> > 100644
> > --- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> > +++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> > @@ -235,7 +235,14 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv
> > *priv) ath9k_hw_get_txq_props(ah, qnum, &qi_be);
> > 
> >  	qi.tqi_aifs = qi_be.tqi_aifs;
> > 
> > -	qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
> > +	/* For WIFI Beacon Distribution
> > +	 * Long slot time  : 2x cwmin
> > +	 * Short slot time : 4x cwmin
> > +	 */
> > +	if (ah->slottime == ATH9K_SLOT_TIME_20)
> > +		qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
> > +	else
> > +		qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
> > 
> >  	qi.tqi_cwmax = qi_be.tqi_cwmax;
> >  	
> >  	if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
> 
> i am wondering - how does this relate to what i read in IEEE802.11-2007:
> 
>    11.1.2.2 Beacon generation in an IBSS
> 
>    b) Calculate a random delay uniformly distributed in the range between
> zero and twice aCWmin × aSlotTime,
> 
> wouldn't that mean that cwmin for the beacon queue should be 0 and cwmax
> should be 2x cwmin * slot time?
> 
> if the beacon queue cwmin is higher than the best effort queue, it would
> mean that the best effort queue gets precedence over beacon transmissions.
> but we want beacons to get sent out in any case.
>
> also, what is the rationale behind using the best effort queue as a
> reference for cwmin/cwmax?

I'm following up my own message since I just stumbled across that paragraph, 
which IMHO would imply that the beacon queue should be based on AC_VO instead 
of AC_BE, if anything.

[9.2.4.2 HCF contention-based channel access (EDCA):
Management frames shall be sent using the access category AC_VO
without being restricted by admission control procedures. A QoS STA shall also 
send management frames using the access category AC_VO before associating with 
any BSS, even if there is no QoS facility available in that BSS.]

Also I still doubt that 4*qi_be.tqi_cwmin is correct concerning the standard 
paragraph which i quoted before. Did I miss something?

Bruno
