Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48866 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab0BHVAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 16:00:54 -0500
Date: Mon, 8 Feb 2010 15:53:59 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH v2] airo: fix setting zero length WEP key
Message-ID: <20100208205358.GA3852@tuxdriver.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com> <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 04, 2010 at 01:07:13PM +0100, Stanislaw Gruszka wrote:
> Patch prevents call set_wep_key() with zero key length. That fix long
> standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
> "airo: clean up WEP key operations". Additionally print call trace when
> someone will try to use improper parameters, and remove key.len = 0
> assignment, because it is in not possible code path.
> 
> v1->v2
> Return instantly from set_wep_key() when keylen == 0.
> 
> Reported-and-bisected-by: Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: <stable@kernel.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Stanislaw, your original patch was already committed in
wireless-next-2.6.  Could you send a second patch with just your
v1->v2 change?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
