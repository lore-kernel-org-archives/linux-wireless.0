Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2CFGxt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 01:53:49 -0500
Date: Tue, 6 Mar 2012 07:53:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [PATCH 3.3] rt2x00: fix random stalls
Message-ID: <20120306065329.GA2373@redhat.com> (sfid-20120306_075409_260303_A37F8529)
References: <20120305164813.GB2979@redhat.com>
 <8287E603-C5DE-4CF9-8647-DE63B9D3E93E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8287E603-C5DE-4CF9-8647-DE63B9D3E93E@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gertjan

On Mon, Mar 05, 2012 at 08:54:37PM +0100, Gertjan van Wingerde wrote:
> There are more places in the rt2x00 code that call upon rt2x00queue_pause_queue and rt2x00queue_unpause_queue. Shouldn't these places be protected with tx_lock as well?

Hmm, good question. Perhaps there are possible races between other usage
of pause/unpause, but they are not obvious for me. 

Seems there are more bugs there, i.e on rt2x00queue_stop_queue, we first
clear QUEUE_STARTED then call pause_queue, which will just return with
that bit cleared.

On rt2x00queue_flush_queue(), we first call pause queue, then
->kick_queue, which will cause to call txdone and unpause queue. 

So, it's hard to tell for me right now if other paces needs serialization,
apparently related area needs some more detailed review, 

> Or better, shouldn't the locking be moved inside the pause / unpause functions?

Thats a bit more complication, because we need lock for TX queues only
and it has to be taken before test_and_{set,clear}_bit(QUEUE_PAUSED, &queue->flags),
otherwise we still can race.

I believe this patch is simplest possible approach to solve the problem,
at least for now.

Stanislaw
