Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59391 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab1BNLoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 06:44:23 -0500
Received: by qyj19 with SMTP id 19so1318704qyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 03:44:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102141157.51656.jordipujolp@gmail.com>
References: <201102131531.29984.jordipujolp@gmail.com>
	<201102141047.48790.jordipujolp@gmail.com>
	<AANLkTik0rEeK6qSc7rWxqDKicdNDEaH=ne+ODS+WwHQx@mail.gmail.com>
	<201102141157.51656.jordipujolp@gmail.com>
Date: Mon, 14 Feb 2011 12:44:22 +0100
Message-ID: <AANLkTik0h-eQTaXvSR7t0rsBiWjssvjromGR+-=dnErY@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: synchronize transmission routines
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> >> Both rxdone as txdone are for USB devices on a singlethreaded
>> >> workqueue. So it the work items will be scheduled only once...
>
> guess (maybe) the problem is in the usb workqueues, I have found also an
> erratic behaviour in the usb mouse.

Even then, as soon as the USB fires the completion callback function,
rt2x00 will schedule the txdone and rxdone handlers to the mac80211
workqueue. So even when the USB layer has problems with the scheduling,
the txdone and rxdone paths are not affected.

>> Could you try the compat-wireless package? There are a lot
>> of queue-related patches in there which were submitted after 2.6.37.
>
> this afternoon will try that,

Ok

Ivo
