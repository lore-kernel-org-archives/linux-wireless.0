Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:56953 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZBVURG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 15:17:06 -0500
MIME-Version: 1.0
In-Reply-To: <20090222144742.GA6078@nowhere>
References: <20090222111807.GB5538@silver.sucs.org>
	 <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org>
	 <20090222144742.GA6078@nowhere>
Date: Sun, 22 Feb 2009 15:17:05 -0500
Message-ID: <b6c5339f0902221217r75803623sd48b9822138c9d92@mail.gmail.com> (sfid-20090222_211727_014574_8C5F94C9)
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
From: Bob Copeland <me@bobcopeland.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2009 at 9:47 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Sun, Feb 22, 2009 at 12:20:36PM +0000, Sitsofe Wheeler wrote:
>> On Sun, Feb 22, 2009 at 01:01:21PM +0100, Jiri Slaby wrote:
>> > The unsupported jumbo message might be a clue. When we jump to the next:
>> > label, the buffer is at the end of the list in software, while in
>> > hardware it isn't. In theory, we might hit the bug with rx buffers
>> > exhaustion, because the test (bf_last == bf) doesn't work as expected then.
>>
>> This seems to be happening somewhat regularly now - I've got a small
>> collections of the warnings (I'll include them below in case they are
>> any help):

If this is a recent phenomenon, can you try reverting my patch,
fcf6b1bca8cdfefc986909b57277af4628955bd8?

This was the last patch to touch the rx path in a meaningful way.  I can't
think of anything there that would cause a use-after-free in the change,
maybe removing the "bf->skb = NULL" line, but that's the software struct,
not the hardware dma descriptor.

-- 
Bob Copeland %% www.bobcopeland.com
