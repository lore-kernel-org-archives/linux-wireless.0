Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:38772 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1AFVx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:53:59 -0500
Message-ID: <20110106235351.13153spun8nuf6qs@hayate.sektori.org>
Date: Thu, 06 Jan 2011 23:53:51 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [RFC PATCH 13/17] zd1211rw: use stack for small cmd-buffers
References: <20110104234745.25309.72030.stgit@fate.lan>
 <20110104234935.25309.7558.stgit@fate.lan>
 <1294219627.3590.0.camel@jlt3.sipsolutions.net>
 <1294340139.5021.8.camel@dcbw.foobar.com>
In-Reply-To: <1294340139.5021.8.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Williams <dcbw@redhat.com>:

> On Wed, 2011-01-05 at 10:27 +0100, Johannes Berg wrote:
>> On Wed, 2011-01-05 at 01:49 +0200, Jussi Kivilinna wrote:
>> > Use stack for allocing small < 64 byte arrays.
>>
>> I don't think this is valid -- DMA memory can't be from the stack.

Oh, my reply to Johannes didn't go to list.

>
> It's almost certainly not valid.  You'll get BUGs from the kernel in
> this case, though it'll still probably work.

Ok, will not use stack for urb transfer_buffers.

-Jussi

