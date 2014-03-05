Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaCEKu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 05:50:57 -0500
Message-ID: <1394016654.5275.7.camel@jlt4.sipsolutions.net> (sfid-20140305_115101_697815_63C479E2)
Subject: Re: [PATCH 3.14.0-rc5 v3 2/10] rsi: Adding remaining header files
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fatima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 11:50:54 +0100
In-Reply-To: <531435FE.1000006@redpinesignals.com> (sfid-20140303_085923_497682_26845ACC)
References: <531435FE.1000006@redpinesignals.com>
	 (sfid-20140303_085923_497682_26845ACC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 13:27 +0530, Fariya Fatima wrote:

> +static inline int rsi_init_event(struct rsi_event *pevent)
> +{
> +	atomic_set(&pevent->event_condition, 1);
> +	init_waitqueue_head(&pevent->event_queue);
> +	return 0;
> +}
> +
> +static inline int rsi_wait_event(struct rsi_event *event, u32 timeout)
> +{
> +	int status = 0;
> +
> +	if (!timeout)
> +		status = wait_event_interruptible(event->event_queue,
> +				(atomic_read(&event->event_condition) == 0));
> +	else
> +		status = wait_event_interruptible_timeout(event->event_queue,
> +				(atomic_read(&event->event_condition) == 0),
> +				timeout);
> +	return status;
> +}

I think you should inline that, the extra code here is pretty pointless.

> +static inline int rsi_create_kthread(struct rsi_common *common,
> +				     struct rsi_thread *thread,
> +				     void *func_ptr,
> +				     u8 *name)
> +{
> +	init_completion(&thread->completion);
> +	thread->task = kthread_run(func_ptr, common, name);
> +	if (!IS_ERR(thread->task))
> +		return 0;
> +
> +	return -1;
> +}

-1 is -EPERM, that's likely not a good idea.

johannes

