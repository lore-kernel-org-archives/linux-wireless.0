Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:29470 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbeEBJmk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 05:42:40 -0400
Date: Wed, 2 May 2018 15:12:29 +0530
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
Message-ID: <20180502151229.4be29ec8@ajaysk-VirtualBox> (sfid-20180502_114347_624510_A70ED942)
In-Reply-To: <20180502083935.uw4mxvcgnpayv3h3@mwanda>
References: <20180430125040.GA19050@embeddedor.com>
 <20180430195916.596a93eb@ajaysk-VirtualBox>
 <20180430152321.7pq4ol2ed7tzsrl4@mwanda>
 <20180502111735.5a2c6faa@ajaysk-VirtualBox>
 <20180502083935.uw4mxvcgnpayv3h3@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2 May 2018 11:39:36 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We're mainly discussing readability, right?
> 
> To me when people use "int" that tells me as a reader that we don't
> need to think about the type.  It's going to be a small number.
> 
> Say you have data which the user can control, then it's super
> important to focus on the data types.  We don't focus on it
> enough.  There is some kind of idea that good developers should
> just be super focused on everything all the time, but I don't think
> humans can do it.  So to me it's useful when the author tells me,
> "This an int type.  It's fine. This is not critical."
> 
> If you make request->n_ssids a u8 or u16, that isn't going to save
> any memory because the struct is padded.  You'd also need to audit
> a bunch of code to make sure that we don't overflow the u16.  If
> you wanted to overflow the int, you'd need to allocate several gigs
> of memory but kmalloc() is capped at KMALLOC_MAX_SIZE (4MB) so
> that's not possible. How many of these structs do we allocate?  Is
> it really worth optimizing the heck out of it?
> 
> There are times where want to be very deliberate with our types
> because we're dealing the large numbers, or user data or fast
> paths.  But there are other times where int is fine...
> 

As in this case, its fine to be of 'int' type.
So we can retain the current data type('int') for 'i' and 'slot_id'. 
Thank you for sharing your insights,it was very helpful.

Regards,
Ajay
