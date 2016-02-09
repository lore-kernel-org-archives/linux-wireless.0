Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35548 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbcBIHag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 02:30:36 -0500
Received: by mail-lb0-f175.google.com with SMTP id bc4so95731071lbc.2
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2016 23:30:35 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 9 Feb 2016 08:30:34 +0100
Message-ID: <CAL1gcdPLXAgmb49=h=PTtktKFAYvBVCgbQZ=T+v26s4qxdpD+w@mail.gmail.com> (sfid-20160209_083039_837791_59BA78F7)
Subject: re: rt2x00: Fix queue related oops in case of deselected mac80211
 multi-queue feature.
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

(resending due to linux-wireless not accepting my message).

On Mon, Feb 8, 2016 at 6:55 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Gertjan van Wingerde,
>
> I have a question about patch 61448f88078e: "rt2x00: Fix queue related
> oops in case of deselected mac80211 multi-queue feature." from May 10,
> 2008 because I think there is an off by one.

Ouch, that's really a long time ago ;-)
I haven't been involved in rt2x00 for quite some time now, so let's see if I can
remember anything about this.

> drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
>   1239          /*
>   1240           * We need the following queues:
>   1241           * RX: 1
>   1242           * TX: ops->tx_queues
>   1243           * Beacon: 1
>   1244           * Atim: 1 (if required)
>   1245           */
>   1246          rt2x00dev->data_queues = 2 + rt2x00dev->ops->tx_queues + req_atim;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> We allocate everything at once in once chunk of memory.


Correct. That just simplifies the error handling and the whole piece of code.

The comment is the important thing here. These are the number of queues we have
to allocate. ops->tx_queues denotes the number of TX queues that the
hardware has.
As far as I can remember there are Ralink devices with 2 TX queues and
there are Ralink
devices with 4 TX queues. Also, there were devices with an ATIM queue
and there were
devices without an ATIM queue (again hardware dependent).

>   1247
>   1248          queue = kcalloc(rt2x00dev->data_queues, sizeof(*queue), GFP_KERNEL);
>   1249          if (!queue) {
>   1250                  rt2x00_err(rt2x00dev, "Queue allocation failed\n");
>   1251                  return -ENOMEM;
>   1252          }
>   1253
>   1254          /*
>   1255           * Initialize pointers
>   1256           */
>   1257          rt2x00dev->rx = queue;
>
> This is equivalent to &queue[0].  It's actually helpful to static
> checkers and people reading the code if you write it that because we
> are talking about the first element only and not the whole buffer.
> Meanwhile, people do it the reverse way and refer to &foo->start to talk
> about that whole "foo" buffer...  :/


I guess I can agree with that. Feel free to send a patch to "fix" this.

>   1258          rt2x00dev->tx = &queue[1];
>   1259          rt2x00dev->bcn = &queue[1 + rt2x00dev->ops->tx_queues];
>
> There are 2 ->tx_queues, I think so we skipped one queue.  We should
> have put it at &queue[2].  I looked at it briefly and I didn't see where
> the second queue is ever used so maybe this is harmless beyond the
> slight waste of memory.


As I mentioned above there can be either 2 or 4 TX queues. So for the
example of 2 TX queues,
these will be:
    &queue[1]
    &queue[2]

The beacon queue will be the next one, so this one will have to be
&queue[3], which is exactly
1 + number of TX queues (= 2 in this example).

Note that rt2x00dev->tx is supposed to be array of TX queues, not just
a single queue.

>
>
>   1260          rt2x00dev->atim = req_atim ? &queue[2 + rt2x00dev->ops->tx_queues] : NULL;
>   1261
>   1262          /*
>

Next, the ATIM queue is there (when present on the hardware).
Continuing the example of
above, this should be &queue[4], which again is exactly 2 + number of TX queues.

So, looking at this, I don't think there is an off-by-one error here.

---
Gertjan

-- 
---
Gertjan
