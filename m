Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:31464 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751489AbaEKJQL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 05:16:11 -0400
Date: 11 May 2014 05:16:07 -0400
Message-ID: <20140511091607.31386.qmail@ns.horizon.com> (sfid-20140511_111632_854115_F679D2A5)
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, pavel@ucw.cz
Subject: Re: [PATCH] lib/crc7: Shift crc7() output left 1 bit
Cc: arik@wizery.com, coelho@ti.com, david.gnedt@davizone.at,
	eliad@wizery.com, jan.nikitenko@gmail.com,
	laurent.pinchart+renesas@ideasonboard.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
In-Reply-To: <20140511082811.GA2695@xo-6d-61-c0.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Looks good, but should not function name change when functionality got
> completely different?

I couldn't think of one.  Can you?

I suppose adding a _be (big-endian) suffix would be consistent.
Is that okay with you?

To do it properly, I have to rename all of:

crc7_syndrome_table[]
crc7_byte()
crc7()

even though the third is the only (in-tree) user of the first two.
