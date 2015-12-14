Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34185 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbbLNM60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:58:26 -0500
Received: by mail-wm0-f50.google.com with SMTP id p66so60734581wmp.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:58:25 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 14 Dec 2015 13:58:25 +0100
Message-ID: <CALhHN=prjjYLWEa6XSZSOwWTW+3eggPKQ3P1eNCt1fhKUwwvMQ@mail.gmail.com> (sfid-20151214_135829_538924_45C6BC98)
Subject: SUPPORTS_CLONED_SKBS question
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

During ath9k test we found a performance problem in TCP TX direction.
Seems a lot of time we spent in memcpy() and this is
because ath9k don't set SUPPORTS_CLONED_SKBS, and next
pskb_expand_head() is called for every TCP frame.

Base of SUPPORTS_CLONED_SKBS description, we can set this flag
in case driver will not touch payload or tailroom.
What exactly does it mean?

What in case of headroom, while ath9k already move 80211 header - add padding
after header (skb_push(hdrlen & 3) + memmove) and remove this padding
in tx_completion.

What in case of FCS?

I am not sure this is save to set this flag for ath9k?
Any hints?

BR
Janusz
