Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:59982 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcFUQFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 12:05:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging: wilc1000: Replace kthread with workqueue for host interface
Date: Tue, 21 Jun 2016 18:07:41 +0200
Message-ID: <7461266.G5R58nnEKu@wuerfel> (sfid-20160621_180617_191920_BCA35E87)
In-Reply-To: <1466417419-13568-3-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org> <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org> <1466417419-13568-3-git-send-email-binoy.jayan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 20, 2016 3:40:19 PM CEST Binoy Jayan wrote:
> Deconstruct the kthread / message_queue logic, replacing it with
> create_singlethread_workqueue() / queue_work() setup, by adding a
> 'struct work_struct' to 'struct host_if_msg'. The current kthread
> hostIFthread() is converted to a work queue helper with the name
> 'host_if_work'.
> 
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Hi Binoy,

You made a mistake here in adding the 'Reviewed-by:' tag before I replied with
that tag. I did a review of an earlier version and you addressed the comments
that I had for that, but you can only add the tag after I send that reply.

That said, the patch looks very good to me, and I see no remaining
problems that would prevent it from getting merged (after Atmel have tested
it), just a couple of things that would make it easier to review:

> +static int wilc_enqueue_cmd(struct host_if_msg *msg);
> +static void host_if_work(struct work_struct *work);

A small comment on coding style: we try to avoid forward declaration for local
functions. Instead, you can reorder the code to have the callee first. This
is the order which most readers will expect, and having no forward declarations
in the code makes it more likely that there are no recursions that would
be problematic for stack overflow.

>  /*!
>   *  @author		syounan
> @@ -336,95 +276,19 @@ static int wilc_mq_destroy(struct message_queue *mq)
>   *  @note		copied from FLO glue implementatuion
>   *  @version		1.0
>   */
> -static int wilc_mq_send(struct message_queue *mq,
> -		 const void *send_buf, u32 send_buf_size)
> +static int wilc_enqueue_cmd(struct host_if_msg *msg)

I think this API change can be done as a separate patch: the mq and send_buf_size
arguments are both constant for all callers, so you can have one patch just
removes them and renames the function, to make the patch that does the
tricky rework smaller.


> -		}
> +	if (msg->id == HOST_IF_MSG_CONNECT &&
> +	    msg->vif->hif_drv->usr_scan_req.scan_result) {
> +		wilc_enqueue_cmd(msg);
> +		usleep_range(2 * 1000, 2 * 1000);
> +		goto end;
> +	}
>  
> -		switch (msg.id) {
> -		case HOST_IF_MSG_SCAN:

A similar trick could apply here: we can leave the switch()
indented at the original level by putting it in an 'else'
clause. This again makes the patch shorter and easier to
review, and the optional reformatting can be done as a follow-up.

	Arnd
