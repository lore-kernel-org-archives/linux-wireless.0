Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:60051 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZHJS4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 14:56:07 -0400
Date: Mon, 10 Aug 2009 20:56:07 +0200
Message-Id: <1758026153@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Carpenter <error27@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2.6.31] ar9170: fix read & write outside array bounds
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> wrote:
> On Sun, Aug 09, 2009 at 02:24:09PM +0200, Christian Lamparter wrote:
> > From: Dan Carpenter <error27@gmail.com>
> > 
> > queue == __AR9170_NUM_TXQ would cause a bug on the next line.
> > 
> > found by Smatch ( http://repo.or.cz/w/smatch.git ).
> > 
> > Cc: stable@kernel.org
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > ---
> > diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> > index 4fc389a..ea8c941 100644
> > --- a/drivers/net/wireless/ath/ar9170/main.c
> > +++ b/drivers/net/wireless/ath/ar9170/main.c
> > @@ -2458,13 +2458,14 @@ static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
> >  	int ret;
> >  
> >  	mutex_lock(&ar->mutex);
> > -	if ((param) && !(queue > __AR9170_NUM_TXQ)) {
> > +	if (queue < __AR9170_NUM_TXQ) {
> >  		memcpy(&ar->edcf[ar9170_qos_hwmap[queue]],
> >  		       param, sizeof(*param));
> >  
> >  		ret = ar9170_set_qos(ar);
> > -	} else
> > +	} else {
> >  		ret = -EINVAL;
> > +	}
> >  
> >  	mutex_unlock(&ar->mutex);
> >  	return ret;
> 
> The p54 version of this patch used hw->queues instead of a constant.
> Wouldn't that be better here?
Depends...

Other drivers like ath9k/iwlwifi use a constant _check_ as well.
Having constants is always a plus for AOT compilers.

The reason why p54 does this differently and uses a variable
here, is simply because  the number of queues depends on
the firmware revision. Users - with the old, original windows
driver firmwares - have experienced serve stability problems
with QoS enabled.

Regards,
       Chr

________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

