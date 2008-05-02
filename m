Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:18987 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbYEBTgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 15:36:18 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1027064fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2008 12:36:15 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: rt61pci/rt73usb: Hardware decryption IV/EIV
Date: Fri, 2 May 2008 21:41:28 +0200
Cc: rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805022141.28351.IvDoorn@gmail.com> (sfid-20080502_213556_516117_4DC0B461)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working on the Hardware encryption/decryption in rt61pci/rt73usb,
and I am currently hitting a wall on the IV/EIV part.

To make mac80211 I am inserting the IV/EIV data right after the ieee80211 header,
but as soon as I do that, all data frames magically disappear in mac80211.
Without the IV/EIV data the frames are getting through correctly (i.e. I can ping my AP)
And yes, I am setting the RX_FLAG_IV_STRIPPED flag when the IV is gone, and clear
it when the IV is present. :)

This is what is currently happening in the driver part:

1) If decryptor indicates a cipher was used during RX, assume decryption took place
2) read IV/EIV data from decriptor
3) set RX_FLAG_IV_STRIPPED
4) check decryption status and set RX_FLAG_DECRYPTED if decryption succeeded

After that the following happens in rt2x00pci:
		iv_len = ((!!rxdesc.iv) * 4) + ((!!rxdesc.eiv) * 4);

		if (1 && (rxdesc.flags & RX_FLAG_IV_STRIPPED) && iv_len) {
			skb_put(entry->skb, rxdesc.size + iv_len);
			/* Copy ieee80211 header */
			memcpy(entry->skb->data, priv_rx->data, header_size);
			/* Copy IV/EIV data */
			if (iv_len >= 4)
				memcpy(entry->skb->data + header_size,
				       &rxdesc.iv, 4);
			if (iv_len >= 8)
				memcpy(entry->skb->data + header_size + 4,
				       &rxdesc.eiv, 4);
			/* Copy payload */
			memcpy(entry->skb->data + header_size + iv_len,
			       priv_rx->data + header_size,
			       rxdesc.size - header_size);
			/* Update frame length to include IV/EIV */
			rxdesc.size += iv_len;
			rxdesc.flags &= ~RX_FLAG_IV_STRIPPED;
		}

But when this code runs, the frame will somewhere disappear in mac80211.
I noticed that when I didn't insert the IV into the frame the debugfs counter
rx_handlers_drop remains relatively low (max 5 after a minute or so).
But when the IV is inserted this counter starts counting up with a speed
that might patch the number of pings I am sending out. (note that ping never
returns any results, not even a timeout).

After adding tons of debuglines in the RX path in mac80211 I find the following:

ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
{
	<snip>
	case IEEE80211_FCTL_FROMDS:
		/* DA BSSID SA */
		memcpy(dst, hdr->addr1, ETH_ALEN);
		memcpy(src, hdr->addr3, ETH_ALEN);

		if (sdata->vif.type != IEEE80211_IF_TYPE_STA ||
		    (is_multicast_ether_addr(dst) &&
		     !compare_ether_addr(src, dev->dev_addr)))
			return -1;
		break;
	<snip>
}

The increase of the rx_handlers_drop counter is caused by this if statement,
printing out the frames for which the IV was inserted, and which frames were
dropped here, I get the following:

 PRE: 00:0c:f6:1e:43:4c 00:16:b6:12:5e:5c
 PRE: ff:ff:ff:ff:ff:ff 00:0c:f6:1e:43:4c
 wlan3: dropped FromDS frame (DST=ff:ff:ff:ff:ff:ff SRC=00:0c:f6:1e:43:4c)
 PRE: 00:0c:f6:1e:43:4c 00:16:b6:12:5e:5c
 PRE: ff:ff:ff:ff:ff:ff 00:0c:f6:1e:43:4c
 wlan3: dropped FromDS frame (DST=ff:ff:ff:ff:ff:ff SRC=00:0c:f6:1e:43:4c)
 PRE: 00:0c:f6:1e:43:4c 00:16:b6:12:5e:5c
 PRE: ff:ff:ff:ff:ff:ff 00:0c:f6:1e:43:4c
 wlan3: dropped FromDS frame (DST=ff:ff:ff:ff:ff:ff SRC=00:0c:f6:1e:43:4c)
 PRE: 00:0c:f6:1e:43:4c 00:16:b6:12:5e:5c
 PRE: ff:ff:ff:ff:ff:ff 00:0c:f6:1e:43:4c
 wlan3: dropped FromDS frame (DST=ff:ff:ff:ff:ff:ff SRC=00:0c:f6:1e:43:4c)
 PRE: 00:0c:f6:1e:43:4c 00:16:b6:12:5e:5c
 PRE: ff:ff:ff:ff:ff:ff 00:0c:f6:1e:43:4c
 wlan3: dropped FromDS frame (DST=ff:ff:ff:ff:ff:ff SRC=00:0c:f6:1e:43:4c)

All lines prefixed with "PRE" are printed in rt2x00 for each frame for which
the IV/EIV data was inserted, and the lines prefixed with "wlan3" are the
frames which were dropped in ieee80211_data_to_8023().

So now I am stuck, I see that the frames are dropped for a reason, and
obviously those are not the frames part of the ping. But I think it is very
strange these frames only show up when the IV/EIV data is being inserted.

Does anybody have any hint on where I should start looking about where
these frames come from, or what the cause might be of the disappearing frames?

Thanks,

Ivo
