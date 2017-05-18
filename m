Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0063.outbound.protection.outlook.com ([104.47.41.63]:21790
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751155AbdERUI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 16:08:29 -0400
Date: Thu, 18 May 2017 23:08:13 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <igor.mitsyanko.os@quantenna.com>,
        <linux-wireless@vger.kernel.org>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v6] qtnfmac: introduce new FullMAC driver for Quantenna
 chipsets
Message-ID: <20170518200810.pch7tivugqyjmy4d@bars> (sfid-20170518_220834_688074_38A6DC9D)
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
 <1495026753.2442.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1495026753.2442.7.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello Johannes,

On Wed, May 17, 2017 at 03:12:33PM +0200, Johannes Berg wrote:
> Good job :)
> 
> Let's merge this - the tiny fixes for things I found can come later.
> 
> Some (mostly trivial) comments:
> 
>  * I'm surprised you don't support WEP - nice :)
>  * I don't think returning -EFAULT from qtnf_add_virtual_intf is a good
>    idea - perhaps better propagate the error or use -EIO?
>  * the forward declaration of struct bus in pearl/pcie_bus_priv.h seems unnecessary
>  * you might want to use a whitelist in qtnf_set_wiphy_params(), but
>    it's not really important as we should add capability bits for
>    everything that we add
>  * qtnf_mgmt_frame_register()/cfg80211_rx_mgmt() aren't used correctly
>    - since there's filtering further than the frame type/subtype, you
>    need to check the return value of cfg80211_rx_mgmt(). If, for
>    example, userspace only registers for a certain action frame
>    category, you need to still reject the remaining ones yourself. We
>    could extend the API here to give you the whole filter data as well,
>    if that helps. Otherwise you need to handle the return value from
>    cfg80211_rx_mgmt().
>  * The ENOENT handling in qtnf_dump_station() surprises me, especially
>    since there's no checking that this doesn't result in duplicate
>    cfg80211_del_sta() calls due to races - if
>    qtnf_event_handle_sta_deauth() wins to remove it with
>    qtnf_sta_list_del() but qtnf_dump_station() already had it looked
>    up? Seems like the whole handling in that function either needs to
>    be the same as in the event, or just be removed and return -ENOENT
>  * There seems to be little point in dynamically allocating the
>    iface_comb in qtnf_wiphy_register() vs. just embedding it in struct
>    qtnf_wmac or so?
>  * qtnf_rx_frame() is declared but not used?
>  * -D__CHECK_ENDIAN was always wrong, it should be -D__CHECK_ENDIAN__,
>    but it's now also enabled by default so can be removed
>  * I'm not sure there's much point in printing the failure code address
>    (which should be static) in pr_err("skb DMA mapping error: %pad\n",
>    &skb_paddr);
>  * I like the real use of NAPI :)
>  * However, is there any specific reason you're not using
>    napi_gro_receive() rather than netif_receive_skb()? It seems using
>    GRO would help TCP streams, in particular by reducing the number of
>    ACKs

Thanks for the review ! Fixes will be queued to the upcoming patches with
various cleanups as well as new features.

>  * with just a single (PCI-E) transport, I'm not sure I see much point
>    in splitting it into a separate module, which necessitates the
>    EXPORT_SYMBOL_GPL, which do take up a bit of space. But there are
>    only 4, so it doesn't really matter :) One thing we did in iwlwifi
>    was to not export if both are built-in, since nobody else should
>    ever have any reason to access them.

The split was implementened in order to accommodate various bus drivers
supporting different hardware. We already have initial implementation of
another PCIe bus driver for previous generation SoC. That hardware is
different enough to justify a separate bus driver.

BTW, speaking about other backends... During previous reviews of this
patch we had a question regarding possible support of another previous
generation SoC connected to host CPU via RGMII interface. Is there any
legitimate (aka 'upstreamable') way to support such wireless cards ?

Thanks,
Sergey
