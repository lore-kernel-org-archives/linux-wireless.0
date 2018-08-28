Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2292 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1ISx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 04:18:53 -0400
Date: Tue, 28 Aug 2018 09:59:00 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        <devel@driverdev.osuosl.org>, <venkateswara.kaja@microchip.com>,
        <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 20/24] staging: wilc1000: avoid line over 80 chars in
 tcp_process()
Message-ID: <20180828095900.0b90724a@ajaysk-VirtualBox> (sfid-20180828_063246_621121_08EC2DF6)
In-Reply-To: <20180827120050.mrzhtrstrg7or2to@mwanda>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
        <1534229416-13254-21-git-send-email-ajay.kathat@microchip.com>
        <c8362c8b-acb3-d5c3-8d47-be18424b8a1e@microchip.com>
        <20180823160315.168c49e5@ajaysk-VirtualBox>
        <5e649eea-db3a-a8fd-a15b-ad253d1de118@microchip.com>
        <20180827105438.5443cdfa@ajaysk-VirtualBox>
        <20180827120050.mrzhtrstrg7or2to@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Mon, 27 Aug 2018 15:00:50 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Mon, Aug 27, 2018 at 10:54:38AM +0530, Ajay Singh wrote:
> > Hi Claudiu,
> > 
> > On Fri, 24 Aug 2018 12:31:28 +0300
> > Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> >   
> > > On 23.08.2018 13:33, Ajay Singh wrote:  
> > > > On Thu, 23 Aug 2018 11:12:08 +0300
> > > > Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:
> > > >     
> > > >> On 14.08.2018 09:50, Ajay Singh wrote:    
> > > >>> Cleanup patch to avoid line over 80 chars issue reported by
> > > >>> checkpatch.pl script.
> > > >>>
> > > >>> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > > >>> ---
> > > >>>  drivers/staging/wilc1000/wilc_wlan.c | 7 ++++++-
> > > >>>  1 file changed, 6 insertions(+), 1 deletion(-)
> > > >>>
> > > >>> diff --git a/drivers/staging/wilc1000/wilc_wlan.c
> > > >>> b/drivers/staging/wilc1000/wilc_wlan.c index 041c9dd..f0743d9
> > > >>> 100644 --- a/drivers/staging/wilc1000/wilc_wlan.c
> > > >>> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > > >>> @@ -137,6 +137,11 @@ static inline int
> > > >>> add_tcp_pending_ack(struct wilc_vif *vif, u32 ack, return 0;
> > > >>>  }
> > > >>>  
> > > >>> +static inline void clear_tcp_session_txq(struct wilc_vif
> > > >>> *vif, int index) +{
> > > >>> +	vif->ack_filter.pending_acks_info[index].txqe = NULL;
> > > >>> +}
> > > >>> +      
> > > >>
> > > >> This seems useless to me...    
> > > > 
> > > > Sorry, this point is not fully clear to me.
> > > > 
> > > > Did you mean setting of 'NULL' to
> > > > 'pending_acks_info[index].txqe' is not required?
> > > >     
> > > 
> > > No, having a new function that sets a variable just to avoid line
> > > over 80 warning.  
> > 
> > Okay got it.
> > How about using a temp variable to hold the value of
> > 'tqe->tcp_pending_ack_idx'. It can also help to overcome the
> > checkpatch warning.  
> 
> Just ignore the checkpatch warning...  Don't add a temporary variable
> just to please checkpatch...  It's good to fix checkpatch warnings if
> it makes the code cleaner, but I hate when people do:
> 
> 	tmp = some_long_variable_name;
> 	some_other_long_variable = tmp;
> 
> The tmp variable is only used one time and a simple statement becomes
> two statements and it breaks grep.
> 
> You could consider renaming some of the variables.  I think the
> "_info" doesn't add anything, because obviously it's information.
> Maybe "tcp_pending_ack_index" could just become "->ack_idx".

Thanks for providing the inputs. 
I will include the changes by using shorter name for
'tcp_pending_ack_index' in next version.

Regards,
Ajay
