Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56171 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbbLNNax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 08:30:53 -0500
Message-ID: <1450099851.3871.19.camel@sipsolutions.net> (sfid-20151214_143057_194535_10599F21)
Subject: Re: SUPPORTS_CLONED_SKBS question
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Ido Yariv <ido@wizery.com>
Date: Mon, 14 Dec 2015 14:30:51 +0100
In-Reply-To: <CALhHN=prjjYLWEa6XSZSOwWTW+3eggPKQ3P1eNCt1fhKUwwvMQ@mail.gmail.com> (sfid-20151214_135825_770699_738420CE)
References: <CALhHN=prjjYLWEa6XSZSOwWTW+3eggPKQ3P1eNCt1fhKUwwvMQ@mail.gmail.com>
	 (sfid-20151214_135825_770699_738420CE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+Ido.

On Mon, 2015-12-14 at 13:58 +0100, Janusz Dziedzic wrote:

> Base of SUPPORTS_CLONED_SKBS description, we can set this flag
> in case driver will not touch payload or tailroom.
> What exactly does it mean?

Well, you must not modify the data in a way that would make the clone
invalid. That means you can't write to any of the data, essentially.

> What in case of headroom, while ath9k already move 80211 header - add
> padding
> after header (skb_push(hdrlen & 3) + memmove) and remove this padding
> in tx_completion.

I think that should be OK since you don't touch the payload data or the
tailroom.

> What in case of FCS?

What about it? Hopefully that's added by hardware and has no effect on
the skb?!

johannes
