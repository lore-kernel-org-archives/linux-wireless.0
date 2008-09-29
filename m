Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:38422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYI2Lwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 07:52:45 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1406691fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 04:52:41 -0700 (PDT)
Message-ID: <48E0C185.6070705@gmail.com> (sfid-20080929_135248_018757_5E98C4D9)
Date: Mon, 29 Sep 2008 13:52:37 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
References: <48E0A65A.2060102@gmail.com>	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu> <1222683923.7064.18.camel@johannes.berg>
In-Reply-To: <1222683923.7064.18.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2008 12:25 PM, Johannes Berg wrote:
> Jiri, can you tell me what happens with iw? iw phy phy0 info or
> something.

Well, with this patch:
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1221d72..98fd93a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -246,16 +246,26 @@ static int nl80211_get_wiphy(struct sk_buff *skb, struct
genl_info *info)
 {
        struct sk_buff *msg;
        struct cfg80211_registered_device *dev;
+       size_t bufsize = NLMSG_GOODSIZE;
+       unsigned int tries = 0;
+       int ret;

        dev = cfg80211_get_dev_from_info(info);
        if (IS_ERR(dev))
                return PTR_ERR(dev);

-       msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+retry:
+       msg = nlmsg_new(bufsize, GFP_KERNEL);
        if (!msg)
                goto out_err;

-       if (nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev) < 0)
+       ret = nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev);
+       if (ret == -EMSGSIZE && ++tries < 2) {
+               bufsize *= 2;
+               nlmsg_free(msg);
+               goto retry;
+       }
+       if (ret < 0)
                goto out_free;

        cfg80211_put_dev(dev);

-----8<----------------8<----------------8<----------------8<-----

