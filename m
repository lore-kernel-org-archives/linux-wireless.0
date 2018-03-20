Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58812 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbeCTTqt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 15:46:49 -0400
Date: Tue, 20 Mar 2018 22:46:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 01/11] staging: wilc1000: refactor scan() to free kmalloc
 memory on failure cases
Message-ID: <20180320194632.2dwmzdx5h4mvnksk@mwanda> (sfid-20180320_204653_616169_E01F2580)
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <1521564944-3565-2-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521564944-3565-2-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 20, 2018 at 10:25:34PM +0530, Ajay Singh wrote:
> Added changes to free the allocated memory in scan() for error condition.
> Also added 'NULL' check validation before accessing allocated memory.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 62 +++++++++++++++++------
>  1 file changed, 46 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> index 9d8d5d0..b784e15 100644
> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> @@ -582,6 +582,49 @@ static int set_channel(struct wiphy *wiphy,
>  	return result;
>  }
>  
> +static inline bool

This shouldn't be a bool function.  It should return 0 and -ENOMEM.
Bool functions should kind of have the return values built into the name
like access_ok() or IS_ERR().

> +wilc_wfi_cfg_alloc_fill_ssid(struct cfg80211_scan_request *request,
> +			     struct hidden_network *ntwk)
> +{
> +	int i = 0;

No need to initialize "i".

> +
> +	ntwk->net_info = kcalloc(request->n_ssids,
> +				 sizeof(struct hidden_network), GFP_KERNEL);
> +
> +	if (!ntwk->net_info)
> +		goto out;

Don't put a blank line between the alloc and the check.  They're as
connected as can be.  I hate "goto out;" but that is a personal
preference which I would never push on to other developers...

> +
> +	ntwk->n_ssids = request->n_ssids;
> +
> +	for (i = 0; i < request->n_ssids; i++) {
> +		if (request->ssids[i].ssid_len > 0) {
> +			struct hidden_net_info *info = &ntwk->net_info[i];
> +
> +			info->ssid = kmemdup(request->ssids[i].ssid,
> +					     request->ssids[i].ssid_len,
> +					     GFP_KERNEL);
> +
> +			if (!info->ssid)
> +				goto out_free;
> +
> +			info->ssid_len = request->ssids[i].ssid_len;
> +		} else {
> +			ntwk->n_ssids -= 1;
> +		}

You didn't introduce the problem, but this loop seems kind of buggy.  We
should have two iterators, one for request->ssids[i] and one for
ntwk->net_info[i].  Otherwise we're copying the array information but
we're leaving holes in the destination array.  Which would be fine
except we're not saving the totaly number of elements in the destination
array, we're saving the number of elements with stuff in them.

So imagine that we have a request->n_ssids == 10 but only the last
three elements have request->ssids[i].ssid_len > 0.  Then we record that
ntwk->n_ssids is 3 but wthose elements are all holes.  So that can't
work.  See handle_scan():

	for (i = 0; i < hidden_net->n_ssids; i++)
		valuesize += ((hidden_net->net_info[i].ssid_len) + 1);

"valuesize" is wrong because it's looking at holes.

> +	}
> +	return true;
> +
> +out_free:
> +
> +	for (; i >= 0 ; i--)
> +		kfree(ntwk->net_info[i].ssid);

The first kfree(ntwk->net_info[i].ssid); is a no-op.  You could write
this like:

	while (--i >= 0)
		kfree(ntwk->net_info[i].ssid);

Or:

	while (i--)
		kfree(ntwk->net_info[i].ssid);

Or you could do:

	for (i--; i >= 0 ; i--)
		kfree(ntwk->net_info[i].ssid);

I don't care...

regards,
dan carpenter
