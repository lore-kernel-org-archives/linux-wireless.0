Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51134 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab2GDLt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:49:27 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>
Subject: RE: [PATCH] iwlegacy: don't mess up the SCD when removing a key
Date: Wed, 4 Jul 2012 11:49:21 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3174771@HASMSX103.ger.corp.intel.com> (sfid-20120704_134955_508418_3AAB79CB)
References: <1341228681-19358-1-git-send-email-emmanuel.grumbach@intel.com>
 <20120704112208.GB2570@redhat.com>
 <CANUX_P2gvyRejAmvW-BSxKaA7TG1s=KcRczwShb8+WtT9==L5w@mail.gmail.com>
 <20120704114029.GC2570@redhat.com>
In-Reply-To: <20120704114029.GC2570@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Wed, Jul 04, 2012 at 02:33:48PM +0300, Emmanuel Grumbach wrote:
> > > On Mon, Jul 02, 2012 at 02:31:21PM +0300, Emmanuel Grumbach wrote:
> > > > When we remove a key, we put a key index which was supposed to
> > > > tell the fw that we are actually removing the key. But instead the
> > > > fw took that index as a valid index and messed up the SRAM of the
> > > > device.
> > > >
> > > > This memory corruption on the device mangled the data of the SCD.
> > > > The impact on the user is that SCD queue 2 got stuck after having
> > > > removed keys.
> > > >
> > > > Change-Id: I721f71c1a3a0af6058abe1975cebd9b613c7ff2b
> > > > Signed-off-by: Emmanuel Grumbach
> <emmanuel.grumbach@intel.com>
> > > > ---
> > > > Paul, can you please test ?
> > > > If it solve the issues for you, I will send as a patch and Cc
> > > > stable Totally not tested
> > > > v2: first hunk of this patch thanks to Stanislaw's review
> > >
> > > I tested that patch and did not found any problem.
> > >
> >
> > Ok, but doest it solve the bug ?
> 
> CCing Poul.
> 
> But even if not, we still probably need that patch, right? Or is possible that
> 4965 firmware do not corrupt memory when we provide wrong key offset to
> it? Or maybe for 4965 key offset 0xff is something that is expected and
> needed to invalidate the key?
> 

I guess the patch is needed for 4965. This code in fw is quite old and hasn't changed for a while, so...
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

