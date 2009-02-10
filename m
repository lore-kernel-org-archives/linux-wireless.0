Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbZBJTEg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:36 -0500
Subject: Re: [ipw3945-devel] [PATCH v2.6.29] iwlwifi: save PCI state before
	suspend, restore after resume
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>, drago01 <drago01@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200902092051.44374.helmut.schaa@gmail.com>
References: <> <f6ca9fed0902091117k7326e51ag8469887cb1a99d53@mail.gmail.com>
	 <1234207772.11530.164.camel@rc-desk>
	 <200902092051.44374.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 11:08:19 -0800
Message-Id: <1234292899.1626.14.camel@rc-desk> (sfid-20090210_200501_403582_164060E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-02-09 at 11:51 -0800, Helmut Schaa wrote:
> Am Montag, 9. Februar 2009 schrieb reinette chatre:
> > On Mon, 2009-02-09 at 11:17 -0800, drago01 wrote:
> > > On Tue, Feb 3, 2009 at 7:20 PM, Reinette Chatre
> > > <reinette.chatre@intel.com> wrote:
> > > > This is the right thing to do and fixes the following warning:
> > > > [...]
> > > 
> > > With 2.6.29-rc4-git1 (which has this patch) I sometimes get:
> > > 
> > > iwl3945: Wait for START_ALIVE timeout after 2000ms.
> > > iwl3945 0000:07:00.0: PCI INT A disabled
> > > 
> > > After resume with results into no working wireless until the module is reloaded.
> > > I am not sure if this patch is the culprit (have not tried to revert
> > > it), but that's the only change that might have caused this (with rc3
> > > it was working fine, it just triggered the warning that this patch
> > > supposed to solve).
> > 
> > That patch is the culprit. Please see current status at
> > http://bugzilla.kernel.org/show_bug.cgi?id=12656
> 
> Reinette, maybe we could just use the rfkill-patch [1] I've submitted
> some time ago. Of course it does a bit more then just saving and restoring
> the pci state ;) but it changes iwl3945 to only use pci_save_state and
> pci_restore_state in the suspend and resume handlers which should fix the
> issue you've pointed out in comment #10.

indeed ... thanks to you we do not need to fix 2.6.30. As you say this
is a big change - I am going to try to get the one line fix in before
going this route because 2.6.29 is only looking for fixes right now.
Your changes are much cleaner though and I am very happy that it is in
wireless-testing already.

Reinette

