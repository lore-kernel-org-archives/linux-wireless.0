Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56658 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbZJMRAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 13:00:04 -0400
Subject: Re: [ipw3945-devel] [PATCH 02/17 v2.6.32] iwl3945: update
 iwl3945_apm_init()
From: reinette chatre <reinette.chatre@intel.com>
To: Vedran Rodic <vrodic@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <8ccf2e9c0910130211j6f522d1ia4dc3a764896f974@mail.gmail.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
	 <1255119634-3060-3-git-send-email-reinette.chatre@intel.com>
	 <20091012185943.GC2794@tuxdriver.com>	 <1255377460.30637.150.camel@rc-desk>
	 <8ccf2e9c0910130211j6f522d1ia4dc3a764896f974@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 09:59:27 -0700
Message-Id: <1255453167.30637.307.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-10-13 at 02:11 -0700, Vedran Rodic wrote:
> I don't have sophisticated power measurement devices to confirm these
> fixes, and I've only tried patch 2/17, reporting back it on bug
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2094 that the
> problem is still not fixed with this patch applied only.

That is why I did not provide this bug number to John :) There appears
to be two issues here, one of which we have resolved with these patches.
We know that that bug is still open.

> Can you describe your testing methodoloy? Are you testing just the
> mini PCI card usage? Are you comparing to Windows XP or Vista drivers?

What these patches fix is the power consumption when the interface is
brought down. Before this work, if the interface was already up and then
brought down then the power used the device is only reset, not stopped.
We are still investigating an issue of power consumption before the
interface is brought up in the first place. We are not comparing to
other OS, just looking at power consumption.

Reinette

