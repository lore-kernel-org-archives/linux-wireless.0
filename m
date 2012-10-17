Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2JQHtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 03:49:12 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: RE: Lots of trans->state != IWL_TRANS_FW_ALIVE warnings
Date: Wed, 17 Oct 2012 07:48:24 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3B86041@HASMSX106.ger.corp.intel.com> (sfid-20121017_094915_602904_4E184CB4)
References: <20121015144722.GA12560@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3B7D4BB@HASMSX106.ger.corp.intel.com>
 <20121015152336.GC12560@redhat.com> <20121015153752.GE12560@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3B7D5A6@HASMSX106.ger.corp.intel.com>
 <20121017065851.GB14306@redhat.com>
In-Reply-To: <20121017065851.GB14306@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > > > I glanced at the bugs and I can only see the trace dump. I am
> > > > > > pretty sure there is an issue before the dump - fw assert of
> > > > > > something like that. Can it be possible to get the full log?
> > > > > >
> > > > >
> > > > > Can you ask people to try the attached patch?
> > > > > This will let us know where the fw is brought down.
> > > >
> > > > Yes, I'll build kernel with that patch and request for test and dmesg.
> > >
> > > debug=0x400 is enough or do you want also some other flags?
> > >
> > 0x400 should be enough, but 0x403 would be better :-)
> 
> 
> There is some feedback from user with micocode errors here
> https://bugzilla.redhat.com/show_bug.cgi?id=866013
> 

Ok, this is what I suspected. SYSASSERT before the WARNING....
So we have 2 issues here - the SYSASSERT  and the reset.
BTW - do we have any insight on the NIC used - although I am pretty sure it doesn't matter much.

> Emmanuel, perhaps you could CC to those bug report I provided links earlier,
> so I'll not need to mail you, when someone will add additional info to those
> reports ?
> 

I will check :-)


> Thanks
> Stanislaw
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

