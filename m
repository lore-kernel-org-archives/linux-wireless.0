Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33235 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1DGX3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:29:01 -0400
Received: by fxm17 with SMTP id 17so2009105fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:29:00 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Fri, 8 Apr 2011 03:28:52 +0400
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <201104020058.17232.chunkeey@googlemail.com>
In-Reply-To: <201104020058.17232.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104080328.53801.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Christian.

> "For best CPU usage and power consumption, having as few
> frames as possible percolate through the stack is
> desirable. Hence, the hardware should filter as much
> as possible."
> 
> Note: The available stlc45xx softmac specification does not
> specify whenever these features are implemented in the
> common [pci/usb] branches, or not . At least from the data
> I could gather, it doesn't look like this is the case.
> Therefore, I'm looking for test results from p54spi users.

I used for tests the following cell:

wlan1     Scan completed :
          Cell 01 - Address: 00:22:15:1C:09:D1
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=67/70  Signal level=-43 dBm  
                    Encryption key:on
                    ESSID:"test"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s
                    Bit Rates:24 Mb/s; 36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=0000000ebd708a53
                    Extra: Last beacon: 1016ms ago
                    IE: Unknown: 000474657374
                    IE: Unknown: 010882848B960C121824
                    IE: Unknown: 03010B
                    IE: Unknown: 2A0100
                    IE: Unknown: 32043048606C
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD180050F2020101000003A4000027A4000042435E0062322F00

Is it suitable? I guess that to do e.g. ARP filtering firmware must be able to decipher incoming packets.
How can I make sure that it does?

So, I associated with that AP and obtained an IP address.
Here's dmesg output to that moment:

[    4.192993] ieee80211 phy0: device now idle
[    4.197265] omap_device: omap2_mcspi.2: new worst case deactivate latency 0: 335693
[    4.217712] p54_set_groupfilter 1
[   30.147735] ieee80211 phy0: device no longer idle - scanning
[   30.152770] p54_set_groupfilter 1
[   31.028350] p54_set_groupfilter 1
[   31.028503] ieee80211 phy0: device now idle
[   36.037445] ieee80211 phy0: device no longer idle - scanning
[   36.037628] p54_set_groupfilter 1
[   36.919036] p54_set_groupfilter 1
[   36.919189] ieee80211 phy0: device now idle
[   36.931854] ieee80211 phy0: device no longer idle - working
[   36.932067] wlan0: authenticate with 00:22:15:1c:09:d1 (try 1)
[   36.948089] wlan0: authenticated
[   36.952606] ieee80211 phy0: device now idle
[   36.969268] ieee80211 phy0: device no longer idle - working
[   36.969512] wlan0: associate with 00:22:15:1c:09:d1 (try 1)
[   36.988677] wlan0: RX AssocResp from 00:22:15:1c:09:d1 (capab=0x411 status=0 aid=2)
[   36.988830] wlan0: associated
[   36.988922] ieee80211 phy0: Allocated STA 00:22:15:1c:09:d1
[   36.992919] ieee80211 phy0: Inserted STA 00:22:15:1c:09:d1
[   36.993103] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
[   36.993255] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
[   36.993377] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
[   36.993530] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
[   36.993743] p54_set_arpfilter 0
[   37.006134] omap_device: omap2_mcspi.2: new worst case deactivate latency 0: 1220703
[   37.028442] omap_device: omap2_mcspi.2: new worst case activate latency 0: 122070
[   51.168762] p54_set_arpfilter 1
[   51.170257] p54_set_groupfilter 1
[   51.171569] p54_set_groupfilter 1

Regarding ARP filtering I tried the following test:
- ping station from the outside to see if ARPs for its IP pass through;
- ping non-existing IP in the same network from the outside to see if other ARPs pass through.

To test multicast filtering I tried to ping several multicast addresses from the outside.

> +	if (on) {
> +		arp->filter_enable = cpu_to_le16(1);
> +		memcpy(arp->ipv4_addr, &bss_conf->arp_addr_list[0],
> +		       sizeof(arp->ipv4_addr));
> +	} else {
> +		arp->filter_enable = cpu_to_le16(0);
> +		memset(arp->ipv4_addr, 0, sizeof(arp->ipv4_addr));
> +	}

I see that although ARP filter was set (I added printfs to both branches above), all ARP requests pass through:

(none):~# ./tcpdump -i wlan0 -nn -s0 arp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan0, link-type EN10MB (Ethernet), capture size 65535 bytes
00:01:33.715332 arp who-has 192.168.4.33 tell 192.168.4.138
00:01:33.716644 arp reply 192.168.4.33 is-at 00:1d:6e:9b:ee:0d
00:01:38.765838 arp who-has 192.168.4.138 tell 192.168.4.33
00:01:38.777496 arp reply 192.168.4.138 is-at 00:21:00:38:5e:d9
00:01:45.486572 arp who-has 192.168.4.34 tell 192.168.4.138
00:01:46.458496 arp who-has 192.168.4.34 tell 192.168.4.138

> +	if (on) {
> +		grp->filter_enable = cpu_to_le16(1);
> +		grp->num_address = cpu_to_le16(priv->mc_maclist_num);
> +		memcpy(grp->mac_list, priv->mc_maclist, sizeof(grp->mac_list));
> +	} else {
> +		grp->filter_enable = cpu_to_le16(0);
> +		grp->num_address = cpu_to_le16(0);
> +		memset(grp->mac_list, 0, sizeof(grp->mac_list));
> +	}

And the same (no filtering, although multicast filter was set) result for multicast messages:

(none):~# ./tcpdump -i wlan0 -nn -s0 -e icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan0, link-type EN10MB (Ethernet), capture size 65535 bytes
00:22:23.855499 00:21:00:38:5e:d9 > 01:00:5e:00:00:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.0.0.1: ICMP echo request, id 11114, seq 1, length 64
00:22:24.856842 00:21:00:38:5e:d9 > 01:00:5e:00:00:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.0.0.1: ICMP echo request, id 11114, seq 2, length 64
00:22:26.632324 00:21:00:38:5e:d9 > 01:00:5e:00:00:02, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.0.0.2: ICMP echo request, id 11370, seq 1, length 64
00:22:31.850555 00:21:00:38:5e:d9 > 01:00:5e:00:01:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.0.1.1: ICMP echo request, id 13162, seq 1, length 64
00:22:32.846283 00:21:00:38:5e:d9 > 01:00:5e:00:01:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.0.1.1: ICMP echo request, id 13162, seq 2, length 64
00:22:35.624542 00:21:00:38:5e:d9 > 01:00:5e:01:01:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.1.1.1: ICMP echo request, id 13418, seq 1, length 64
00:22:36.624847 00:21:00:38:5e:d9 > 01:00:5e:01:01:01, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 224.1.1.1: ICMP echo request, id 13418, seq 2, length 64
00:22:43.052642 00:21:00:38:5e:d9 > 01:00:5e:01:02:03, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 230.1.2.3: ICMP echo request, id 13674, seq 1, length 64
00:22:44.052764 00:21:00:38:5e:d9 > 01:00:5e:01:02:03, ethertype IPv4 (0x0800), length 98: 192.168.4.138 > 230.1.2.3: ICMP echo request, id 13674, seq 2, length 64

Do you have any other tests in mind that I could run?
By the way, I see that ARP filter does not apply to the station in IBSS or mesh mode. Is that intended?

Thanks.
-- Max
