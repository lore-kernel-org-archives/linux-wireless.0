Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbXKKUU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 15:20:29 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 03/14] mac80211: adding 802.11n HT framework definitions
Date: Sun, 11 Nov 2007 22:20:24 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04008796@hasmsx411.ger.corp.intel.com> (sfid-20071111_202033_680654_5A8E5EB4)
In-Reply-To: <1194625427.4793.117.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>  enum ieee80211_conf_flags {
>>  	IEEE80211_CONF_SHORT_SLOT_TIME	= 1<<0,
>>  	IEEE80211_CONF_RADIOTAP		= 1<<1,
>> +#ifdef CONFIG_MAC80211_HT
>> +	IEEE80211_CONF_SUPPORT_HT_MODE	= 1<<2,
>> +#endif /* CONFIG_MAC80211_HT */

> Why is this a configuration item? Does the PHY save power if you run
it
> only in 802.11a/b/g modes rather than N?

Most likely it will save power, because HT MIMO demands both antennas to
be active. In a/b/g PHY can allow itself to use a single antenna.

Ron

> Also, I don't think we should have the ifdef there.

Will be removed.

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
