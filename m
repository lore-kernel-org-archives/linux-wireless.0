Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754243AbeD3PXq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 11:23:46 -0400
Date: Mon, 30 Apr 2018 18:23:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: wilc1000: fix infinite loop and out-of-bounds
 access
Message-ID: <20180430152321.7pq4ol2ed7tzsrl4@mwanda> (sfid-20180430_172400_027711_D526D8DE)
References: <20180430125040.GA19050@embeddedor.com>
 <20180430195916.596a93eb@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180430195916.596a93eb@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2018 at 07:59:16PM +0530, Ajay Singh wrote:
> Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>
> 
> On Mon, 30 Apr 2018 07:50:40 -0500
> "Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:
> 
> > If i < slot_id is initially true then it will remain true. Also,
> > as i is being decremented it will end up accessing memory out of
> > bounds.
> > 
> > Fix this by incrementing *i* instead of decrementing it.
> 
> Nice catch!
> Thanks for submitting the changes.
> 
> > 
> > Addresses-Coverity-ID: 1468454 ("Infinite loop")
> > Fixes: faa657641081 ("staging: wilc1000: refactor scan() to free
> > kmalloc memory on failure cases")
> > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > ---
> > 
> > BTW... at first sight it seems to me that variables slot_id
> > and i should be of type unsigned instead of signed.
> 
> Yes, 'slot_id' & 'i' can be changed to unsigned int.
> 

A lot of people think making things unsigned improves the code but I
hate "unsigned int i"...  I understand that in certain cases we do loop
more than INT_MAX but those are a tiny tiny minority of loops.

Simple types like "int" are more readable than complicated types like
"unsigned int".  Unsigned int just draws attention to itself and
distracts people from things that might potentially matter.  We have
real life subtle loops like in xtea_encrypt() where we need to use
unsigned types.

And look at the function we're talking about here:

drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
   577  static inline int
   578  wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
   579                               struct hidden_network *ntwk)
   580  {
   581          int i;
   582          int slot_id = 0;
   583  
   584          ntwk->net_info = kcalloc(request->n_ssids,
   585                                   sizeof(struct hidden_network), GFP_KERNEL);
   586          if (!ntwk->net_info)
   587                  goto out;
   588  
   589          ntwk->n_ssids = request->n_ssids;
   590  
   591          for (i = 0; i < request->n_ssids; i++) {

request->n_ssids is an int.  It can't possibly be INT_MAX because the
kcalloc() will fail.  Ideally the static analysis tool should be able to
tell you that if you seed it with the knowledge of how much memory it's
possible to kmalloc().  So it's just laziness here is why the static
checker complains, it should see there is no issue.  Smatch fails here
as well but I'll see if I can fix it.

Anyway let's say it could be negative then 0 is greater than negative
values so the loop would be a no-op.  I've seen code where the user
could set the loop bounds to s32min-4 but because it was "int i" instead
of "unsigned int i" then it meant the loop was a no-op instead of being
a security problem.  In other words, unsigned can be less secure.

I honestly have never seen a bug in the kernel where we intended to loop
more than INT_MAX times, but there was a signedness bug preventing it.
That's the only reason I can see to change the signedness.  Am I missing
something?

   592                  if (request->ssids[i].ssid_len > 0) {
   593                          struct hidden_net_info *info = &ntwk->net_info[slot_id];
   594  
   595                          info->ssid = kmemdup(request->ssids[i].ssid,
   596                                               request->ssids[i].ssid_len,
   597                                               GFP_KERNEL);
   598                          if (!info->ssid)
   599                                  goto out_free;
   600  
   601                          info->ssid_len = request->ssids[i].ssid_len;
   602                          slot_id++;
   603                  } else {
   604                          ntwk->n_ssids -= 1;
   605                  }
   606          }
   607          return 0;
   608  
   609  out_free:
   610  
   611          for (i = 0; i < slot_id ; i--)
   612                  kfree(ntwk->net_info[i].ssid);
   613  
   614          kfree(ntwk->net_info);
   615  out:
   616  
   617          return -ENOMEM;
   618  }

regards,
dan carpenter
