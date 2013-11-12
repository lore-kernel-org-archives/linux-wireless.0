Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33689 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLUg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 15:36:56 -0500
Message-ID: <52829163.5010201@candelatech.com> (sfid-20131112_213659_720969_C5141EF1)
Date: Tue, 12 Nov 2013 12:36:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Association often fails first time when roaming with 802.11r.
References: <52828324.3060105@candelatech.com>  <1384285594.14301.10.camel@jlt4.sipsolutions.net>  <52828A27.1040103@candelatech.com> <1384287024.14301.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1384287024.14301.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2013 12:10 PM, Johannes Berg wrote:
> On Tue, 2013-11-12 at 12:05 -0800, Ben Greear wrote:
>> A more correct roam also takes about 150ms, but at least not because of the
>> error in my previous email.  Seems it takes it 100+ms to go if-up after
>> the assoc-request is sent.  I'll go dig into that further.
> 
> The interface is already up (has to be to authenticate), the event you
> get at that point (just after the ~110ms delay) is for LOWER_UP really -
> which means carrier_on() in the kernel I believe. At that point you'd
> need kernel level tracing or messages to investigate.
> 
> Maybe something is waiting for a beacon there?

At least in the case I just looked at, it seems there were lots and lots
of retries of the re-assoc request from station to AP, and AP finally answers
after ~100ms.  We had the cisco's configured for OTA, so possibly that was
part of the issue.

On a second test, with cisco configured for non-OTA, it seems the response
comes back within 3ms, and there are no retransmits.

Looking at sniffer trace makes everything look nice at first, but if I compare the
actual packet timestamps with supplicant log time-stamps, it seems that it took
109ms from the time that supplicant sent the packet until the sniffer saw it.
I didn't see any other retransmits, and ACKs seem to show up normally in
the sniff.

>From the time the sniffer saw the re-assoc response until supplicant logged
the LOWER_UP logs below is 7ms or so.

1384287482.660792: nl80211: Associate (ifindex=6)
1384287482.660796:   * bssid=dc:a5:f4:f3:ce:9e
1384287482.660800:   * freq=5180
1384287482.660803:   * SSID - hexdump_ascii(len=10):
     61 69 72 6f 6e 65 74 31 2d 35                     aironet1-5
1384287482.660811:   * IEs - hexdump(len=143): 30 26 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 03 00 00 01 00 04 32 26 c7 8f 6e dc e6 29 2b f1 13 45 23
36 40 36 03 6f c9 01 37 60 00 03 40 82 46 b9 42 09 6a 0e 7c 4a b6 c0 3b 9a bc 74 c0 64 52 0a 0a fb 28 d7 00 1e a7 c5 c6 ab 7c 35 c8 32 aa a2 c9 4c 22 26 5b 18
ab 2c b0 a1 76 5b d2 fb dd e1 2e 17 96 09 7b 5d 90 7d 22 5f 83 63 eb 32 71 8b b2 02 ee a4 69 27 c4 f7 cc eb 72 f2 01 06 50 06 04 cb a8 80 03 04 c0 a8 02 0a
1384287482.660831:   * pairwise=0xfac04
1384287482.660834:   * group=0xfac04
1384287482.660837:   * prev_bssid=dc:a5:f4:ff:4f:ae
1384287482.660859: nl80211: Association request send successfully
1384287482.660871: RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
1384287482.660875: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
....

1384287482.664217: P2P: Update channel list
1384287482.778226: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
1384287482.778269: RTM_NEWLINK, IFLA_IFNAME: Interface 'sta1' added
1384287482.778296: nl80211: if_removed already cleared - ignore event
1384287482.779551: nl80211: Event message available
1384287482.779569: nl80211: Drv Event 38 (NL80211_CMD_ASSOCIATE) received for sta1
1384287482.779578: nl80211: MLME event 38 (NL80211_CMD_ASSOCIATE) on sta1(00:aa:aa:aa:aa:01) A1=00:aa:aa:aa:aa:01 A2=dc:a5:f4:f3:ce:9e

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

