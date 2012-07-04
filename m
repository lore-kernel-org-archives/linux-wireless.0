Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2GDLkl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:40:41 -0400
Date: Wed, 4 Jul 2012 13:40:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] iwlegacy: don't mess up the SCD when removing a key
Message-ID: <20120704114029.GC2570@redhat.com> (sfid-20120704_134044_545233_507B2F5B)
References: <1341228681-19358-1-git-send-email-emmanuel.grumbach@intel.com>
 <20120704112208.GB2570@redhat.com>
 <CANUX_P2gvyRejAmvW-BSxKaA7TG1s=KcRczwShb8+WtT9==L5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P2gvyRejAmvW-BSxKaA7TG1s=KcRczwShb8+WtT9==L5w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 04, 2012 at 02:33:48PM +0300, Emmanuel Grumbach wrote:
> > On Mon, Jul 02, 2012 at 02:31:21PM +0300, Emmanuel Grumbach wrote:
> > > When we remove a key, we put a key index which was supposed
> > > to tell the fw that we are actually removing the key. But
> > > instead the fw took that index as a valid index and messed
> > > up the SRAM of the device.
> > >
> > > This memory corruption on the device mangled the data of
> > > the SCD. The impact on the user is that SCD queue 2 got
> > > stuck after having removed keys.
> > >
> > > Change-Id: I721f71c1a3a0af6058abe1975cebd9b613c7ff2b
> > > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > > ---
> > > Paul, can you please test ?
> > > If it solve the issues for you, I will send as a patch and Cc stable
> > > Totally not tested
> > > v2: first hunk of this patch thanks to Stanislaw's review
> >
> > I tested that patch and did not found any problem.
> >
> 
> Ok, but doest it solve the bug ?

CCing Poul.

But even if not, we still probably need that patch, right? Or is
possible that 4965 firmware do not corrupt memory when we provide
wrong key offset to it? Or maybe for 4965 key offset 0xff is something
that is expected and needed to invalidate the key?

Stanislaw   
