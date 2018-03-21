Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:22449 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbeCUFFs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 01:05:48 -0400
Date: Wed, 21 Mar 2018 10:35:41 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 01/11] staging: wilc1000: refactor scan() to free
 kmalloc memory on failure cases
Message-ID: <20180321103541.53c399c0@ajaysk-VirtualBox> (sfid-20180321_060755_534837_867C3AB9)
In-Reply-To: <20180320194632.2dwmzdx5h4mvnksk@mwanda>
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
        <1521564944-3565-2-git-send-email-ajay.kathat@microchip.com>
        <20180320194632.2dwmzdx5h4mvnksk@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for your detailed review comments.

On Tue, 20 Mar 2018 22:46:32 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Tue, Mar 20, 2018 at 10:25:34PM +0530, Ajay Singh wrote:
> > Added changes to free the allocated memory in scan() for error condition.
> > Also added 'NULL' check validation before accessing allocated memory.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>

> Don't put a blank line between the alloc and the check.  They're as
> connected as can be.  I hate "goto out;" but that is a personal
> preference which I would never push on to other developers...
> 

I will modify the code to address the review comments and will send the
updated patch.

> > +
> > +	ntwk->n_ssids = request->n_ssids;
> > +
> > +	for (i = 0; i < request->n_ssids; i++) {
> > +		if (request->ssids[i].ssid_len > 0) {
> > +			struct hidden_net_info *info = &ntwk->net_info[i];
> > +
> > +			info->ssid = kmemdup(request->ssids[i].ssid,
> > +					     request->ssids[i].ssid_len,
> > +					     GFP_KERNEL);
> > +
> > +			if (!info->ssid)
> > +				goto out_free;
> > +
> > +			info->ssid_len = request->ssids[i].ssid_len;
> > +		} else {
> > +			ntwk->n_ssids -= 1;
> > +		}  
> 
> You didn't introduce the problem, but this loop seems kind of buggy.  We
> should have two iterators, one for request->ssids[i] and one for
> ntwk->net_info[i].  Otherwise we're copying the array information but
> we're leaving holes in the destination array.  Which would be fine
> except we're not saving the totaly number of elements in the destination
> array, we're saving the number of elements with stuff in them.
> 
> So imagine that we have a request->n_ssids == 10 but only the last
> three elements have request->ssids[i].ssid_len > 0.  Then we record that
> ntwk->n_ssids is 3 but wthose elements are all holes.  So that can't
> work.  See handle_scan():
> 
> 	for (i = 0; i < hidden_net->n_ssids; i++)
> 		valuesize += ((hidden_net->net_info[i].ssid_len) + 1);
> 
> "valuesize" is wrong because it's looking at holes.

While testing, I found that the last element in request->ssids the
ssid_len is zero. For in between elements the values has some valid
length. I only tested for 'connect with AP' and 'iw scan' operation.
The scenario you have mention can occur for some instance. So, I will
modify the code to not have holes in allocated array at the time of
filling the data.
I will include these changes and send updated v2 patch set.

> 
> > +	}
> > +	return true;
> > +
> > +out_free:
> > +
> > +	for (; i >= 0 ; i--)
> > +		kfree(ntwk->net_info[i].ssid);  
> 
> The first kfree(ntwk->net_info[i].ssid); is a no-op.  You could write
> this like:
> 
> 	while (--i >= 0)
> 		kfree(ntwk->net_info[i].ssid);
> 

I will include these changes and send the updated patch.



Regards,
Ajay
