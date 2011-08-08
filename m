Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1HHO21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 10:28:27 -0400
Date: Mon, 8 Aug 2011 16:28:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: rt2800usb: fix races in tx queue
Message-ID: <20110808142815.GA25877@redhat.com> (sfid-20110808_162830_443216_C78B21CF)
References: <20110804124653.GB5739@redhat.com>
 <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
 <20110808092914.GA2168@redhat.com>
 <CAOZOX0WM2gzOETSsJ1hR623ie1_eqcfS13bDoLxrJugcZ-Si4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOZOX0WM2gzOETSsJ1hR623ie1_eqcfS13bDoLxrJugcZ-Si4g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 11:43:55AM +0200, Ivo Van Doorn wrote:
> Well but for what reason would we want to read the register again? If
> we found an status report
> for a queue which does not have pending items, then in this change it
> would mean that the
> status report is intended for a TX frame which has yet to be enqueued
> to the hardware.
> 
> Obviously this means a mismatch between the TX status report and the
> actual frame to which it
> is being connected.

Ok, I will rewrite patch to skip TX status fifo reg if entry is pending.

Stanislaw
