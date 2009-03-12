Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:42343 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZCLVV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 17:21:26 -0400
Received: by fxm24 with SMTP id 24so2308687fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 14:21:23 -0700 (PDT)
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1236880246.13699.17.camel@rc-desk>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
	 <1236821360.9581.78.camel@maxim-laptop>
	 <1236824994.7177.3.camel@maxim-laptop>  <1236880246.13699.17.camel@rc-desk>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 23:21:19 +0200
Message-Id: <1236892879.30325.7.camel@maxim-laptop> (sfid-20090312_222130_644174_D2BAFA99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-12 at 10:50 -0700, reinette chatre wrote:
> On Wed, 2009-03-11 at 19:29 -0700, Maxim Levitsky wrote:
> > On Thu, 2009-03-12 at 03:29 +0200, Maxim Levitsky wrote:
> > > On Wed, 2009-03-11 at 11:17 -0700, Reinette Chatre wrote:
> > > > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > > > 
> > > > Patch fixes the bug 1900 at
> > > > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1900
> > > > 
> > > > Issues:
> > > > Throughput and success ratio calculations were not done properly.
> > > > Number of retries were exceeding 16.
> > > 
> > > ether.
> > > 
> > > On the other omitting  the 'disable_hw_scan=1' option (which appears to
> > > work once again, since  few days ago it broke s2disk with hung scan) -
> > 
> > Ah , I remember now. The disable_hw_scan=0 breaks (!) 
> > the rfkill support.
> 
> Could you please provide more details about this issue? We are
> interested in steps to reproduce and logs you may have.

A way to reproduce (without NM):

* Start scanning in a loop
while true ; do sudo iwlist scan ; done

* press rfkill - scan hangs forever.
* press rfkill again - doesn't help

I have acer 5720G with hardware rfkill.


The problem seems to be that if user presses rfkill during scan, it
hangs.


How about rate control issues I still see, do you know why upload is
slower that download?

Best regards,
	Maxim Levitsky

