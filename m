Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab0BDMHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 07:07:38 -0500
Date: Thu, 4 Feb 2010 13:04:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Subject: Re: [PATCH] airo: fix setting zero length WEP key
Message-ID: <20100204120437.GA6068@dhcp-lab-161.englab.brq.redhat.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com> <1265229824.21707.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1265229824.21707.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 03, 2010 at 12:43:44PM -0800, Dan Williams wrote:
> On Tue, 2010-02-02 at 15:34 +0100, Stanislaw Gruszka wrote:
> > Patch prevents call set_wep_key() with zero key length. That fix long
> > standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
> > "airo: clean up WEP key operations". Additionally print call trace when
> > someone will try to use improper parameters, and remove key.len = 0
> > assignment, because it is in not possible code path.
> 
> What problem/regression does this actually fix?  set_wep_key() should
> never be called with zero-length key, 
There was one case where set_wep_key() was called instead of
set_wep_tx_idx().

> so we should actually be returning
> from that function instead of using WARN_ON() which would allow a
> zero-length key to be set (which isn't really valid).
Ok, changing that in v2 patch.

Cheers
Stanislaw
