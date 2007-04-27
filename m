Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:20127 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbXD0Rgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 13:36:42 -0400
Message-ID: <4632300E.8090507@linux.intel.com>
Date: Fri, 27 Apr 2007 10:17:02 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andy Green <andy@warmcat.com>, Dan Williams <dcbw@redhat.com>,
	Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>	 <200704251634.16604.flamingice@sourmilk.net>	 <46312067.9090005@linux.intel.com>	 <200704262023.52833.flamingice@sourmilk.net>	 <1177684132.21025.36.camel@localhost.localdomain>	 <20070427164208.25434f11@griffin.suse.cz>	 <1177685793.21025.52.camel@localhost.localdomain>	 <463213D7.9070604@warmcat.com> <1177687364.3565.36.camel@johannes.berg>
In-Reply-To: <1177687364.3565.36.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> The diff to rip out the hw_scan callback is tiny, and since it'd need to
> be worked on anyway to add notification when scanning is done,
> IMHO it is little more work to remove the scan now and add it back in one patch
> including the notification. 

The driver calls ieee80211_scan_completed(), which is in stack and works so let's not rip out hw_scan.

To be fair, I still don't know what was being fixed by taking hw_scan out... auto-AP selection has never worked here whether I use hw_scan or mac80211's sw scan; I have to configure everything from userspace including channel, essid, channel, and bssid (essid might be optional; I haven't tried not including it)

James
