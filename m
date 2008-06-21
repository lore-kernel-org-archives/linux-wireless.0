Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:5359
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbYFULo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 07:44:26 -0400
Subject: Re: [RFC PATCHES] Re: Is configfs the right solution for
	configuration based fs?
From: Ben Nizette <bn@niasdigital.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>,
	Satyam Sharma <ssatyam@cse.iitk.ac.in>,
	Felix Fietkau <nbd@openwrt.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	"H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <20080621084440.GA25489@ca-server1.us.oracle.com>
References: <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <20080619024804.GA29765@mail.oracle.com>
	 <1213942750.2336.43.camel@moss.renham>
	 <20080620065253.GA14238@ca-server1.us.oracle.com>
	 <1213953776.2336.75.camel@moss.renham>
	 <20080620213708.GC21416@mail.oracle.com>
	 <1214010229.2336.88.camel@moss.renham>
	 <20080621020201.GH21416@mail.oracle.com>
	 <1214035422.2336.121.camel@moss.renham>
	 <20080621084440.GA25489@ca-server1.us.oracle.com>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 21:44:44 +1000
Message-Id: <1214048684.2336.128.camel@moss.renham> (sfid-20080621_134522_042019_93FC477D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2008-06-21 at 01:44 -0700, Joel Becker wrote:
> On Sat, Jun 21, 2008 at 06:03:42PM +1000, Ben Nizette wrote:
> > In the kobject/kset case the separation makes sense as kobjects are
> > embedded in things all over the kernel controlling things like ref
> > counting, device model glue, hotplug info as well as the sysfs
> > representation.  The config_item doesn't have any responsibilities
> > outside of the configfs representation (does it?) so the analogy isn't
> > 100%.  Though of course the item/group split makes sense if there are
> > grander plans for the config_item in the future.
> 
> 	The config_item is indeed embedded in whatever struct it maps
> too.  eg, the ocfs2 nodemanager can have a couple hundred nodes, and
> that's one config_item per.  The fs/dlm stuff can have even more nodes.

Righteo, I guess the few 10s of bytes per struct saved by not tracking
children if we know that none can ever exist is the aim here?  Coming
from an embedded background that makes sense to me.

>From a conceptual point of view I still think they would work better
amalgamated in the configfs case but really this whole discussion is
pretty moot. I'm certainly not advocating a re-write of anything in
there!

Thanks for the clarifications (and patience ^_^), I'll do some work
using the new macros and get back to you asap.

Cheers,
	--Ben.

> 
> Joel
> 
