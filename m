Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:51651 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYAOAoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 19:44:54 -0500
Received: by py-out-1112.google.com with SMTP id u52so3356462pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2008 16:44:53 -0800 (PST)
Message-ID: <8e6f94720801141644t5542e676n4cd0a23c4bb30baf@mail.gmail.com> (sfid-20080115_004459_430375_170AEE7C)
Date: Mon, 14 Jan 2008 19:44:52 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <20080110154654.GC3109@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200801062337.35904.IvDoorn@gmail.com>
	 <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com>
	 <20080110154654.GC3109@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 10, 2008 10:46 AM, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Jan 10, 2008 at 06:52:40AM -0500, Will Dyson wrote:
> > There are also a bunch of antenna selection fixes that never went
> > upstream. These are required for my card to operate well at rates
> > greater than 1Mbit, even when fairly close to the AP.
>
> Can you identify specific patches?  If so I can evaluate whether they
> apply easily to 2.6.24 or if they need significant rework.

rt2x00: Rework rt61 antenna selection
(ca9aaeec2d36dd4a00fea6443c53e935cbfa59ef)

However, it definitely depends on

rt2x00: Split rt61/rt73 antenna selection into RX and TX antenna
(9da4cdaefb5e8e2e3be813d94ce7b401e60ff391)

This patch itself has further dependencies:
[PATCH] rt2x00: Correctly translate mac80211 antenna setup to rt2x00
[PATCH] rt2x00: Move quality statistics into seperate structure).

It looks fairly easy to merge around that last quality statistics
patch. But I am uncertain if it is a good idea. I can try it and post
the result if you are interested.

-- 
Will Dyson
