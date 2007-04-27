Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:5580 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756933AbXD0RWN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 13:22:13 -0400
Message-ID: <46322CA9.7090606@linux.intel.com>
Date: Fri, 27 Apr 2007 10:02:33 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Dan Williams <dcbw@redhat.com>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>	<200704251634.16604.flamingice@sourmilk.net>	<46312067.9090005@linux.intel.com>	<200704262023.52833.flamingice@sourmilk.net>	<1177684132.21025.36.camel@localhost.localdomain>	<20070427164208.25434f11@griffin.suse.cz>	<1177685793.21025.52.camel@localhost.localdomain> <20070427172004.32b7bf4a@griffin.suse.cz>
In-Reply-To: <20070427172004.32b7bf4a@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> The problem is that Michael during fixing of the stack for mainline
> inclusion encountered a problem with the current implementation of the
> hw scanning. We need to fix that problem.

All his patch does is delete the hw_scan callback.  It doesn't *fix* anything.

> The proposed solution (removing of the hw_scan callback) obviously
> fixes the problem. 

No, it doesn't fix the problem--it removes the functionality.  Deleting automatic AP selection "fixes the problem" too.

> Now, let's find something that fixes the problem as
> well but doesn't remove the functionality. James already proposed a
> solution that could work if a support for user space MLME is added. Do
> you have an idea how to add it?

userspace MLME needs to have a scan command if you really want to have efficient scanning controlled by userspace.  Tuning, waiting, tuning, waiting, tx, listening, tuning, ... introduces a *lot* of userspace/kernel/hardware bouncing.

The userspace MLME can evolve over time.  

User space can try and do sw scanning even if the hw_scan callback is setup.  Nothing about adding hw_scan prevents userspace from thrashing between the kernel, the drivers, and the host to chew up extra CPU cycles.

James
