Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:48000 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbYCWNEI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 09:04:08 -0400
Received: from [192.168.2.253] (Bas.steadydecline.net [192.168.2.253])
	by steady.steadydecline.net (8.14.2/8.14.2) with ESMTP id m2ND41o4019096
	for <linux-wireless@vger.kernel.org>; Sun, 23 Mar 2008 14:04:02 +0100
Subject: Re: hostapd with mac80211 and rt2500pci: hostapd doesn't receive
	clients EAPOL keys unless mon.wlan1 is promiscuous
From: Bas Hulsken <bhulsken@hotmail.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1206274341.16475.185.camel@johannes.berg>
References: <1206271458.2902.27.camel@Bas>
	 (sfid-20080323_113430_380950_98BCE00E)  <1206274341.16475.185.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 14:00:37 +0100
Message-Id: <1206277237.2902.37.camel@Bas> (sfid-20080323_130412_759147_8F638168)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Sun, 2008-03-23 at 13:12 +0100, Johannes Berg wrote:
> > Ok, to summarize: hostapd doesn't seem to work at the moment with
> > rt2500pci and lates git.wireless-testing. The cause seems to be that
> > EOPOL key send from the client does not arrive at hostapd. This can be
> > 'fixed' by running tethereal on the monitor interface. Any thoughts on
> > what might cause this?
> 
> Can you stick a printk into the driver to print out
>  * the configured MAC address
>  * the filter flags configuration?
> 
> Whenever either changes.
before I blow up the system, I guess this should do the trick?
(remember, I'm not a kernel hacker ;-):

--- compat-wireless-2.6/drivers/net/wireless/rt2x00/rt2500pci.c 2008-03-12 09:49:21.000000000 +0100
+++ ./rt2500pci.c       2008-03-23 13:52:55.000000000 +0100
@@ -300,10 +300,11 @@
                rt2x00pci_register_write(rt2x00dev, CSR14, reg);
        }

-       if (flags & CONFIG_UPDATE_MAC)
+       if (flags & CONFIG_UPDATE_MAC) {
                rt2x00pci_register_multiwrite(rt2x00dev, CSR3,
                                              conf->mac, sizeof(conf->mac));
-
+    printk(KERN_INFO "rt2500pci MAC changed: %s\n", mac2str(conf->mac));
+       }
        if (flags & CONFIG_UPDATE_BSSID)
                rt2x00pci_register_multiwrite(rt2x00dev, CSR5,
                                              conf->bssid, sizeof(conf->bssid));
@@ -1767,6 +1768,7 @@
                return;
        rt2x00dev->packet_filter = *total_flags;

+  printk(KERN_INFO "rt2500pci filter_flags: %d\n", rt2x00dev->packet_filter);
        /*
         * Start configuration steps.
         * Note that the version error will always be dropped


> johannes

oh.. btw, I also had to patch hostapd a bit.. it seemed trivial, but
perhaps I'm just stupid. It seems that the NL80211_STA_STAT_* stuff in
current wireless-testing has been renamed to NL80211_STA_INFO_*, so I
renamed all occurrences of that in driver_nl80211.c. Was that ok? This
is the patch I applied:
--- hostap/hostapd/driver_nl80211.c     2008-03-18 13:53:20.000000000 +0100
+++ ./driver_nl80211.c  2008-03-22 17:28:39.000000000 +0100
@@ -598,11 +598,11 @@
        struct nlattr *tb[NL80211_ATTR_MAX + 1];
        struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
        struct hostap_sta_driver_data *data = arg;
-       struct nlattr *stats[NL80211_STA_STAT_MAX + 1];
-       static struct nla_policy stats_policy[NL80211_STA_STAT_MAX + 1] = {
-               [NL80211_STA_STAT_INACTIVE_TIME] = { .type = NLA_U32 },
-               [NL80211_STA_STAT_RX_BYTES] = { .type = NLA_U32 },
-               [NL80211_STA_STAT_TX_BYTES] = { .type = NLA_U32 },
+       struct nlattr *stats[NL80211_STA_INFO_MAX + 1];
+       static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] = {
+               [NL80211_STA_INFO_INACTIVE_TIME] = { .type = NLA_U32 },
+               [NL80211_STA_INFO_RX_BYTES] = { .type = NLA_U32 },
+               [NL80211_STA_INFO_TX_BYTES] = { .type = NLA_U32 },
        };

        nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
@@ -614,24 +614,24 @@
         * the kernel starts sending station notifications.
         */

-       if (!tb[NL80211_ATTR_STA_STATS]) {
+       if (!tb[NL80211_ATTR_STA_INFO]) {
                wpa_printf(MSG_DEBUG, "sta stats missing!");
                return NL_SKIP;
        }
-       if (nla_parse_nested(stats, NL80211_STA_STAT_MAX,
-                            tb[NL80211_ATTR_STA_STATS],
+       if (nla_parse_nested(stats, NL80211_STA_INFO_MAX,
+                            tb[NL80211_ATTR_STA_INFO],
                             stats_policy)) {
                wpa_printf(MSG_DEBUG, "failed to parse nested attributes!");
                return NL_SKIP;
        }

-       if (stats[NL80211_STA_STAT_INACTIVE_TIME])
+       if (stats[NL80211_STA_INFO_INACTIVE_TIME])
                data->inactive_msec =
-                       nla_get_u32(stats[NL80211_STA_STAT_INACTIVE_TIME]);
-       if (stats[NL80211_STA_STAT_RX_BYTES])
-               data->rx_bytes = nla_get_u32(stats[NL80211_STA_STAT_RX_BYTES]);
-       if (stats[NL80211_STA_STAT_TX_BYTES])
-               data->rx_bytes = nla_get_u32(stats[NL80211_STA_STAT_TX_BYTES]);
+                       nla_get_u32(stats[NL80211_STA_INFO_INACTIVE_TIME]);
+       if (stats[NL80211_STA_INFO_RX_BYTES])
+               data->rx_bytes = nla_get_u32(stats[NL80211_STA_INFO_RX_BYTES]);
+       if (stats[NL80211_STA_INFO_TX_BYTES])
+               data->rx_bytes = nla_get_u32(stats[NL80211_STA_INFO_TX_BYTES]);

        return NL_SKIP;
 }


cheers,
Bas


