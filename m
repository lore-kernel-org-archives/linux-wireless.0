Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:35175 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965259AbXCTKQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2007 06:16:34 -0400
Message-ID: <45FFB47F.2060807@warmcat.com>
Date: Tue, 20 Mar 2007 10:16:31 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] mac80211: Add radiotap support
References: <20070319110124.819185242@warmcat.com> <20070319110256.288303943@warmcat.com> <200703191315.33695.flamingice@sourmilk.net>
In-Reply-To: <200703191315.33695.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:

Hi Michael -

> +		rthdr->hdr.it_present =
> +			cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) ||
> +				    (1 << IEEE80211_RADIOTAP_RATE) ||
> +				    (1 << IEEE80211_RADIOTAP_CHANNEL) ||
> +				    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL));

These were the wrong kind of OR operator as well.

test.c:
#include <stdio.h>
int main() { printf("%d %d\n", 1 || 2, 1 | 2); return 0; }

$ gcc test.c
$ ./a.out
1 3

After fixing that it now works with tcpdump!

# tcpdump -i mon0 -s0 -X ether host 13:22:33:44:55:66

09:54:58.579725 1.0 Mb/s 2417 MHz (0x0480) 100dB signal 
13:22:33:44:55:66 (oui Unknown) Unknown SSAP 0x60 > 13:22:33:44:55:66 
(oui Unknown) Unknown DSAP 0x50 Unnumbered, ua, Flags [Command], length 38
         0x0000:  5061 636b 6574 7370 616d 6d65 7220 6272  Packetspammer.br
         0x0010:  6f61 6463 6173 7420 7061 636b 6574 2031  oadcast.packet.1
         0x0020:  3639 72b1 0066                           69r..f
09:54:58.679197 54.0 Mb/s 2417 MHz (0x0480) 100dB signal 
13:22:33:44:55:66 (oui Unknown) Unknown SSAP 0x60 > 13:22:33:44:55:66 
(oui Unknown) Unknown DSAP 0x50 Unnumbered, ua, Flags [Command], length 38
         0x0000:  5061 636b 6574 7370 616d 6d65 7220 6272  Packetspammer.br
         0x0010:  6f61 6463 6173 7420 7061 636b 6574 2031  oadcast.packet.1
         0x0020:  3730 c01d 92cd                           70....

Note the CRC appears, I guess it's okay.  With zd1211rw-mac80211 as it 
is, rx strength always appears as 100dB: it comes from 
ieee80211_rx_status.ssi.  1Mbps injection is working as well since a 
couple of tries ago on my patch.

-Andy
