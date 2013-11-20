Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50229 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTIlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 03:41:49 -0500
Received: by mail-ie0-f178.google.com with SMTP id lx4so5131388iec.9
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 00:41:48 -0800 (PST)
MIME-Version: 1.0
From: Blaise Gassend <blaise@suitabletech.com>
Date: Wed, 20 Nov 2013 00:41:27 -0800
Message-ID: <CAPvVjisu-xcZsqHgcTEKsCJFuESDFO-_0KwkgxffyejemHJZcA@mail.gmail.com> (sfid-20131120_094152_985311_4DCD3B9E)
Subject: QoS Data packets causing massive packet loss in ieee80211_sta_manage_reorder_buf.
To: linux-wireless@vger.kernel.org
Cc: Catalin Drula <catalin@suitabletech.com>,
	"blaise@suitabletech.com" <blaise@suitabletech.com>,
	Alap Modi <amodi@arubanetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have been trying to debug massive packet loss that our product
experiences with recent Aruba access points. The basic symptoms are
that within a few seconds after you start sending significant data,
you start getting 100% RX loss. A few seconds later, RX recovers for a
few seconds before the cycle repeats. The higher the packet send rate,
the faster this cycle repeats.

I have been tracing the packets through the code, and it appears that
the loss happens in ieee80211_sta_manage_reorder_buf. It appears that
when there are broadcast QoS Data packets, their sequence numbers get
mixed with non-broadcast QoS Data sequence numbers causing out-of-date
sequence number conditions to get triggered spuriously.

As far as I can tell broadcast QoS Data packets coming from the AP are
pretty rare (the other networks I have access seem to use Data packets
for broadcast traffic from the AP), but are legal. So I'm suspecting
that the AP is behaving correctly, but is triggering a so-far rare bug
in mac80211.
But this problem is likely to become much more widespread if Aruba's
802.11ac firmware triggers it.

I'm not a deep 802.11 expert or a mac80211 so I could certainly use
some help here. I am putting the details I have gathered below, and
would love any suggestions/advice. Currently, my impression is that we
might need a special tid_rx for broadcast packets similar to the
special handling of broadcast packets in ieee80211_parse_qos.

Best regards,
Blaise


The condition that causes the loss is:

        /* frame with out of date sequence number */
        if (ieee80211_sn_less(mpdu_seq_num, head_seq_num)) {
                dev_kfree_skb(skb);
                goto out;
        }

Adding the following printk statements near the top

        printk("wlan: ieee80211_sta_manage_reorder_buf  %u %u %u\n",
skb->len, mpdu_seq_num, head_seq_num);

and bottom

out:
        printk("wlan: ieee80211_sta_manage_reorder_buf  end %u\n",
tid_agg_rx->head_seq_num);

of ieee80211_sta_manage_reorder_buf, I get the following output at the
time when loss starts (the comments were added manually):

Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  206 552 552
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  end 553
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  206 553 553
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  end 554
# The two packets above got through fine.
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  96 2551 554
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  end 2488
# The broadcast packet above causes the head_seq_num to jump to whatever
# the current broadcast sequence number is.
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  206 554 2488
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  end 2488
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  206 555 2488
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  end 2488
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  206 556 2488
Nov 19 21:55:29 localhost kernel: wlan:
ieee80211_sta_manage_reorder_buf  end 2488
# The three packets above are dropped. And there are plenty more drops
until sequence numbers wrap around.

