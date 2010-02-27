Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42475 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966806Ab0B0B1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 20:27:03 -0500
Date: Fri, 26 Feb 2010 20:26:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH resend] airo: return from set_wep_key() when key length
 is zero
Message-ID: <20100227012616.GA2590@tuxdriver.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
 <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
 <20100208205358.GA3852@tuxdriver.com>
 <20100226141027.GA10280@dhcp-lab-161.englab.brq.redhat.com>
 <1267225769.14995.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1267225769.14995.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 26, 2010 at 03:09:29PM -0800, Dan Williams wrote:
> On Fri, 2010-02-26 at 15:10 +0100, Stanislaw Gruszka wrote:
> > Even if keylen == 0 is a bug and should not really happen, better avoid
> > possibility of passing bad value to firmware.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> I actually told John to just apply your first patch via IRC, but perhaps
> he hasn't done that yet.  I cannot reproduce the issue that Chris
> encountered with my PCMCIA 350 using 5.60 firmware, and I bricked my
> card loading 5.40 firmware (same as Chris) onto it.
> 
> I couldn't find any failures your original patch on my 5.60 device, my
> objections were simply code flow and semantics.  So I'll ack the
> original patch.

commit f09c256375c7cf1e112b8ef6306cdd313490d7c0
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Tue Feb 2 15:34:50 2010 +0100

    airo: fix setting zero length WEP key
    
    Patch prevents call set_wep_key() with zero key length. That fix long
    standing regression since commit c0380693520b1a1e4f756799a0edc379378b462a
    "airo: clean up WEP key operations". Additionally print call trace when
    someone will try to use improper parameters, and remove key.len = 0
    assignment, because it is in not possible code path.
    
    Reported-by: Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
    Bisected-by: Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
    Tested-by: Chris Siebenmann <cks@cs.toronto.edu>
    Cc: Dan Williams <dcbw@redhat.com>
    Cc: <stable@kernel.org>
    Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Hth...

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
