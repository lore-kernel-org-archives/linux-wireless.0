Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:48305 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933491AbdKAV26 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 17:28:58 -0400
Received: by mail-io0-f193.google.com with SMTP id d66so8379345ioe.5
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 14:28:58 -0700 (PDT)
Date: Wed, 1 Nov 2017 14:28:54 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Karthik Ananthapadmanabha <karthida@marvell.com>
Subject: Re: [PATCH 1/3] mwifiex: cleanup rx_pkt_lock usage in 11n_rxreorder.c
Message-ID: <20171101212853.GA89416@google.com> (sfid-20171101_224115_121119_8B35F0BD)
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
 <1509442967-14149-2-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1509442967-14149-2-git-send-email-gbhat@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 31, 2017 at 03:12:45PM +0530, Ganapathi Bhat wrote:
> From: Karthik Ananthapadmanabha <karthida@marvell.com>
> 
> Fix the incorrect usage of rx_pkt_lock spinlock. Realsing the
> spinlock while the element is still in process is unsafe. The
> lock must be released only after the element processing is
> complete.
> 
> Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> index 1edcdda..0149c4a 100644
> --- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> +++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> @@ -124,9 +124,10 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
>  			rx_tmp_ptr = tbl->rx_reorder_ptr[i];
>  			tbl->rx_reorder_ptr[i] = NULL;
>  		}
> -		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);

So, what is this lock protecting? Is it for protecting the packet
itself, or for protecting the ring buffer? As I read it, it's just the
latter, since once we've removed it from the ring buffer (and are about
to dispatch it up toward the networking layer), it's handled only by a
single context (or else, protected via some other common lock(s)).

If I'm correct above, then I think the current code here is actually
safe, since it holds the lock while removing from the ring buffer --
after it's removed from the ring, there's no way another thread can find
this payload, and so we can release the lock.

On a related note: I don't actually see the ring buffer *insertion*
being protected by this rx_pkt_lock, so is it really useful? See
mwifiex_11n_rx_reorder_pkt(). Perhaps the correct lock is actually
rx_reorder_tbl_lock()? Except that serves multiple purposes it seems...

Another thought: from what I can tell, all of these operations are
*only* performed on the main thread, so there's actually no concurrency
involved at all. So we also could probably drop this lock entirely...

I guess the real point is: can you explain better what you intend this
lock to do? Then we can review whether you're accomplishing your
intention, or whether we should improve the usage of this lock in some
other way, or perhaps even kill it entirely.

Thanks,
Brian

>  		if (rx_tmp_ptr)
>  			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
> +
> +		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
>  	}
>  
>  	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
> @@ -167,8 +168,8 @@ static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
>  		}
>  		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
>  		tbl->rx_reorder_ptr[i] = NULL;
> -		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
>  		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
> +		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
>  	}
>  
>  	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
> -- 
> 1.9.1
> 
