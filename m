Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40632 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753967AbdEQNMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:12:35 -0400
Message-ID: <1495026753.2442.7.camel@sipsolutions.net> (sfid-20170517_151249_971326_7F79FBB3)
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org
Cc: Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Wed, 17 May 2017 15:12:33 +0200
In-Reply-To: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good job :)

Let's merge this - the tiny fixes for things I found can come later.

Some (mostly trivial) comments:

 * I'm surprised you don't support WEP - nice :)
 * I don't think returning -EFAULT from qtnf_add_virtual_intf is a good
   idea - perhaps better propagate the error or use -EIO?
 * the forward declaration of struct bus in pearl/pcie_bus_priv.h seems unnecessary
 * you might want to use a whitelist in qtnf_set_wiphy_params(), but
   it's not really important as we should add capability bits for
   everything that we add
 * qtnf_mgmt_frame_register()/cfg80211_rx_mgmt() aren't used correctly
   - since there's filtering further than the frame type/subtype, you
   need to check the return value of cfg80211_rx_mgmt(). If, for
   example, userspace only registers for a certain action frame
   category, you need to still reject the remaining ones yourself. We
   could extend the API here to give you the whole filter data as well,
   if that helps. Otherwise you need to handle the return value from
   cfg80211_rx_mgmt().
 * The ENOENT handling in qtnf_dump_station() surprises me, especially
   since there's no checking that this doesn't result in duplicate
   cfg80211_del_sta() calls due to races - if
   qtnf_event_handle_sta_deauth() wins to remove it with
   qtnf_sta_list_del() but qtnf_dump_station() already had it looked
   up? Seems like the whole handling in that function either needs to
   be the same as in the event, or just be removed and return -ENOENT
 * There seems to be little point in dynamically allocating the
   iface_comb in qtnf_wiphy_register() vs. just embedding it in struct
   qtnf_wmac or so?
 * qtnf_rx_frame() is declared but not used?
 * -D__CHECK_ENDIAN was always wrong, it should be -D__CHECK_ENDIAN__,
   but it's now also enabled by default so can be removed
 * I'm not sure there's much point in printing the failure code address
   (which should be static) in pr_err("skb DMA mapping error: %pad\n",
   &skb_paddr);
 * I like the real use of NAPI :)
 * However, is there any specific reason you're not using
   napi_gro_receive() rather than netif_receive_skb()? It seems using
   GRO would help TCP streams, in particular by reducing the number of
   ACKs
 * with just a single (PCI-E) transport, I'm not sure I see much point
   in splitting it into a separate module, which necessitates the
   EXPORT_SYMBOL_GPL, which do take up a bit of space. But there are
   only 4, so it doesn't really matter :) One thing we did in iwlwifi
   was to not export if both are built-in, since nobody else should
   ever have any reason to access them.

Thanks all!

johannes