I get:
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz (passive scanning, no IBSS)
                        * 2417 MHz (passive scanning, no IBSS)
                        * 2422 MHz (passive scanning, no IBSS)
                        * 2427 MHz (passive scanning, no IBSS)
                        * 2432 MHz (passive scanning, no IBSS)
                        * 2437 MHz (passive scanning, no IBSS)
                        * 2442 MHz (passive scanning, no IBSS)
                        * 2447 MHz (passive scanning, no IBSS)
                        * 2452 MHz (passive scanning, no IBSS)
                        * 2457 MHz (passive scanning, no IBSS)
                        * 2462 MHz (passive scanning, no IBSS)
                        * 2467 MHz (disabled)
                        * 2472 MHz (disabled)
                        * 2484 MHz (disabled)
                        * 2512 MHz (disabled)
                        * 2532 MHz (disabled)
                        * 2552 MHz (disabled)
                        * 2572 MHz (disabled)
                        * 2592 MHz (disabled)
                        * 2612 MHz (disabled)
                        * 2632 MHz (disabled)
                        * 2652 MHz (disabled)
                        * 2672 MHz (disabled)
                        * 2692 MHz (disabled)
                        * 2712 MHz (disabled)
                        * 2732 MHz (disabled)
                Bitrates:
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Band 2:
                Frequencies:
                        * 5135 MHz (disabled)
                        * 5140 MHz (disabled)
                        * 5145 MHz (disabled)
                        * 5150 MHz (disabled)
                        * 5155 MHz (disabled)
                        * 5160 MHz (disabled)
                        * 5165 MHz (disabled)
                        * 5170 MHz (disabled)
                        * 5175 MHz (disabled)
                        * 5180 MHz (disabled)
                        * 5185 MHz (disabled)
                        * 5190 MHz (disabled)
                        * 5195 MHz (disabled)
                        * 5200 MHz (disabled)
                        * 5205 MHz (disabled)
                        * 5210 MHz (disabled)
                        * 5215 MHz (disabled)
                        * 5220 MHz (disabled)
                        * 5225 MHz (disabled)
                        * 5230 MHz (disabled)
                        * 5235 MHz (disabled)
                        * 5240 MHz (disabled)
                        * 5245 MHz (disabled)
                        * 5250 MHz (disabled)
                        * 5255 MHz (disabled)
                        * 5260 MHz (disabled)
                        * 5265 MHz (disabled)
                        * 5270 MHz (disabled)
                        * 5275 MHz (disabled)
                        * 5280 MHz (disabled)
                        * 5285 MHz (disabled)
                        * 5290 MHz (disabled)
                        * 5295 MHz (disabled)
                        * 5300 MHz (disabled)
                        * 5305 MHz (disabled)
                        * 5310 MHz (disabled)
                        * 5315 MHz (disabled)
                        * 5320 MHz (disabled)
                        * 5325 MHz (disabled)
                        * 5330 MHz (disabled)
                        * 5335 MHz (disabled)
                        * 5340 MHz (disabled)
                        * 5345 MHz (disabled)
                        * 5350 MHz (disabled)
                        * 5355 MHz (disabled)
                        * 5360 MHz (disabled)
                        * 5365 MHz (disabled)
                        * 5370 MHz (disabled)
                        * 5375 MHz (disabled)
                        * 5380 MHz (disabled)
                        * 5385 MHz (disabled)
                        * 5390 MHz (disabled)
                        * 5395 MHz (disabled)
                        * 5400 MHz (disabled)
                        * 5405 MHz (disabled)
                        * 5410 MHz (disabled)
                        * 5415 MHz (disabled)
                        * 5420 MHz (disabled)
                        * 5425 MHz (disabled)
                        * 5430 MHz (disabled)
                        * 5435 MHz (disabled)
                        * 5440 MHz (disabled)
                        * 5445 MHz (disabled)
                        * 5450 MHz (disabled)
                        * 5455 MHz (disabled)
                        * 5460 MHz (disabled)
                        * 5465 MHz (disabled)
                        * 5470 MHz (disabled)
                        * 5475 MHz (disabled)
                        * 5480 MHz (disabled)
                        * 5485 MHz (disabled)
                        * 5490 MHz (disabled)
                        * 5495 MHz (disabled)
                        * 5500 MHz (disabled)
                        * 5505 MHz (disabled)
                        * 5510 MHz (disabled)
                        * 5515 MHz (disabled)
                        * 5520 MHz (disabled)
                        * 5525 MHz (disabled)
                        * 5530 MHz (disabled)
                        * 5535 MHz (disabled)
                        * 5540 MHz (disabled)
                        * 5545 MHz (disabled)
                        * 5550 MHz (disabled)
                        * 5555 MHz (disabled)
                        * 5560 MHz (disabled)
                        * 5565 MHz (disabled)
                        * 5570 MHz (disabled)
                        * 5575 MHz (disabled)
                        * 5580 MHz (disabled)
                        * 5585 MHz (disabled)
                        * 5590 MHz (disabled)
                        * 5595 MHz (disabled)
                        * 5600 MHz (disabled)
                        * 5605 MHz (disabled)
                        * 5610 MHz (disabled)
                        * 5615 MHz (disabled)
                        * 5620 MHz (disabled)
                        * 5625 MHz (disabled)
                        * 5630 MHz (disabled)
                        * 5635 MHz (disabled)
                        * 5640 MHz (disabled)
                        * 5645 MHz (disabled)
                        * 5650 MHz (disabled)
                        * 5655 MHz (disabled)
                        * 5660 MHz (disabled)
                        * 5665 MHz (disabled)
                        * 5670 MHz (disabled)
                        * 5675 MHz (disabled)
                        * 5680 MHz (disabled)
                        * 5685 MHz (disabled)
                        * 5690 MHz (disabled)
                        * 5695 MHz (disabled)
                        * 5700 MHz (disabled)
                        * 5705 MHz (disabled)
                        * 5710 MHz (disabled)
                        * 5715 MHz (disabled)
                        * 5720 MHz (disabled)
                        * 5725 MHz (disabled)
                        * 5730 MHz (disabled)
                        * 5735 MHz (disabled)
                        * 5740 MHz (disabled)
                        * 5745 MHz (disabled)
                        * 5750 MHz (disabled)
                        * 5755 MHz (disabled)
                        * 5760 MHz (disabled)
                        * 5765 MHz (disabled)
                        * 5770 MHz (disabled)
                        * 5775 MHz (disabled)
                        * 5780 MHz (disabled)
                        * 5785 MHz (disabled)
                        * 5790 MHz (disabled)
                        * 5795 MHz (disabled)
                        * 5800 MHz (disabled)
                        * 5805 MHz (disabled)
                        * 5810 MHz (disabled)
                        * 5815 MHz (disabled)
                        * 5820 MHz (disabled)
                        * 5825 MHz (disabled)
                        * 5830 MHz (disabled)
                        * 5835 MHz (disabled)
                        * 5840 MHz (disabled)
                        * 5845 MHz (disabled)
                        * 5850 MHz (disabled)
                        * 5855 MHz (disabled)
                        * 5860 MHz (disabled)
                        * 5865 MHz (disabled)
                        * 5870 MHz (disabled)
                        * 5875 MHz (disabled)
                        * 5880 MHz (disabled)
                        * 5885 MHz (disabled)
                        * 5890 MHz (disabled)
                        * 5895 MHz (disabled)
                        * 5900 MHz (disabled)
                        * 5905 MHz (disabled)
                        * 5910 MHz (disabled)
                        * 5915 MHz (disabled)
                        * 5920 MHz (disabled)
                        * 5925 MHz (disabled)
                        * 5930 MHz (disabled)
                        * 5935 MHz (disabled)
                        * 5940 MHz (disabled)
                        * 5945 MHz (disabled)
                        * 5950 MHz (disabled)
                        * 5955 MHz (disabled)
                        * 5960 MHz (disabled)
                        * 5965 MHz (disabled)
                        * 5970 MHz (disabled)
                        * 5975 MHz (disabled)
                        * 5980 MHz (disabled)
                        * 5985 MHz (disabled)
                        * 5990 MHz (disabled)
                        * 5995 MHz (disabled)
                        * 6000 MHz (disabled)
                        * 6005 MHz (disabled)
                        * 6010 MHz (disabled)
                        * 6015 MHz (disabled)
                        * 6020 MHz (disabled)
                        * 6025 MHz (disabled)
                        * 6030 MHz (disabled)
                        * 6035 MHz (disabled)
                        * 6040 MHz (disabled)
                        * 6045 MHz (disabled)
                        * 6050 MHz (disabled)
                        * 6055 MHz (disabled)
                        * 6060 MHz (disabled)
                        * 6065 MHz (disabled)
                        * 6070 MHz (disabled)
                        * 6075 MHz (disabled)
                        * 6080 MHz (disabled)
                        * 6085 MHz (disabled)
                        * 6090 MHz (disabled)
                        * 6095 MHz (disabled)
                        * 6100 MHz (disabled)
                Bitrates:
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Supported interface modes:
                 * IBSS
                 * Station
                 * AP
                 * AP(VLAN)
                 * Monitor
                 * mesh point

