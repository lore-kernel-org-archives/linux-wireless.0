Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:55086 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424120AbcFMOYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 10:24:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] staging: wilc1000: message_queue: Replace semaphore sem with completion
Date: Mon, 13 Jun 2016 16:24:57 +0200
Message-ID: <3241664.xlvexBiRFW@wuerfel> (sfid-20160613_162438_177298_6A96EBDD)
In-Reply-To: <1465814259-3009-7-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org> <1465814259-3009-7-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 13, 2016 4:07:38 PM CEST Binoy Jayan wrote:
> The semaphore 'sem' is used as completion, so convert it to a
> struct completion type.
> 
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>

This does not really look like a classic completion, instead
I'd classify this as a counting semaphore.

> ---
>  drivers/staging/wilc1000/wilc_msgqueue.c | 13 +++++++------
>  drivers/staging/wilc1000/wilc_msgqueue.h |  4 ++--
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index 6cb894e..80c9631 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -3,6 +3,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
> +#include <linux/completion.h>
>  
>  /*!
>   *  @author		syounan
> @@ -13,7 +14,7 @@
>  int wilc_mq_create(struct message_queue *mq)
>  {
>  	spin_lock_init(&mq->lock);
> -	sema_init(&mq->sem, 0);
> +	init_completion(&mq->comp);
>  	INIT_LIST_HEAD(&mq->msg_list);
>  	mq->recv_count = 0;
>  	mq->exiting = false;
> @@ -34,7 +35,7 @@ int wilc_mq_destroy(struct message_queue *mq)
>  
>  	/* Release any waiting receiver thread. */
>  	while (mq->recv_count > 0) {
> -		up(&mq->sem);
> +		complete(&mq->comp);
>  		mq->recv_count--;
>  	}
>  

Here it gets released multiple times in a row, always corresponding
to recv_count.

> @@ -85,7 +86,7 @@ int wilc_mq_send(struct message_queue *mq,
>  
>  	spin_unlock_irqrestore(&mq->lock, flags);
>  
> -	up(&mq->sem);
> +	complete(&mq->comp);
>  
>  	return 0;
>  }
> @@ -112,19 +113,19 @@ int wilc_mq_recv(struct message_queue *mq,
>  	mq->recv_count++;
>  	spin_unlock_irqrestore(&mq->lock, flags);
>  
> -	down(&mq->sem);
> +	wait_for_completion(&mq->comp);
>  	spin_lock_irqsave(&mq->lock, flags);
>  
>  	if (list_empty(&mq->msg_list)) {
>  		spin_unlock_irqrestore(&mq->lock, flags);
> -		up(&mq->sem);
> +		complete(&mq->comp);
>  		return -EFAULT;
>  	}
>  	/* check buffer size */
>  	msg = list_first_entry(&mq->msg_list, struct message, list);
>  	if (recv_buf_size < msg->len) {
>  		spin_unlock_irqrestore(&mq->lock, flags);
> -		up(&mq->sem);
> +		complete(&mq->comp);
>  		return -EOVERFLOW;
>  	}
>  

And here you have the same function call both up() and down(),
which is fairly unusual.

My reading of the functions is that the semaphore value is the number
of messages currently outstanding to be consumed by wilc_mq_recv.

Interestingly, there is only one instance of the message queue, in
host_interface.c, with a single caller of the recv function and many
instances of send, so a good start for a cleanup would be to move
all the contents of wilc_msgqueue.c and wilc_msgqueue.h into
host_interface.c, making the functions all 'static'.

After that, the next observation is that the entire host_interface.c
file is basically a reimplementation of a 'work queue', and that should
not be needed.

We can deconstruct that kthread/message_queue logic by replacing it
with a regular create_singlethread_workqueue()/queue_work() setup,
by adding a 'struct work_struct' to 'struct host_if_msg'. The current
hostIFthread() loop then becomes a simple work queue helper
(without the loop).

Finally, we could move handling for each individual members of
'union message_body' out into a separate 'struct work_struct' and
completely remove the multiplexer that is currently part of
hostIFthread(), allowing us to move the implementation of each
message handler into the callsite of the function that currently
sends the 'host_if_msg'. I would suggest adding this last part to
the TODO file, but trying to just do the previous step of using
a single work function to get rid of the message queue implementation
and the semaphore inside of it.

	Arnd
