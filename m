Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:44449 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501Ab2ECJ7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 05:59:23 -0400
Message-ID: <4FA256F2.3020200@stericsson.com> (sfid-20120503_115927_373420_D72785A4)
Date: Thu, 3 May 2012 11:59:14 +0200
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 12/21] cw1200: sta.*, mac80211 STA callbacks.
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit> <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com> <1330720003-15866-13-git-send-email-dmitry.tarnyagin@stericsson.com> <20120429034951.GA32368@localhost>
In-Reply-To: <20120429034951.GA32368@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob,

On Sun, Apr 29, 2012, Bob Copeland wrote:

>
> +	while (!list_empty(list)) {
[...]

> I think perhaps you can use list_for_each_entry_safe() here...
It's the same. Yes, list_for_each_entry_safe() can be used here as well.

>> +	LIST_HEAD(list);
> [...]
>> +	spin_lock(&priv->event_queue_lock);
>> +	list_splice_init(&priv->event_queue,&list);
>> +	spin_unlock(&priv->event_queue_lock);
>> +	__cw1200_free_event_queue(&list);
> ...and then you won't need to do the above?
I'm not sure I understand the question :(.

>> +	if (priv->listening ^ listening) {
> That's a unusual (to me anyway) way to spell "a != b".  On my
> version of gcc, generated code is exactly the same.
Yes, true. It looked quite natural for me at 00:16. Pach is welcome.

With best regards,
Dmitry
