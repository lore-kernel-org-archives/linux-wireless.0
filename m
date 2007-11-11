Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXKKUXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 15:23:08 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDU Rxcapability
Date: Sun, 11 Nov 2007 22:20:44 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04008798@hasmsx411.ger.corp.intel.com> (sfid-20071111_202311_789459_72C6B005)
In-Reply-To: <1194626462.4793.135.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> This patch adds the ability to receive and handle A-MSDU frames.

>> +			u16 amsdu_frame;

> Why a u16 of all the available types? Maybe just 'bool'?

32 bit alignment of this struct, but it may confuse someone else in the
future, I agree. I'll change it to u8.

>> +	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
>> +	case IEEE80211_FCTL_TODS:
>> +		/* BSSID SA DA */
>> +		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP &&
>> +		    sdata->type != IEEE80211_IF_TYPE_VLAN)) {
>> +			printk(KERN_DEBUG "%s: dropped ToDS frame
(BSSID=%s"
>> +			       " SA=%s DA=%s)\n",
>> +			       dev->name, print_mac(mac, hdr->addr1),
>> +			       print_mac(mac, hdr->addr2),
>> +			       print_mac(mac, hdr->addr3));

> net_ratelimit()

Will do

>> +			printk(KERN_DEBUG "%s: dropped FromDS&ToDS
frame"
>> +			       " (RA=%s TA=%s DA=%s SA=%s)\n",
>> +			       rx->dev->name, print_mac(mac,
hdr->addr1),
>> +			       print_mac(mac, hdr->addr2),
>> +			       print_mac(mac, hdr->addr3),
>> +			       print_mac(mac, hdr->addr4));

> ditto.

Will do

>> +			if (net_ratelimit())
>> +				printk(KERN_DEBUG "%s: dropped IBSS
frame"
>> +				       " (DA=%s SA=%s BSSID=%s)\n",
>> +				       dev->name, print_mac(mac,
hdr->addr1),
>> +				       print_mac(mac, hdr->addr2),
>> +				       print_mac(mac, hdr->addr3));

> Heh :)

>> +			skb_reserve(frame, local->hw.extra_tx_headroom +
>> +				    sizeof(struct ethhdr));

> Hah. I knew there was an skb_reserve missing in the original code :)

> The one thing I'm not sure about here is the EAPOL frame handling. In
> theory, such frames could be part of an aggregation and thus we'll not
> get them to the right place. Then again, we haven't decided yet what
the
> right place is. Also, what happens with 802.1X port control?

I agree. Good point and thanks for the catch.
Would appreciate your opinion for next possible solution:
I'll Move ieee80211_rx_h_data_agg before ieee80211_rx_h_802_1x_pae, and
assuming I identify A-MSDU, I'll loop for each internal MSDU on:
  ieee80211_rx_h_802_1x_pae 
  ieee80211_rx_h_drop_unencrypted
  ieee80211_rx_h_data
return value of ieee80211_rx_h_data_agg to
__ieee80211_invoke_rx_handlers will be this small loop's return value 

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
