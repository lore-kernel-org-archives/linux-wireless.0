Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51223 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932776AbcILKBJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:01:09 -0400
Subject: Re: [PATCH] mac80211: fix sequence number assignment for PS response
 frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20160904160059.66297-1-nbd@nbd.name>
 <1473674327.29016.3.camel@sipsolutions.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <afb51baf-ec2d-3600-9e5b-f406b9e836b7@nbd.name> (sfid-20160912_120317_394114_013925B1)
Date: Mon, 12 Sep 2016 12:01:05 +0200
MIME-Version: 1.0
In-Reply-To: <1473674327.29016.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-12 11:58, Johannes Berg wrote:
> On Sun, 2016-09-04 at 18:00 +0200, Felix Fietkau wrote:
>> When using intermediate queues, sequence number allocation is
>> deferred
>> until dequeue. This doesn't work for PS response frames, which bypass
>> those queues.
>> 
> Applied.
> 
> This worries me a bit though - there's nothing, afaict, that guarantees
> that dequeue and real TX are not concurrent, and that would corrupt a
> number of things, no?
Hm, I guess I didn't think of that. I guess this potential issue will go
away once we get Toke's tx handler reorder patch fixed, rebased and
integrated.

- Felix
