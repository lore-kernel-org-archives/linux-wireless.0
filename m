Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:58150 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZBITwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 14:52:07 -0500
Received: by bwz5 with SMTP id 5so1787318bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 11:52:05 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] [PATCH v2.6.29] iwlwifi: save PCI state =?iso-8859-1?q?before=09suspend?=, restore after resume
Date: Mon, 9 Feb 2009 20:51:43 +0100
Cc: ipw3945-devel@lists.sourceforge.net, drago01 <drago01@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <> <f6ca9fed0902091117k7326e51ag8469887cb1a99d53@mail.gmail.com> <1234207772.11530.164.camel@rc-desk>
In-Reply-To: <1234207772.11530.164.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902092051.44374.helmut.schaa@gmail.com> (sfid-20090209_205213_950179_0D52E3BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 9. Februar 2009 schrieb reinette chatre:
> On Mon, 2009-02-09 at 11:17 -0800, drago01 wrote:
> > On Tue, Feb 3, 2009 at 7:20 PM, Reinette Chatre
> > <reinette.chatre@intel.com> wrote:
> > > This is the right thing to do and fixes the following warning:
> > > [...]
> > 
> > With 2.6.29-rc4-git1 (which has this patch) I sometimes get:
> > 
> > iwl3945: Wait for START_ALIVE timeout after 2000ms.
> > iwl3945 0000:07:00.0: PCI INT A disabled
> > 
> > After resume with results into no working wireless until the module is reloaded.
> > I am not sure if this patch is the culprit (have not tried to revert
> > it), but that's the only change that might have caused this (with rc3
> > it was working fine, it just triggered the warning that this patch
> > supposed to solve).
> 
> That patch is the culprit. Please see current status at
> http://bugzilla.kernel.org/show_bug.cgi?id=12656

Reinette, maybe we could just use the rfkill-patch [1] I've submitted
some time ago. Of course it does a bit more then just saving and restoring
the pci state ;) but it changes iwl3945 to only use pci_save_state and
pci_restore_state in the suspend and resume handlers which should fix the
issue you've pointed out in comment #10.

Helmut

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=5b95e3a7f01364399ac66a7028ac6821487824b1

