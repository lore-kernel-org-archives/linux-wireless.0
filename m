Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42244 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbbA1USk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 15:18:40 -0500
Message-ID: <1422430643.1973.1.camel@sipsolutions.net> (sfid-20150128_230953_458583_5D948B2A)
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: Bob Copeland <me@bobcopeland.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Date: Wed, 28 Jan 2015 08:37:23 +0100
In-Reply-To: <54C875FD.3070101@qca.qualcomm.com> (sfid-20150128_064104_435635_7E681844)
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
	 <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com>
	 <20150128043005.GB24933@localhost> <54C875FD.3070101@qca.qualcomm.com>
	 (sfid-20150128_064104_435635_7E681844)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 21:39 -0800, Peter Oh wrote:

> > Ok, sure, but I/O ordering two different writes, and ensuring device
> > has seen a posted write, are related but different things, no?
> yes, they are different and wmb guarantees both.

No, wmb() doesn't. I'd be very surprised if it had any side effect on
the PCI bus even on ARM. Read Documentation/memory-barriers.txt.

And to understand (PCI) posted writes, wikipedia helps:
http://en.wikipedia.org/wiki/Posted_write

johannes

