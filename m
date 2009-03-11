Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:42139 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZCKRUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 13:20:22 -0400
Received: by yw-out-2324.google.com with SMTP id 5so622862ywh.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 10:20:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236791626.20266.37.camel@johannes.local>
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
	 <1236739953-17701-2-git-send-email-lrodriguez@atheros.com>
	 <1236762611.9658.87.camel@johannes.local>
	 <20090311160740.GB5669@tesla>
	 <1236791626.20266.37.camel@johannes.local>
Date: Wed, 11 Mar 2009 10:20:18 -0700
Message-ID: <43e72e890903111020m10537058wbca980eb07ceb132@mail.gmail.com> (sfid-20090311_182026_500709_61D07831)
Subject: Re: [ath9k-devel] [PATCH v5 1/4] ath9k: implement IO serialization
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/11 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2009-03-11 at 09:07 -0700, Luis R. Rodriguez wrote:
>
>> > This is utterly insane. Just make it _always_ do the spinlock, and get
>> > rid of the hotplug notifier and all that crap.
>>
>> That is certainly an option as well but we would obviously be incurring
>> the lock on all reads/writes regardless of what bus you use which is
>> not necessary. We'll review this and determine whether its worth it.
>
> Hmm. I really don't understand this at all. Most operations won't be
> single writes and reads, and if you need multiple like a write+read for
> indirect register accesses then I'm sure you need to serialise them
> against each other in some other way too, no?

The issue is not serializing against separate routines calling some
reads or writes, this serialization prevents the PCI hardware FIFO
queue from getting more than two requests as otherwise the hardware
poops out. But as you can see this is only an issue with PCI devices,
not PCI express devices.

  Luis
