Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:41581 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZCLCaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 22:30:01 -0400
Received: by fxm24 with SMTP id 24so224816fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 19:29:57 -0700 (PDT)
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1236821360.9581.78.camel@maxim-laptop>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
	 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
	 <1236821360.9581.78.camel@maxim-laptop>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 04:29:54 +0200
Message-Id: <1236824994.7177.3.camel@maxim-laptop> (sfid-20090312_033007_566101_2C109BD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-12 at 03:29 +0200, Maxim Levitsky wrote:
> On Wed, 2009-03-11 at 11:17 -0700, Reinette Chatre wrote:
> > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > 
> > Patch fixes the bug 1900 at
> > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1900
> > 
> > Issues:
> > Throughput and success ratio calculations were not done properly.
> > Number of retries were exceeding 16.
> 
> ether.
> 
> On the other omitting  the 'disable_hw_scan=1' option (which appears to
> work once again, since  few days ago it broke s2disk with hung scan) -

Ah , I remember now. The disable_hw_scan=0 breaks (!) 
the rfkill support.

I don't know if this affects it, but I patched NM to poll the rfkill
each second.

When I enable radio - NM hangs forever in scanning mode. 
Only module reload helps.

Best regards,
	Maxim Levitsky

