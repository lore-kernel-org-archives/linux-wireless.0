Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaBLJfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 04:35:37 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Intel Linux Wireless (ilw@linux.intel.com)" <ilw@linux.intel.com>
Subject: RE: [PATCH] iwlwifi: disable TX AMPDU by default for iwldvm
Date: Wed, 12 Feb 2014 09:35:03 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303D663F1@HASMSX103.ger.corp.intel.com> (sfid-20140212_103542_889605_26CA4CA4)
References: <52FB360D.2060502@gmail.com>
 <1392195269-5514-1-git-send-email-egrumbach@gmail.com>
 <20140212091008.GB1315@redhat.com> <20140212092150.GC1315@redhat.com>
In-Reply-To: <20140212092150.GC1315@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Wed, Feb 12, 2014 at 10:10:08AM +0100, Stanislaw Gruszka wrote:
> > On Wed, Feb 12, 2014 at 10:54:29AM +0200, Emmanuel Grumbach wrote:
> > > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > >
> > > We have had a bug in TX AMPDU in iwldvm for a very long time. This
> > > bug has been raised in many bugzillas and threads on linux-wireless
> > > mailing list.
> > >
> > > The bug is in firmware and we won't be able to fix it in the near
> > > future. Hence, we prefer to disable TX AMPDU by default in iwldvm.
> > > This doesn't affect iwlmvm which supports 7160 /
> > > 3160 and up.
> >
> > ...
> >
> > >  #define IWL_DISABLE_HT_ALL	BIT(0)
> > > -#define IWL_DISABLE_HT_TXAGG	BIT(1)
> >
> > Whouln't simple change, by setting disable_11=2 by default, make the
> > same effect, and allow easly to enable TX aggregation (without kernel
> > recompile) ?
> 

I guess at that point, I prefer to have a compilation flag. In Redhat / Fedora you'd disable it by default right?
Also the module parameter is for iwlwifi which includes iwlmvm. When I did this change I mainly thought about distros not wanting to  change their modprobe.conf files. I want to give the possibility for distro to disable TX AMPDU for iwldvm and keep it enable for iwlmvm. We can move the module parameter to be iwldvm only, this would be the best, but it'd require distro to make changes... Ignoring the disable_11n module parameter in iwlmvm seems odd (even if this is what I do know for IWL_DISABLE_HT_ALL and IWL_DISABLE_HT_RXAGG).
If you (as a distro representative) have a better idea, I am willing to hear. After all, this change is mostly intended to make distro's life easier...

> Also, does the bug affect all iwldvm devices ? They have different firmware
> images, so I wonder if this is needed for all DVM devices.

I have seen reports from many users and many devices - and unfortunately I have never been able to reproduce - so I can't know if it affects all the devices. All I can see is that I saw reports on very old devices (5150) and with more recent devices (2230).

