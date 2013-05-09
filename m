Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61521 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab3EIJ4F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 05:56:05 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lsdt9-1UP9HW0QhN-012LM0 for
 <linux-wireless@vger.kernel.org>; Thu, 09 May 2013 11:56:03 +0200
Message-ID: <518B72AE.4010402@rempel-privat.de> (sfid-20130509_115609_988734_84F167B4)
Date: Thu, 09 May 2013 11:55:58 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: radiotap@NetBSD.org, simon@superduper.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Standardisation - adding 2 bit STBC and Ness to MCS (repost 3)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo all,

this is probably third repost of this standardisation request.

History:
- 11 May 2012. initial request made by Simon Barber.
http://www.radiotap.org/suggested-fields/MCS%20extension%20for%20STBC%20and%20Ness

- 1 Okt 2012, Wireshark support this fields. Patches provided by 
Wojciech Dubowik.
https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=6720

- 1 Nov 2012. patches for intel adapters, ieee80211 and wireshark was 
uploaded by Simon.
http://www.radiotap.org/suggested-fields/MCS%20extension%20for%20STBC%20and%20Ness?action=AttachFile

- 17 Nov 2012. Simon posted new thread as suggested Johannes Berg.

- 1 May 2013. I restarted this discussion.

link to initial discussion:
http://comments.gmane.org/gmane.network.wireless.radiotap/302

As you can see it is already long standing issue...

Now to proposal mad by Simon. Please add comments like: agreed or not 
agreed and why.

======================== Proposal ===========================

This proposal is to extend the current MCS radiotap header to carry STBC 
and Ness information. This information is carried in the 802.11 HT-SIG 
field that carries all the other fields currently in this radiotap MCS 
header. Both STBC and Ness fields are needed alongside the others to 
calculate the length (duration in time) of a frame. This proposal adds 3 
bits to the known field and the flags field. See below for proposed text.

= MCS =

  Bit Number:: 19
  Structure:: u8 known, u8 flags, u8 mcs
  Required Alignment:: 1

The `mcs` field indicates the MCS rate index as in 
[[http://en.wikipedia.org/wiki/IEEE_802.11n-2009#Data_rates|IEEE_802.11n-2009]]

The `known` field indicates which information is known:
||'''flag'''||'''definition'''||
|| `0x01` || bandwidth ||
|| `0x02` || MCS index known (in `mcs` part of the field) ||
|| `0x04` || guard interval ||
|| `0x08` || HT format ||
|| `0x10` || FEC type ||
|| `0x20` || STBC known ||
|| `0x40` || Ness known (Number of extension spatial streams) ||
|| `0x80` || Ness data - bit 1 (MSB) of Number of extension spatial 
streams ||

The `flags` field is any combination of the following:
|| '''flag''' || '''definition''' ||
|| `0x03` || bandwidth - 0: 20, 1: 40, 2: 20L, 3: 20U ||
|| `0x04` || guard interval - 0: long GI, 1: short GI ||
|| `0x08` || HT format - 0: mixed, 1: greenfield ||
|| `0x10` || FEC type - 0: BCC, 1: LDPC ||
|| `0x60` || Number of STBC streams ||
|| `0x80` || Ness - bit 0 (LSB) of Number of extension spatial streams |

-- 
Regards,
Oleksij
