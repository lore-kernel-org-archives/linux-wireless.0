Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56166 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0HKSDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:03:35 -0400
Received: by qwh6 with SMTP id 6so397616qwh.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Aug 2010 11:03:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9A3B6D8B-F99D-4822-9680-121FCC710AB9@cs.tu-berlin.de>
References: <mailman.2.1281088802.10054.ath9k-devel@lists.ath9k.org>
	<F980642C-09A1-41C9-95D2-ABA6C7ED3F98@cs.tu-berlin.de>
	<20100806184849.GF1757@tux>
	<9A3B6D8B-F99D-4822-9680-121FCC710AB9@cs.tu-berlin.de>
Date: Wed, 11 Aug 2010 13:56:17 -0400
Message-ID: <AANLkTimRWQFEVkyQF7wuj3=jQx_zCwFCqSBS0Y=KLxu3@mail.gmail.com>
Subject: Re: [ath9k-devel] Multiple interfaces with one card
From: Bob Copeland <me@bobcopeland.com>
To: Hakan Coskun <coskun@cs.tu-berlin.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 6, 2010 at 2:59 PM, Hakan Coskun <coskun@cs.tu-berlin.de> wrote:

> thank you for your really quick reply. We are already using wireless-testing for our development. The ath9k extensions will be commited soon. At the moment, we are using the eclipse to index the code and walk through the files. This is working quite good. But how can we see during runtime, what is happening. Should we use something like kgdb to trace the operation or what is your approach you take for development. Can you give us any hints ?
>

IMHO the best way to do this is a combination of mac80211 tracepoints and
ftrace, the function tracer, via trace-cmd.  Something like:

# trace-cmd record -p function -l ieee\* -e mac80211 sleep 300

...should get you five minutes worth of useful traces.  Of course command can
be anything you like.


-- 
Bob Copeland %% www.bobcopeland.com
