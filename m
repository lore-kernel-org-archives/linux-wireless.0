Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.iad.emailsrvr.com ([207.97.245.116]:37195 "EHLO
	smtp116.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbXGZCXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 22:23:11 -0400
Message-ID: <46A80535.7060301@gentoo.org>
Date: Wed, 25 Jul 2007 22:21:41 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: driver bugs with changed mac address
References: <1182333938.3714.53.camel@johannes.berg>
In-Reply-To: <1182333938.3714.53.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> In zd1211, we start with hwaddr = dev->wiphy->perm_addr which isn't
> correct either, for a pure monitor mode we want to start with a zero mac
> addr to avoid acking packets. Also, zd1211rw will end up having a NULL
> hwaddr when a monitor interface is added, most likely segfaulting in
> zd_write_mac_addr then.

Sorry for the delay in getting to this.

Looking at this now, the behaviour you describe is not what happens. 
When I bring up an interface set to monitor mode, zd_mac_add_interface() 
gets called with a non-NULL mac address, the actual MAC of the device. 
So, when zd_mac_open gets called soon after, it calls zd_write_mac_addr 
with a non-NULL address, so it succeeds as normal.

Should I ignore the above and just set an all-zero MAC in the hardware 
when a monitor interface is brought up? (setting all-zero will disable acks)

Thanks,
Daniel

