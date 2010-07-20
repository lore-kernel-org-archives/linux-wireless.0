Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:48870 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752550Ab0GTFJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 01:09:39 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0973692576
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 14:09:37 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH/RFC 0/3] ath5k: add driver tracepoints
Date: Tue, 20 Jul 2010 14:11:51 +0900
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
References: <1279395336-856-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1279395336-856-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007201411.51259.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun July 18 2010 04:35:33 Bob Copeland wrote:
> This series adds some tracepoints for reset and tx/rx, with an
> eye toward replacing some of the debug printks we have today.
> Stolen form iwlwifi is the idea of logging entire packets so
> we can generate pcap files from the traces, via something like:
> 
>     $ mkdir -p ~/.trace-cmd/plugins
>     $ cd ~/.trace-cmd/plugins
>     $ wget 'http://bobcopeland.com/srcs/ath5k_trace.py'
>     $ trace-cmd record -e mac80211 -e ath5k sleep 500
>     $ trace-cmd report | less
>     $ wireshark /tmp/pcap.out
> 
> I quite like the result, but I'd be interested to hear others'
> opinions on the approach.  Right now I think these tracepoints
> will be useful in seeing causes of excessive resets, and debugging
> queue hangs.

hmm, this is really nice stuff, but i'm not sure what to do on embedded boards 
where we don't have python or where it's not possible to use tracing in 
general due to (low) performance reasons. in these cases the kernel printks 
are just so much more easy to use... i would actually prefer to keep them... 
additionally to the new tracing you made, maybe? otoh we could probably get 
tracing enabled on all boards if we really need it, it's just some extra 
work...

bruno
