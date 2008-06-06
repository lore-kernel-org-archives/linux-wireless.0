Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbYFFKjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 06:39:18 -0400
MIME-Version: 1.0
Subject: RE: [PATCH] rt2x00: Rename tx_info to info to help compat-wirelessrevert MQ support for older kernels
Date: Fri, 6 Jun 2008 13:39:12 +0300
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04FA9CFD@hasmsx411.ger.corp.intel.com> (sfid-20080606_123925_133293_26444706)
In-Reply-To: <1212671763.698.11.camel@johannes.berg>
References: <20080605130734.GD17936@ruslug.rutgers.edu> <1212671763.698.11.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <linville@tuxdriver.com>, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Rename tx_info to info as used by other drivers. This will help
>> with CONFIG_NETDEVICES_MULTIQUEUE requirement for HT support support
>> in compat-wireless by allowing us to map skb_get_queue_mapping(skb)
>> to the old info->queue.
>>
>> An alternative is to maintain a large compat.diff which replaces all
>> skb_get_queue_mapping(skb) calls back to info->queue but since this
>> is the only driver which requires name change it seems worth it
>> to help with maintenance.
>> 
>> Compat-wireless shouldn't be a reason to accept patches in but if
>> the changes are just cosmetic it seems worth the benefit.
>> 
>> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

> That's just asking for trouble. If you really _must_ do magic in
> skb_get_queue_mapping, do it directly:

> int q = IEEE80211_SKB_CB(skb)->queue;

Aren't we heading into to troubles here? In kernels < 2.6.23 there is no
skb->queue_mapping. queue was once passed in the cb, but now that queue
was removed from info and info takes cb we are going to have a compat
problem.

Ron

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

