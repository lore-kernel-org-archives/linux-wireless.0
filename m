Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbaBLKmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 05:42:43 -0500
Date: Wed, 12 Feb 2014 11:41:47 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Intel Linux Wireless (ilw@linux.intel.com)" <ilw@linux.intel.com>
Subject: Re: [PATCH] iwlwifi: disable TX AMPDU by default for iwldvm
Message-ID: <20140212104146.GD1315@redhat.com> (sfid-20140212_114248_738090_23045866)
References: <52FB360D.2060502@gmail.com>
 <1392195269-5514-1-git-send-email-egrumbach@gmail.com>
 <20140212091008.GB1315@redhat.com>
 <20140212092150.GC1315@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D663F1@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D663F1@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 12, 2014 at 09:35:03AM +0000, Grumbach, Emmanuel wrote:
> > 
> > On Wed, Feb 12, 2014 at 10:10:08AM +0100, Stanislaw Gruszka wrote:
> > > On Wed, Feb 12, 2014 at 10:54:29AM +0200, Emmanuel Grumbach wrote:
> > > > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > > >
> > > > We have had a bug in TX AMPDU in iwldvm for a very long time. This
> > > > bug has been raised in many bugzillas and threads on linux-wireless
> > > > mailing list.
> > > >
> > > > The bug is in firmware and we won't be able to fix it in the near
> > > > future. Hence, we prefer to disable TX AMPDU by default in iwldvm.
> > > > This doesn't affect iwlmvm which supports 7160 /
> > > > 3160 and up.
> > >
> > > ...
> > >
> > > >  #define IWL_DISABLE_HT_ALL	BIT(0)
> > > > -#define IWL_DISABLE_HT_TXAGG	BIT(1)
> > >
> > > Whouln't simple change, by setting disable_11=2 by default, make the
> > > same effect, and allow easly to enable TX aggregation (without kernel
> > > recompile) ?
> > 
> 
> I guess at that point, I prefer to have a compilation flag. In Redhat / Fedora you'd disable it by default right?

No, we do not have any extra options in /etc/modprobe.d/ for iwlwifi,
all is running with default settings.
 
> Also the module parameter is for iwlwifi which includes iwlmvm. When I did this change I mainly thought about distros not wanting to  change their modprobe.conf files. I want to give the possibility for distro to disable TX AMPDU for iwldvm and keep it enable for iwlmvm. We can move the module parameter to be iwldvm only, this would be the best, but it'd require distro to make changes... Ignoring the disable_11n module parameter in iwlmvm seems odd (even if this is what I do know for IWL_DISABLE_HT_ALL and IWL_DISABLE_HT_RXAGG).
> If you (as a distro representative) have a better idea, I am willing to hear. After all, this change is mostly intended to make distro's life easier...

If somebody has working aggregation and we will remove that from kernel,
we will get complains. Telling that he/she have to recompile kernel to
get functionality back, will not make live easier to anyone. Setting
module option is much much easier. 

In the past we have in iwlwifi module parameters initialized differently
for different devices. Though, it does not work with many devices on the
system, this is not an issue since normal users have only one device.
I guess the same could be used here:
0 - default (device specific), 1 - disable TX AGG, 2 - disable RX AGG,
4 - force enable TX AGG, 8 - force enable RX AGG.

> > Also, does the bug affect all iwldvm devices ? They have different firmware
> > images, so I wonder if this is needed for all DVM devices.
> 
> I have seen reports from many users and many devices - and unfortunately I have never been able to reproduce

So, that is argument to do not remove support for TX agg. If someone
has that working, he/she still should be able to use it.

Stanislaw
