Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41990 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1BNJyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 04:54:21 -0500
Received: by qwa26 with SMTP id 26so2961413qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 01:54:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102141047.48790.jordipujolp@gmail.com>
References: <201102131531.29984.jordipujolp@gmail.com>
	<201102140943.13801.jordipujolp@gmail.com>
	<AANLkTi=057tQL07iBit=uZnckXVs4V+1=2pMCBpha+RU@mail.gmail.com>
	<201102141047.48790.jordipujolp@gmail.com>
Date: Mon, 14 Feb 2011 10:54:17 +0100
Message-ID: <AANLkTik0rEeK6qSc7rWxqDKicdNDEaH=ne+ODS+WwHQx@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: synchronize transmission routines
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Both rxdone as txdone are for USB devices on a singlethreaded
>> workqueue. So it the work items will be scheduled only once...
>
> maybe that could depend on the scheduler type or anythig else,
> please look the attached kernel config.
> (excuse me, I'm not an expert)
>
> also the complete Debian kernel source is available in my website.
>
>> And I am not aware of any race conditions on the txdone/rxdone
>> paths (my testing environment is a dual-CPU system as well, so
>> I am always testing with SMP enabled...)
>>
>
> Maybe the kernel config or the adapter type impllies a different behaviour, I
> can say that without this patch the connections are slow and sometimes does
> not pass any bit, the adapter was continuosly retrying the transmission.
> This patch solves that; sure that is not the better solution, but works,

Could you try the compat-wireless package? There are a lot
of queue-related patches in there which were submitted after 2.6.37.

Ivo
