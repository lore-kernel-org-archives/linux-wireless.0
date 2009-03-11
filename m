Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f167.google.com ([209.85.217.167]:46232 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZCKVI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 17:08:58 -0400
Received: by gxk11 with SMTP id 11so488155gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 14:08:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236792616.20266.39.camel@johannes.local>
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
	 <1236739953-17701-2-git-send-email-lrodriguez@atheros.com>
	 <1236762611.9658.87.camel@johannes.local>
	 <20090311160740.GB5669@tesla>
	 <1236791626.20266.37.camel@johannes.local>
	 <43e72e890903111020m10537058wbca980eb07ceb132@mail.gmail.com>
	 <1236792616.20266.39.camel@johannes.local>
Date: Wed, 11 Mar 2009 14:08:43 -0700
Message-ID: <43e72e890903111408n1af65629s4d3b6f4b1c6fbb44@mail.gmail.com> (sfid-20090311_220904_601376_E023CB46)
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

On Wed, Mar 11, 2009 at 10:30 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-03-11 at 10:20 -0700, Luis R. Rodriguez wrote:
>
>> > Hmm. I really don't understand this at all. Most operations won't be
>> > single writes and reads, and if you need multiple like a write+read for
>> > indirect register accesses then I'm sure you need to serialise them
>> > against each other in some other way too, no?
>>
>> The issue is not serializing against separate routines calling some
>> reads or writes, this serialization prevents the PCI hardware FIFO
>> queue from getting more than two requests as otherwise the hardware
>> poops out. But as you can see this is only an issue with PCI devices,
>> not PCI express devices.
>
> Well yes, but if you ever do multi-read/write operations then you need
> to synchronise at a higher level anyway -- hence I don't quite
> understand why this is necessary at all.

Agreed as the PCI FIFO issue should be visible on even UP boxes too. I
was trying to find out out exactly why in an SMP system this would
occur and it seems the only thing that would cause this is two
separate threads reading/writing. I did review this but I was unable
to find a specific synchronization issue. Technically the most obvious
case is where we handle the beacon tasklet on one CPU and then the
RX/TX tasklet (this is done in just one tasklet) in another but we
don't handle the beaconing tasklet in STA mode and this issue is seen
immediately upon association as a STA. I've been unable to locate that
source of possible synchronization issue. If you get an idea let me
know.

Your point about the simplicity of the code by always doing the
locking makes sense and its difficult to decide whether or not we want
that without doing elaborate tests and analysis. Only reason to
consider this carefully is that we will in fact be changing the
behavior of each read/write.

  Luis
