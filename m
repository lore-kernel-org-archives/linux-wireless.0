Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34978 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab0IUHZQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 03:25:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 00:25:09 -0700
Date: Tue, 21 Sep 2010 12:56:35 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Fix beacon distribution in IBSS mode
Message-ID: <20100921072634.GA6675@vmraj-lnx.users.atheros.com>
References: <1284985872-31021-1-git-send-email-rmanoharan@atheros.com>
 <4C9756CE.1060908@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C9756CE.1060908@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 20, 2010 at 06:12:54PM +0530, Felix Fietkau wrote:
> On 2010-09-20 2:31 PM, Rajkumar Manoharan wrote:
> > This patch ensures fair beacon distribution in IBSS mode
> > by configuring proper CWmin based on slot time.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    9 +++++-
> >  drivers/net/wireless/ath/ath9k/hw.c             |   32 +++++++++++++++++++++++
> >  drivers/net/wireless/ath/ath9k/hw.h             |    1 +
> >  3 files changed, 41 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> > index bd1506e..3e699a5 100644
> > --- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> > +++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
> > @@ -235,7 +235,14 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
> >  	ath9k_hw_get_txq_props(ah, qnum, &qi_be);
> >  
> >  	qi.tqi_aifs = qi_be.tqi_aifs;
> > -	qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
> > +	/* For WIFI Beacon Distribution
> > +	 * Long slot time  : 2x cwmin
> > +	 * Short slot time : 4x cwmin
> > +	 */
> > +	if (ath9k_hw_getslottime(ah) == ATH9K_SLOT_TIME_20)
> I'd recommend using ah->slottime here and dropping all of those ath9k_hw
> changes.
> 
> - Felix
Yep. I am sending the updated patch. Thanks for your review Felix. :)

- Rajkumar
