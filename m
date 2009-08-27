Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39390 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZH0StE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 14:49:04 -0400
Received: by ewy2 with SMTP id 2so1493456ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 11:49:05 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: Cleanup rt2x00mac_bss_info_changed()
Date: Thu, 27 Aug 2009 20:49:03 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908262104.09230.IvDoorn@gmail.com> <1251358806.20531.9.camel@johannes.local>
In-Reply-To: <1251358806.20531.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200908272049.04046.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 August 2009, Johannes Berg wrote:
> On Wed, 2009-08-26 at 21:04 +0200, Ivo van Doorn wrote:
> > Since patch "rt2x00: bss_info_changed() callback is allowed to sleep" the
> > variable delayed wasn't used anymore. This means it can be removed
> > along with the call to schedule_work which depended on that variable.
> 
> I just wanted to say thanks for doing all the cleanups. It's really nice
> to see all my work on making callbacks non-atomic pay off in that way :)

yeah those kind of optimizations really help with the drivers. :)

I still have some other cleanups, but this was the easiest and most obvious one,
the others involve changing locking mechanisms so need better verification.

Ivo

