Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:51087 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728362AbeHWPr7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:47:59 -0400
Date: Thu, 23 Aug 2018 17:48:24 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH 19/24] staging: wilc1000: avoid line over 80 chars in
 wilc_wlan_txq_filter_dup_tcp_ack()
Message-ID: <20180823174824.546325ab@ajaysk-VirtualBox> (sfid-20180823_141842_486442_DE1EC211)
In-Reply-To: <fedc9184-964a-f051-c490-0fdd821cc580@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-20-git-send-email-ajay.kathat@microchip.com>
        <fedc9184-964a-f051-c490-0fdd821cc580@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 23 Aug 2018 11:11:28 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 14.08.2018 09:50, Ajay Singh wrote:
> > Cleanup patch to avoid line over 80 chars checkpatch issue
> > introduced in previous code refactor commit.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/wilc_wlan.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> > b/drivers/staging/wilc1000/wilc_wlan.c index 52402c3..041c9dd 100644
> > --- a/drivers/staging/wilc1000/wilc_wlan.c
> > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > @@ -199,19 +199,20 @@ static int
> > wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev) unsigned
> > long flags; 
> >  	spin_lock_irqsave(&wilc->txq_spinlock, flags);
> > -	for (i = f->pending_base; i < (f->pending_base +
> > f->pending_acks); i++) {
> > -		u32 session_index;
> > +	i = f->pending_base;  
> You could do it like this to avoid line over 80 chars checkpatch.pl
> warnings:
> 
> 	for (i = f->pending_base;
> 	     i < (f->pending_base + f->pending_acks); i++) {
> 

Actually, I was not fully sure about the best approach to
handle this. :)

If the suggested is preferred approach our the over
previous one. I will include the suggestion and submit the updated
patch.


> > +	for (; i < (f->pending_base + f->pending_acks); i++) {
> > +		u32 index;
> >  		u32 bigger_ack_num;
> >  
> >  		if (i >= MAX_PENDING_ACKS)
> >  			break;
> >  
> > -		session_index =
> > f->pending_acks_info[i].session_index;
> > +		index = f->pending_acks_info[i].session_index;
> >  
> > -		if (session_index >= 2 * MAX_TCP_SESSION)
> > +		if (index >= 2 * MAX_TCP_SESSION)
> >  			break;
> >  
> > -		bigger_ack_num =
> > f->ack_session_info[session_index].bigger_ack_num;
> > +		bigger_ack_num =
> > f->ack_session_info[index].bigger_ack_num; 
> >  		if (f->pending_acks_info[i].ack_num <
> > bigger_ack_num) { struct txq_entry_t *tqe;
> >   
