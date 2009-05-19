Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbZESW6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:58:38 -0400
Subject: Re: [PATCH v2.6.30 and w-t] iwlwifi: update 5000 ucode support to
 version 2 of API
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>
In-Reply-To: <20090519223535.GA4635@tuxdriver.com>
References: <1242770196-31072-1-git-send-email-reinette.chatre@intel.com>
	 <20090519223535.GA4635@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 19 May 2009 16:05:19 -0700
Message-Id: <1242774319.32358.851.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2009-05-19 at 15:35 -0700, John W. Linville wrote:
> On Tue, May 19, 2009 at 02:56:36PM -0700, Reinette Chatre wrote:
> > From: Jay Sternberg <jay.e.sternberg@linux.intel.com>
> > 
> > enable iwl driver to support 5000 ucode having version 2 of API
> > 
> > Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > ---
> > This ucode indicates an API change. The backward compatibility support
> > can already be found in 2.6.30 and wireless-testing in commit
> > 964c32bdc88b3d15dce34bb9ed0903e78e95fd57 "iwlwifi: correct API command
> > overlap"
> > 
> > Announcement of ucode availability to follow shortly.
> 
> Does this fix a bug?  What about it merits inclusion for 2.6.30?


Sorry for not including this information in original submit. The big fix
that people are waiting on is the fix for the "wrong command queue"
problem that shows up irregularly. This is tracked in
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1946 and
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1963 (marked
as duplicates). We used to have a bug for this in kernel.org bugzilla
(http://bugzilla.kernel.org/show_bug.cgi?id=12819 ) but it has been
closed as unreproducible.

Another big fix is an issue that the calibration was run in wrong
order ... one calibration needed information from another run, but it
was run before the one it depended on. This resulted in poor
performance. Unfortunately we do not have a bug report for this.

The other fixes in this firmware are "nice to have".

Reinette



