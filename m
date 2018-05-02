Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:21887 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbeEBFrs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 01:47:48 -0400
Date: Wed, 2 May 2018 11:17:35 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@driverdev.osuosl.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Ganesh Krishna" <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: wilc1000: fix infinite loop and out-of-bounds
 access
Message-ID: <20180502111735.5a2c6faa@ajaysk-VirtualBox> (sfid-20180502_074804_269819_6A4C2E75)
In-Reply-To: <20180430152321.7pq4ol2ed7tzsrl4@mwanda>
References: <20180430125040.GA19050@embeddedor.com>
        <20180430195916.596a93eb@ajaysk-VirtualBox>
        <20180430152321.7pq4ol2ed7tzsrl4@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Apr 2018 18:23:21 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Mon, Apr 30, 2018 at 07:59:16PM +0530, Ajay Singh wrote:
> > Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>
> > 
> > On Mon, 30 Apr 2018 07:50:40 -0500
> > "Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:
> >   
> > > If i < slot_id is initially true then it will remain true. Also,
> > > as i is being decremented it will end up accessing memory out of
> > > bounds.
> > > 
> > > Fix this by incrementing *i* instead of decrementing it.  
> > 
> > Nice catch!
> > Thanks for submitting the changes.
> >   
> > > 
> > > Addresses-Coverity-ID: 1468454 ("Infinite loop")
> > > Fixes: faa657641081 ("staging: wilc1000: refactor scan() to free
> > > kmalloc memory on failure cases")
> > > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > > ---
> > > 
> > > BTW... at first sight it seems to me that variables slot_id
> > > and i should be of type unsigned instead of signed.  
> > 
> > Yes, 'slot_id' & 'i' can be changed to unsigned int.
> >   
> 
> A lot of people think making things unsigned improves the code but I
> hate "unsigned int i"...  I understand that in certain cases we do
> loop more than INT_MAX but those are a tiny tiny minority of loops.
> 
> Simple types like "int" are more readable than complicated types
> like "unsigned int".  Unsigned int just draws attention to itself
> and distracts people from things that might potentially matter.  We
> have real life subtle loops like in xtea_encrypt() where we need to
> use unsigned types.
> 
> And look at the function we're talking about here:
> 
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>    577  static inline int
>    578  wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request
> *request, 579                               struct hidden_network
> *ntwk) 580  {
>    581          int i;
>    582          int slot_id = 0;
>    583  
>    584          ntwk->net_info = kcalloc(request->n_ssids,
>    585                                   sizeof(struct
> hidden_network), GFP_KERNEL); 586          if (!ntwk->net_info)
>    587                  goto out;
>    588  
>    589          ntwk->n_ssids = request->n_ssids;
>    590  
>    591          for (i = 0; i < request->n_ssids; i++) {
> 
> request->n_ssids is an int.  It can't possibly be INT_MAX because
> the kcalloc() will fail.  Ideally the static analysis tool should
> be able to tell you that if you seed it with the knowledge of how
> much memory it's possible to kmalloc().  So it's just laziness here
> is why the static checker complains, it should see there is no
> issue.  Smatch fails here as well but I'll see if I can fix it.
> 
> Anyway let's say it could be negative then 0 is greater than
> negative values so the loop would be a no-op.  I've seen code where
> the user could set the loop bounds to s32min-4 but because it was
> "int i" instead of "unsigned int i" then it meant the loop was a
> no-op instead of being a security problem.  In other words,
> unsigned can be less secure.
> 
> I honestly have never seen a bug in the kernel where we intended to
> loop more than INT_MAX times, but there was a signedness bug
> preventing it. That's the only reason I can see to change the
> signedness.  Am I missing something?
> 

Hi Dan,

Thanks for providing the detailed explanation.

I understand your point, but what's your opinion about variable
'slot_id', as this variable is added to take only the positive
value(i.e from 0 to maximum number of filled elements), so for more
readability should we keep it same.

BTW in my opinion 'request->n_ssids' should have been unsigned
because it is suppose to hold only positive values along with 
smaller data type(may be u8 or u16, as the range might be enough to
hold the value of n_ssids). So we have advantage of size reduction
not just the increase in value range.

Suppose we get negative value for "request->n_ssids" & kmalloc is 
pass then we have to add some more extra code to free data and
return error code in wilc_wfi_cfg_alloc_fill_ssid(). In your opinion
should this condition be handled as the received 'request->n_ssids' is
of 'int' type.


Regards,
Ajay
