Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:24149 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2JONYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 09:24:16 -0400
From: Krishnan Manivannan <krishnan.manivannan@sasken.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 15 Oct 2012 18:54:12 +0530
Subject: RE: Receive all data packets in Managed mode
Message-ID: <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DC0@EXGMBX01.sasken.com> (sfid-20121015_152420_292276_8647D6F6)
References: <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DBA@EXGMBX01.sasken.com>,<201210131055.46279.chunkeey@googlemail.com>
In-Reply-To: <201210131055.46279.chunkeey@googlemail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian

I tried the patch you hadd mentioned, but still Iam unable to receive data packets sent by other stations in managed mode.
wifi device: TP-LINK (TL-WN822N)
Am I missing something?

>Just to be clear, do you want to get these frames on the same
>interface? And do you want the converted 802.3 or are "real"
>802.11 frames that go over the air good enough (if so, please
>read on!)?

Yes, we want these frames on the same interface.

> please be advised, that the hardware sniffer mode is more some sort
>of debug operation. And that with the current kernel code
>you might experience some interference trouble if you
>use carl9170 as a pure monitor. In this case you want
>to apply the following patch.

https://patchwork.kernel.org/patch/1439881/
I tried this patch, but still we are unable to receive data packets sent by other stations.


> @@ -343,7 +343,24 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
>                       break;
>               }
>       } else {

It seems, THIS GETS CALLED WHEN THE INTERFACE IS REMOVED,
THEN HOW ITS USED TO DISABLE FILTERING?

> -             mac_addr = NULL;
> +             /*
> +              * Enable monitor mode
> +              *
> +              * rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> +              * sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
> +              *
> +              * When the hardware is in SNIFFER_PROMISC mode,
> +              * it generates spurious ACKs for every incoming
> +              * frame. This confuses every peer in the
> +              * vicinity and the network throughput will suffer
> +              * badly.
> +              *
> +              * Hence, the hardware will be put into station
> +              * mode and just the rx filters are disabled.
> +              */
> +             cam_mode |= AR9170_MAC_CAM_STA;
> +             rx_ctrl |= AR9170_MAC_RX_CTRL_PASS_TO_HOST;
> +             mac_addr = common->macaddr;
>               bssid = NULL;
>       }
>       rcu_read_unlock();
> @@ -355,8 +372,6 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
>               enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
>
>       if (ar->sniffer_enabled) {

It seems,
THIS IS TO REMOVE ACK SENT IN MONITOR MODE

> -             rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
> -             sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
>               enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
>       }
>


Thanks & Regards
Mani


___________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Christian Lamparter [chunkeey@googlemail.com]
Sent: Saturday, October 13, 2012 2:25 PM
To: Krishnan Manivannan
Cc: linux-wireless@vger.kernel.org
Subject: Re: Receive all data packets in Managed mode

On Saturday 13 October 2012 07:51:59 Krishnan Manivannan wrote:
> The VIF is in 'Managed mode' we want to receive data packets
> of other stations destined to a DS, and get it in the MAC
> reveive path.
Just to be clear, do you want to get these frames on the same
interface? And do you want the converted 802.3 or are "real"
802.11 frames that go over the air good enough (if so, please
read on!)?

> For example, In monitor mode, the VIF receives all packets, by
> sniffing in the medium & allows all packets of other stations
> being sent to AP, and deliver it to the upper layers. We want
> to receive all packets(of other Destination address) in
> managed mode.
You can do that with carl9170 (and in fact it should work with
all other mac80211 drivers too). What you want is an additional
monitor interface:
<http://wireless.kernel.org/en/users/Documentation/iw#Adding_interfaces_with_iw>

With it, you can receive and inject 802.11 frames without
worrying too much about filters and carl9170/mac80211
internals.

# iw dev wlanX interface add moni0 type monitor flags none
# ifconfig moni0 up
And then start your favorite sniffer (wireshark, or whatever
you want to use).

> Is it possible to sniff packets in Managed mode. where in data
> packets sent by other stations are also received?
If the solution above suits your needs, then the answer is YES.
You don't need to modify the firmware. However, please be
advised, that the hardware sniffer mode is more some sort
of debug operation. And that with the current kernel code
you might experience some interference trouble if you
use carl9170 as a pure monitor. In this case you want
to apply the following patch.
https://patchwork.kernel.org/patch/1439881/

But you don't need it, if you are going with the
station/managed interface + monitor interface stuff
(the solution above).

> Although I tried couple of things in Firmware & Carl9170, I coudn't  achieve the result.
> 1.In ::carlfw/usb/main.c,
>    void handle_usb(void)
> ++   set(AR9170_MAC_REG_SNIFFER, 1);   //added this line to enable sniffing in Managed mode
>
> 2. In ::carlfw/src/wlanrx.c
>     void handle_wlan_rx(void)
>   -- if (!(wlan_rx_filter(desc) & fw.wlan.rx_filter))   //changed this line to
>   ++ if( 1 )
>
>
> In carl9170 module, source code,
>   In fine mac.c
>   int carl9170_set_operating_mode(struct ar9170 *ar)
>   -- carl9170_regwrite(AR9170_MAC_REG_SNIFFER, sniffer);
>   ++ carl9170_regwrite(AR9170_MAC_REG_SNIFFER, sniffer | AR9170_MAC_SNIFFER_ENABLE_PROMISC );
>
>
> In order to achieve this, what changes in firmware/ Carl9170 module needs to be done?
the AR9170 is a pretty simple 802.11 chip, it only does some
filtering (frames with bad FCS/checksums, bad length, ...).
Most of the complex filtering happens in net/mac80211/rx.c
(linux kernel).

Regards,
        Chr
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
