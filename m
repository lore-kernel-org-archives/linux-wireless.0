Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:63954 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbeHWOCZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 10:02:25 -0400
Date: Thu, 23 Aug 2018 16:03:15 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH 20/24] staging: wilc1000: avoid line over 80 chars in
 tcp_process()
Message-ID: <20180823160315.168c49e5@ajaysk-VirtualBox> (sfid-20180823_123324_475922_6D0BB6AE)
In-Reply-To: <c8362c8b-acb3-d5c3-8d47-be18424b8a1e@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-21-git-send-email-ajay.kathat@microchip.com>
        <c8362c8b-acb3-d5c3-8d47-be18424b8a1e@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 23 Aug 2018 11:12:08 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 14.08.2018 09:50, Ajay Singh wrote:
> > Cleanup patch to avoid line over 80 chars issue reported by
> > checkpatch.pl script.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/wilc_wlan.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> > b/drivers/staging/wilc1000/wilc_wlan.c index 041c9dd..f0743d9 100644
> > --- a/drivers/staging/wilc1000/wilc_wlan.c
> > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > @@ -137,6 +137,11 @@ static inline int add_tcp_pending_ack(struct
> > wilc_vif *vif, u32 ack, return 0;
> >  }
> >  
> > +static inline void clear_tcp_session_txq(struct wilc_vif *vif, int
> > index) +{
> > +	vif->ack_filter.pending_acks_info[index].txqe = NULL;
> > +}
> > +  
> 
> This seems useless to me...

Sorry, this point is not fully clear to me.

Did you mean setting of 'NULL' to 'pending_acks_info[index].txqe' is
not required?


> 
> >  static inline void tcp_process(struct net_device *dev, struct
> > txq_entry_t *tqe) {
> >  	void *buffer = tqe->buffer;
> > @@ -670,7 +675,7 @@ int wilc_wlan_handle_txq(struct net_device
> > *dev, u32 *txq_count) tqe->tx_complete_func(tqe->priv, tqe->status);
> >  		if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK &&
> >  		    tqe->tcp_pending_ack_idx < MAX_PENDING_ACKS)
> > -
> > vif->ack_filter.pending_acks_info[tqe->tcp_pending_ack_idx].txqe =
> > NULL;
> > +			clear_tcp_session_txq(vif,
> > tqe->tcp_pending_ack_idx); kfree(tqe);
> >  	} while (--entries);
> >  
> >   