The corresponding tshark output (I'd be happy to provide a pcap file
on demand, but I'm not sure what linux-wireless will accept) shows the
frames that were traced above, and a few others that aren't related to
my adapter.
17309   5.577576 JuniperN_99:37:0e -> Sparklan_47:57:16 802.11   250
QoS Data, SN=552, FN=0, Flags=.p....F.C
17310   5.577651 ArubaNet_f0:b7:56 (TA) -> Apple_31:89:b6 (RA) 802.11
 46 Request-to-send, Flags=........C
17311   5.579743 ArubaNet_ae:65:78 -> Broadcast    802.11   215 Beacon
frame, SN=1757, FN=0, Flags=........C, BI=100, SSID=workday-corp
17312   5.579790 ArubaNet_ae:65:79 -> Broadcast    802.11   209 Beacon
frame, SN=1757, FN=0, Flags=........C, BI=100, SSID=workday-guest
17313   5.579831 ArubaNet_ec:0d:f0 -> Broadcast    802.11   262 Beacon
frame, SN=397, FN=0, Flags=........C, BI=100, SSID=ethersphere-wpa2
17314   5.579885 ArubaNet_ec:0d:f1 -> Broadcast    802.11   237 Beacon
frame, SN=398, FN=0, Flags=........C, BI=100, SSID=ARUBA-VISITOR
17315   5.579934 IntelCor_bf:5f:f8 -> Broadcast    802.11   576 Data,
SN=399, FN=0, Flags=.p....F.C
17316   5.579952 ArubaNet_f0:b7:55 (TA) -> Sparklan_47:57:12 (RA)
802.11   46 Request-to-send, Flags=........C
17317   5.579968              -> ArubaNet_f0:b7:55 (RA) 802.11   40
Clear-to-send, Flags=........C
17318   5.579975              -> Sparklan_47:57:16 (RA) 802.11   40
Acknowledgement, Flags=........C
17319   5.579989 ArubaNet_f0:b7:55 (TA) -> Sparklan_47:57:12 (RA)
802.11   46 Request-to-send, Flags=........C
17320   5.579997              -> ArubaNet_f0:b7:55 (RA) 802.11   40
Clear-to-send, Flags=........C
17321   5.580016 Sparklan_47:57:16 -> JuniperN_99:37:0e 802.11   212
QoS Data, SN=909, FN=0, Flags=.p.....T
17322   5.581854 ArubaNet_f0:b7:55 (TA) -> Sparklan_47:57:12 (RA)
802.11   46 Request-to-send, Flags=........C
17323   5.581872              -> ArubaNet_f0:b7:55 (RA) 802.11   40
Clear-to-send, Flags=........C
17324   5.581881 JuniperN_99:37:0e -> Sparklan_47:57:12 802.11   140
QoS Data, SN=470, FN=0, Flags=.p..R.F.C
17325   5.581888 Sparklan_47:57:12 (TA) -> ArubaNet_f0:b7:55 (RA)
802.11   58 802.11 Block Ack, Flags=........C
17326   5.581893 ArubaNet_ae:61:28 -> Broadcast    802.11   314 Beacon
frame, SN=429, FN=0, Flags=........C, BI=100
17327   5.581935 ArubaNet_ae:61:2a -> Broadcast    802.11   269 Beacon
frame, SN=421, FN=0, Flags=........C, BI=100, SSID=employee200-8
17328   5.581967 ArubaNet_f0:b7:55 (TA) -> Sparklan_47:57:16 (RA)
802.11   46 Request-to-send, Flags=........C
17329   5.581974 JuniperN_99:37:0e -> Sparklan_47:57:16 802.11   250
QoS Data, SN=553, FN=0, Flags=.p....F.C
17330   5.582038 Sparklan_47:57:12 -> Broadcast    802.11   126 QoS
Data, SN=2551, FN=0, Flags=.p....F.C
17331   5.583623 ArubaNet_f0:b7:56 (TA) -> 84:38:35:5d:f2:aa (RA)
802.11   46 Request-to-send, Flags=........C
17332   5.583635 ArubaNet_f0:b7:56 (TA) -> Apple_31:74:f0 (RA) 802.11
 46 Request-to-send, Flags=........C
17333   5.584426              -> Sparklan_47:57:16 (RA) 802.11   40
Acknowledgement, Flags=........C
17334   5.584465 Sparklan_47:57:16 -> JuniperN_99:37:0e 802.11   212
QoS Data, SN=910, FN=0, Flags=.p.....T
17335   5.585022 ArubaNet_f0:b7:56 (TA) -> b8:e8:56:0a:4a:de (RA)
802.11   46 Request-to-send, Flags=........C
17336   5.587968              -> Apple_31:89:b6 (RA) 802.11   40
Clear-to-send, Flags=........C
17337   5.587984 ArubaNet_f0:b7:56 (TA) -> Apple_31:89:b6 (RA) 802.11
 58 802.11 Block Ack, Flags=........C
17338   5.587990              -> 84:38:35:5d:f2:aa (RA) 802.11   40
Clear-to-send, Flags=........C
17339   5.587993 ArubaNet_f0:b7:56 (TA) -> 84:38:35:5d:f2:aa (RA)
802.11   58 802.11 Block Ack, Flags=........C
17340   5.587997 ArubaNet_f0:b7:56 (TA) -> Apple_31:89:b6 (RA) 802.11
 46 Request-to-send, Flags=........C
17341   5.588001 ArubaNet_f0:b7:56 (TA) -> Apple_31:89:b6 (RA) 802.11
 46 Request-to-send, Flags=........C
17342   5.588004              -> ArubaNet_f0:b7:56 (RA) 802.11   40
Clear-to-send, Flags=........C
17343   5.589312 ArubaNet_f0:b7:55 (TA) -> Sparklan_47:57:16 (RA)
802.11   46 Request-to-send, Flags=........C
17344   5.589331              -> Sparklan_47:57:16 (RA) 802.11   40
Acknowledgement, Flags=........C
17345   5.589348 Sparklan_47:57:16 -> JuniperN_99:37:0e 802.11   212
QoS Data, SN=911, FN=0, Flags=.p.....T
17346   5.590768              -> Apple_31:89:b6 (RA) 802.11   40
Clear-to-send, Flags=........C
17347   5.590787 ArubaNet_f0:b7:56 (TA) -> Apple_31:89:b6 (RA) 802.11
 58 802.11 Block Ack, Flags=........C
17348   5.590794 ArubaNet_f0:b7:55 (TA) -> Sparklan_47:57:16 (RA)
802.11   46 Request-to-send, Flags=........C
17349   5.590805 JuniperN_99:37:0e -> Sparklan_47:57:16 802.11   250
QoS Data, SN=554, FN=0, Flags=.p..R.F.C
17350   5.590837 JuniperN_99:37:0e -> Sparklan_47:57:16 802.11   250
QoS Data, SN=555, FN=0, Flags=.p..R.F.C

Regards,
Blaise Gassend
