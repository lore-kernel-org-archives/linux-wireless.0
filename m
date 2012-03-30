Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56769 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab2C3IqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 04:46:22 -0400
Message-ID: <4F7572DB.909@neratec.com> (sfid-20120330_104626_884047_E37E9378)
Date: Fri, 30 Mar 2012 10:46:19 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org, rodrigue@qca.qualcomm.com
Subject: Re: [RFCv2 1/3] ath9k: add DFS pattern detector
References: <1332516842-27522-1-git-send-email-zefir.kurtisi@neratec.com> <1332516842-27522-2-git-send-email-zefir.kurtisi@neratec.com> <CAJ-VmokdXbi5BKxqWB5+cwUqPj_iGG+dhKzuxnSKk1y-E9PxSg@mail.gmail.com>
In-Reply-To: <CAJ-VmokdXbi5BKxqWB5+cwUqPj_iGG+dhKzuxnSKk1y-E9PxSg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adrian,

thanks for having a look.

No, if you look into dfs_pri_detector.c, you'll find some words on the
pulse and sequence pools (see DOC below).

Actually, ETSI pulses even have a PRF of up to 4000 pulses per second,
you'd go crazy allocating and freeing them continuously.

With the pools every instance is allocated once during a detector's
lifetime and is then provided to all pri_detectors commonly. The amount
of allocated memory grows up to the maximum simultaneously used
instances. This is limited by numerous means (sliding window, max
tolerated PRF, max pulses per window, etc.).

I did intensive memory allocation tracing when evaluating the detectors
in user-space with valgrind and the absolute maximum memory load in
worst-case (i.e. all DFS channels being flooded with pulse noise
superposed with radar patterns) had an instance count for pulses and
sequences of less than 1.5k, the maximum memory allocated does not
exceed 30kB. While that last number might differ based on the used slab
allocator, it is proven that the pool has a limited growth.

I planned to add some allocation statistics in the debugfs later.


Thanks,
Zefir

On 03/30/2012 08:04 AM, Adrian Chadd wrote:
> Hiya,
> 
> I know this is late, but I've been a bit busy elsewhere. :)
> 
> Does pulse_queue_enqueue() always allocate a new entry? What situation
> are pulse entries reused?
> 
> You likely don't want to be allocating a new pulse entry via malloc()
> for each pulse; it's going to be quite silly when you potentially
> handle > 1,000 false positives a second.
> 
> 
> Adrian
> 
> 
> On 23 March 2012 08:34, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> [...]
>> +
>> +/**
>> + * DOC: Singleton Pulse and Sequence Pools
>> + *
>> + * Instances of pri_sequence and pulse_elem are kept in singleton pools to
>> + * reduce the number of dynamic allocations. They are shared between all
>> + * instances and grow up to the peak number of simultaneously used objects.
>> + *
>> + * Memory is freed after all references to the pools are released.
>> + */
>> +static int singleton_pool_references;
>> +static LIST_HEAD(pulse_pool);
>> +static LIST_HEAD(pseq_pool);
>> +
>> [...]

