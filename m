Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28301 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaJHKqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:46:50 -0400
Date: Wed, 8 Oct 2014 16:18:25 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: fix kernel panic while shutting down AP
Message-ID: <20141008104823.GB25666@qca.qualcomm.com> (sfid-20141008_124656_915442_0CFB939B)
References: <1412759786-10567-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87a956hosb.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87a956hosb.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 12:52:04PM +0300, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > The commit "ath10k: workaround fw beaconing bug" is freeing
> > DMA-coherent memory in irq context which is hitting BUG ON
> > in ARM platforms. Fix this by moving dma_free out of spin
> > lock.
 
> [...]
> 
> > @@ -2404,8 +2389,15 @@ void ath10k_halt(struct ath10k *ar)
> >  
> >  	spin_lock_bh(&ar->data_lock);
> >  	list_for_each_entry(arvif, &ar->arvifs, list)
> > -		ath10k_mac_vif_beacon_cleanup(arvif);
> > +		ath10k_mac_vif_beacon_free(arvif);
> >  	spin_unlock_bh(&ar->data_lock);
> > +	list_for_each_entry(arvif, &ar->arvifs, list) {
> > +		if (!arvif->beacon_buf)
> > +			continue;
> > +		dma_free_coherent(ar->dev, IEEE80211_MAX_FRAME_LEN,
> > +				  arvif->beacon_buf, arvif->beacon_paddr);
> > +		arvif->beacon_buf = NULL;
> > +	}
> >  }
> 
> Until now we have protected arvif->beacon_buf with data_lock. How do we
> know that this is safe to do without taking data_lock?
> 
As said, spin_lock can not be used for dma_free_coherent.
arvif->beacon_buf is already protected by conf_mutex. At this state
in ath10k_halt path, no one can access beacon_buf. So mutex lock itself
is sufficient.

-Rajkumar
