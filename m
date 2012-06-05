Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2FEGhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 02:37:46 -0400
Message-ID: <1338878259.4514.9.camel@jlt3.sipsolutions.net> (sfid-20120605_083749_109063_CBF0E159)
Subject: Re: iwlwifi: bad error case cleanup for startup failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <linus971@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 05 Jun 2012 08:37:39 +0200
In-Reply-To: <CA+55aFxcC2mG8OUQ_cgM-vZGfnRZ09573b311G+81616Hgie9g@mail.gmail.com> (sfid-20120605_063338_789673_2F90D2E5)
References: <CA+55aFxcC2mG8OUQ_cgM-vZGfnRZ09573b311G+81616Hgie9g@mail.gmail.com>
	 (sfid-20120605_063338_789673_2F90D2E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-04 at 21:33 -0700, Linus Torvalds wrote:
> If the iwlwifi firmware loading calling iwl_ucode_callback() fails to
> start up the wireless driver - which will happen if CONFIG_PM is not
> enabled due to a mac80211 bug - iwlwifi will incorrectly try to
> release the firmware twice.
> 
> It already released the firmware and completed the firmware loading
> event after copying it to the internal driver buffers, if the driver
> startup fails it should not try to release it again.
> 
> The double release causes very nasty vmalloc() corruption, and results
> in some rather non-obvious page faults. To make matters worse, this
> happens within the context of the firmware loader callback, usually a
> kworker thread - and the killing of that thread then causes further
> problems, making the original issue very hard to discern.
> 
> The attached patch seems to fix it.

Yes, this seems correct, but there appears to be a related race
condition bug: due to the complete happening before iwl_dvm_ops.start()
we could go into iwl_dvm_ops.stop() while start() is running which
seems ... strange. I'll also move the complete() after the start() call.

johannes

