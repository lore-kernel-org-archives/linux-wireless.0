Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44147 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbbBBSyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 13:54:43 -0500
Message-ID: <1422903279.8755.1.camel@sipsolutions.net> (sfid-20150202_195446_222419_94D350C5)
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org
Date: Mon, 02 Feb 2015 19:54:39 +0100
In-Reply-To: <54CFB4F4.1070807@qca.qualcomm.com>
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
	 <20150127213349.GA24933@localhost> <54C824DC.5080804@qca.qualcomm.com>
	 <20150128043005.GB24933@localhost> <54C875FD.3070101@qca.qualcomm.com>
	 (sfid-20150128_064104_435635_7E681844) <1422430643.1973.1.camel@sipsolutions.net>
	 <54CC0B71.9050301@codeaurora.org>
	 <1422882133.1930.10.camel@sipsolutions.net>
	 <54CFB4F4.1070807@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-02 at 09:33 -0800, Peter Oh wrote:

> > The code (as it is before your patch) implies that it's trying to make
> > sure that before it continues, any previous writes to the PCIe device's
> > registers are posted. The only way to ensure that is to do a read to the
> > registers, as the code does now.

> Do you know how the read ensure that although the read code does not 
> check the return value?
> Can you explain how a read ensures that posted write reaches PCIe device?

You basically have the following sequence:

iowrite()
ioread()

If you look, you'll see that iowrite() is actually done (or should be,
or perhaps with appropriate syncs) on an uncached mapping. As a result,
the only thing you care about here is the PCIe bus, not the CPU cache
flush. And from there on that's just a question of PCIe bus semantics.

johannes

