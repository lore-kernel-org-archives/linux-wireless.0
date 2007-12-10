Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:49642 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbXLJQuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:50:54 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Date: Mon, 10 Dec 2007 17:48:43 +0100
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
References: <1196189059.6058.95.camel@johannes.berg> <200712101630.48124.mb@bu3sch.de> <1197303523.6035.92.camel@johannes.berg>
In-Reply-To: <1197303523.6035.92.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712101748.43693.mb@bu3sch.de> (sfid-20071210_165105_946752_A78BDCE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 December 2007 17:18:43 Johannes Berg wrote:
> 
> > my_data = read_drom_device()
> > swap_to_cpu(my_data)
> > do_whatever(my_data)
> > store the data somewhere else in the device structs for
> > later use, maybe.
> > do_something_else(my_data)
> > 
> > You see that now you have only _one_ place that you have to care about.
> > And if you have to write your data back at some point, simply do it
> > just before the write.
> 
> The thing is that Tomas is saying that because they don't have a
> function to "read_from_device()" but that is rather only
> "shared_structure->something" it is special and completely different
> than regular drivers.

The read_from_device wasn't supposed to be a function call, actually.
It was more a "get data from the device, somehow". That could be reading
a structure that we just received via DMA.

> The actual runtime penalty of byteswaps is insignificant since fetching
> the value from memory already takes forever.

Right, as per definition these values can't be in the cache. :)

-- 
Greetings Michael.
