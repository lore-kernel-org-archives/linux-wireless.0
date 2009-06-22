Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:1048 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbZFVUzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 16:55:42 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2027128ywb.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 13:55:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245576079.16399.31.camel@johannes.local>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
	 <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
	 <1244750836.29447.5.camel@johannes.local>
	 <83a869cd0906121341k3b58b80fvefdb74c2fca9449d@mail.gmail.com>
	 <1244839645.11782.5.camel@johannes.local>
	 <83a869cd0906191233g507fea1cg238d14b57ace0466@mail.gmail.com>
	 <83a869cd0906191237j7d727a4ekd6dbb9fc35d60b78@mail.gmail.com>
	 <1245576079.16399.31.camel@johannes.local>
Date: Mon, 22 Jun 2009 22:48:42 +0200
Message-ID: <83a869cd0906221348k4ed42ccbr6721c8bb020c4de5@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Race could happen with QOS :
let's consider queue 0 low prio and queue 1 high prio

- queue 1 send packet lot's of packet (iv32 = 0, iv32=1, iv32=2)
- queue 0 send a packet with iv32=1 and iv16=0xffff (or near wrap)

If queue 0 packet with iv32=1 is received after queue 1 with iv32=2, we will
- send tkip key for iv32=2 to hardware
- send tkip key for iv32=1 to hardware
and then we should wait wrap to iv32=3 to have a chance to send
correct key to hardware.


With this patch, we only send tkip key to hardware on the first wrap of a queue.
With the previous example, we will only send  tkip key for iv32=2 to hardware.

Gregor
