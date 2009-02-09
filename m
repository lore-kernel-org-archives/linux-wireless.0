Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbZBITZw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 14:25:52 -0500
Subject: Re: [ipw3945-devel] [PATCH v2.6.29] iwlwifi: save PCI state before
	suspend, restore after resume
From: reinette chatre <reinette.chatre@intel.com>
To: drago01 <drago01@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f6ca9fed0902091117k7326e51ag8469887cb1a99d53@mail.gmail.com>
References: <> <1233685203-5093-1-git-send-email-reinette.chatre@intel.com>
	 <f6ca9fed0902091117k7326e51ag8469887cb1a99d53@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 11:29:32 -0800
Message-Id: <1234207772.11530.164.camel@rc-desk> (sfid-20090209_202555_867639_3836B110)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-02-09 at 11:17 -0800, drago01 wrote:
> On Tue, Feb 3, 2009 at 7:20 PM, Reinette Chatre
> <reinette.chatre@intel.com> wrote:
> > This is the right thing to do and fixes the following warning:
> > [...]
> 
> With 2.6.29-rc4-git1 (which has this patch) I sometimes get:
> 
> iwl3945: Wait for START_ALIVE timeout after 2000ms.
> iwl3945 0000:07:00.0: PCI INT A disabled
> 
> After resume with results into no working wireless until the module is reloaded.
> I am not sure if this patch is the culprit (have not tried to revert
> it), but that's the only change that might have caused this (with rc3
> it was working fine, it just triggered the warning that this patch
> supposed to solve).

That patch is the culprit. Please see current status at
http://bugzilla.kernel.org/show_bug.cgi?id=12656

Reinette

