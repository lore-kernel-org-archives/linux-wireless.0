Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57653 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbaJILed (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 07:34:33 -0400
Message-ID: <1412854470.1828.44.camel@jlt4.sipsolutions.net> (sfid-20141009_133443_614052_1A53E505)
Subject: Re: [PATCH] mac80211-hwsim: Add support for
 HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Oct 2014 13:34:30 +0200
In-Reply-To: <1412854183-27194-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141009_132952_252614_F60CFE01)
References: <1412854183-27194-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141009_132952_252614_F60CFE01)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 14:29 +0300, Jukka Rissanen wrote:

> +struct urelease_work {
> +	struct work_struct w;
> +	u32 portid;
> +};

Wouldn't it be simpler to embed the work struct in the hwsim data, and
just queue that up when the device is affected? you should be able to
walk the list in the notifier, I'd think.

> +static void remove_user_radios(u32 portid)
> +{
> +	struct urelease_work *w;
> +
> +	w = kmalloc(sizeof(*w), GFP_ATOMIC);
> +	if (w) {
> +		INIT_WORK((struct work_struct *)w, urelease_event_work);

That cast is currently correct, but still clearly the wrong thing to do.

> +		w->portid = portid;
> +		schedule_work((struct work_struct *)w);

ditto

johannes

