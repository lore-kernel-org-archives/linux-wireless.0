Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:50151 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751469Ab0LAP0N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 10:26:13 -0500
Message-ID: <4CF66912.8050302@gmx.net>
Date: Wed, 01 Dec 2010 16:26:10 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: EAP Identity Response dropped on 5GHz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

My/our setup:

I'm using my HP Elitebook 2540p with Intel 6200 abgn
pci id: 8086:4239 (rev 35)

Kernel from Fedora 14, compat-wireless-20101130, wpa_supplicant from GIT
with -D nl80211.

I try to connect to CISCO APs with 802.1x.

Everything works fine on 2.4GHz frequencies. But on 5GHz frequencies I
see the EAP Identity Request from the AP and I see the response in
wireshark.

But I don't see the response on an other laptop monitoring this channel
and the AP logs a timeout after a while for the EAP Request.

In the same moments I see
> Dec  1 15:53:18 hpwb kernel: [15439.900071] wlan0: dropped frame to 00:26:cb:xx:xx:xx (unauthorized port)
> Dec  1 15:53:19 hpwb kernel: [15440.894484] wlan0: dropped frame to 00:26:cb:xx:xx:xx (unauthorized port)
> Dec  1 15:53:20 hpwb kernel: [15441.893895] wlan0: dropped frame to 00:26:cb:xx:xx:xx (unauthorized port)

wpa_supplicant logs:

> 1291215721.998646: Process pending EAPOL frame that was received just before association notification
> 1291215721.998677: RX EAPOL from 00:26:cb:xx:xx:xx
> 1291215721.998713: Setting authentication timeout: 70 sec 0 usec
> 1291215721.998747: EAPOL: Received EAP-Packet frame
> 1291215721.998778: EAPOL: SUPP_PAE entering state RESTART
> 1291215721.998806: EAP: EAP entering state INITIALIZE
> 1291215721.998835: EAP: EAP entering state IDLE
> 1291215721.998865: EAPOL: SUPP_PAE entering state AUTHENTICATING
> 1291215721.998895: EAPOL: SUPP_BE entering state REQUEST
> 1291215721.998924: EAPOL: getSuppRsp
> 1291215721.998952: EAP: EAP entering state RECEIVED
> 1291215721.998998: EAP: Received EAP-Request id=1 method=1 vendor=0 vendorMethod=0
> 1291215721.999034: EAP: EAP entering state IDENTITY
> 1291215721.999065: CTRL-EVENT-EAP-STARTED EAP authentication started
> 1291215721.999087: EAP: EAP-Request Identity data - hexdump_ascii(len=40):
> 1291215721.999159: EAP: using real identity - hexdump_ascii(len=15):
> 1291215721.999198: EAP: EAP entering state SEND_RESPONSE
> 1291215721.999220: EAP: EAP entering state IDLE
> 1291215721.999267: EAPOL: SUPP_BE entering state RESPONSE
> 1291215721.999290: EAPOL: txSuppRsp
> 1291215721.999318: TX EAPOL: dst=00:26:cb:xx:xx:xx
> 1291215721.999361: EAPOL: SUPP_BE entering state RECEIVE
> 1291215721.999411: nl80211: Event message available
> 1291215721.999463: nl80211: Ignore connect event (cmd=46) when using userspace SME
> 1291215721.999511: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1291215721.999551: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1291215721.999588: Event 5 received on interface wlan0
> 1291215721.999627: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1291215721.999665: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1291215721.999698: Event 5 received on interface wlan0
> 1291215721.999741: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1291215721.999779: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1291215721.999813: Event 5 received on interface wlan0
> 1291215722.007464: nl80211: Event message available
> 1291215722.007565: nl80211: Regulatory domain change
> 1291215722.007610: Event 30 received on interface wlan0
> 1291215725.001681: EAPOL: startWhen --> 0
> 1291215752.024711: EAPOL: authWhile --> 0
> 1291215752.024808: EAPOL: SUPP_BE entering state TIMEOUT

After the timeout wpa_supplicant restarts with an "EAPOL START" packet
and everything works cleanly.

I tried to shortcircuit the if in
net/mac80211/tx.c:1914ff
>         if (!ieee80211_vif_is_mesh(&sdata->vif) &&
>                 unlikely(!is_multicast_ether_addr(hdr.addr1) &&
>                       !(sta_flags & WLAN_STA_AUTHORIZED) &&
>                       !(cpu_to_be16(ethertype) == sdata->control_port_protocol &&
>                        compare_ether_addr(sdata->vif.addr,
>                                           skb->data + ETH_ALEN) == 0))) {
but that didn't help.

With kind regards,
Wolfgang Breyha
University of Vienna

