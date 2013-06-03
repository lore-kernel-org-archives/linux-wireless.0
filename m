Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:47406 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953Ab3FCRKC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:10:02 -0400
Date: Mon, 3 Jun 2013 19:09:59 +0200
From: Jakub Kicinski <moorray@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/7] rt2x00: rt2x00dev: use
 rt2x00dev->tx->limit
Message-ID: <20130603190959.70b1f4d2@north> (sfid-20130603_191010_698464_1D00E985)
In-Reply-To: <1367421455-18463-2-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
	<1367421455-18463-2-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor!

On Wed,  1 May 2013 17:17:29 +0200, Gabor Juhos wrote:
> The TX data queue is initialized already when
> the rt2x00lib_probe_hw() function is called.
>
> Fetch the number of the queue entries from that
> instead of using the entry_num field of the data
> queue descriptor.
>
> The two values are the same, and the use of the
> rt2x00dev->tx->limit value allows us to get rid
> of a superfluous pointer dereference.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 90dc143..b287467 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1077,7 +1077,7 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
>   		 */
>  		int kfifo_size =
>  			roundup_pow_of_two(rt2x00dev->ops->tx_queues *
> -					   rt2x00dev->ops->tx->entry_num *
> +					   rt2x00dev->tx->limit *
>  					   sizeof(u32));
>  
>  		status = kfifo_alloc(&rt2x00dev->txstatus_fifo, kfifo_size,

Unfortunately this does not work without your "get rid of
static data queue descriptors" series as well.

queue->limit is set when rt2x00lib_start is called, not on
probe. kfifo_alloc will fail with EINVAL here. As a result
support for all rt2x00 devices is broken on wireless-testing.

Maybe you can just post the mentioned series for inclusion?
I have been running with it since you posted it as RFC and
I did not notice any problems so far...

 -- kuba
