Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64046 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab0FHVJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 17:09:24 -0400
From: <juuso.oikarinen@nokia.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<reinette.chatre@intel.com>
Date: Tue, 8 Jun 2010 23:09:02 +0200
Subject: RE: [PATCHv2] mac80211: Fix circular locking dependency in ARP
 filter handling
Message-ID: <EEF08FFE3AB06D43A1F6BDF1C0F779B3293D81DA58@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1276002335-18600-1-git-send-email-juuso.oikarinen@nokia.com>,<1276002863.3706.131.camel@jlt3.sipsolutions.net>
In-Reply-To: <1276002863.3706.131.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: ext Johannes Berg [johannes@sipsolutions.net]
>
>On Tue, 2010-06-08 at 16:05 +0300, Juuso Oikarinen wrote:
>
>> +             promisc = sdata->flags & IEEE80211_SDATA_PROMISC;
>> +             if (promisc)
>> +                     bss_conf->arp_filter_enabled = 0;
>> +             else
>> +                     bss_conf->arp_filter_enabled = sdata->arp_filter_state;
>
>bss_conf->arp_filter_enabled = !promisc && sdata->arp_filter_state;
>
>?
>
>Or if not, use false instead of 0 please.
>

Yes, sure I can change this.

My home WLAN is giving me a headache, so I can't seem to access my work machine just now, but I began to wonder if I managed to create the same locking problem in this patch I had before. To traverse the interface list we need to acquire a lock - either the mutex for the iflist (which seems not to be an option as we also need the mgd mutex - to be locked after the iflist mutex) or the rtnl lock, which I chose to acquire. I quess the filter reconfig work is in the same mac80211 workqueue as the rest of the stuff, so the rtnl lock problem is there again.

-Juuso

>johannes

