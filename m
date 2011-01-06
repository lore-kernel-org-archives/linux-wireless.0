Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1AFSzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 13:55:41 -0500
Subject: Re: [RFC PATCH 13/17] zd1211rw: use stack for small cmd-buffers
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Thu, 06 Jan 2011 12:55:37 -0600
In-Reply-To: <1294219627.3590.0.camel@jlt3.sipsolutions.net>
References: <20110104234745.25309.72030.stgit@fate.lan>
	 <20110104234935.25309.7558.stgit@fate.lan>
	 <1294219627.3590.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1294340139.5021.8.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-05 at 10:27 +0100, Johannes Berg wrote:
> On Wed, 2011-01-05 at 01:49 +0200, Jussi Kivilinna wrote:
> > Use stack for allocing small < 64 byte arrays.
> 
> I don't think this is valid -- DMA memory can't be from the stack.

It's almost certainly not valid.  You'll get BUGs from the kernel in
this case, though it'll still probably work.

Dan


