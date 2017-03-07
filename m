Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0049.outbound.protection.outlook.com ([104.47.32.49]:62912
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755056AbdCGKyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:54:10 -0500
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        <linux-wireless@vger.kernel.org>
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <8d5ec058-f08f-f09c-7172-649e61c2f87b@gmail.com>
CC: <johannes@sipsolutions.net>, <btherthala@quantenna.com>,
        <hwang@quantenna.com>, <smaksimenko@quantenna.com>,
        <dlebed@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <f811f8df-b887-bf71-e89f-c0b11fdcf95e@quantenna.com> (sfid-20170307_115529_705472_533A1D83)
Date: Tue, 7 Mar 2017 13:17:28 +0300
MIME-Version: 1.0
In-Reply-To: <8d5ec058-f08f-f09c-7172-649e61c2f87b@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2017 12:25 AM, Rafał Miłecki wrote:
>
> External Email
>
>
> Two more comments. Please note I don't find these things critical, this
> would be
> fine to fix them in incremental patch for me.
>
> On 01/09/2017 10:07 AM, igor.mitsyanko.os@quantenna.com wrote:
>> +static int qtnf_core_mac_init(struct qtnf_bus *bus, int macid)
>> +{
>> +    struct qtnf_wmac *mac;
>> +    struct qtnf_vif *vif;
>> +
>> +    pr_debug("starting mac(%d) init\n", macid);
>> +
>> +    if (!(bus->hw_info.mac_bitmap & BIT(macid))) {
>> +            pr_info("mac(%d) is not available for host operations\n",
>> +                    macid);
>> +            return 0;
>> +    }
>> +
>> +    mac = qtnf_mac_init(bus, macid);
>> +    if (!mac) {
>> +            pr_err("failed to initialize mac(%d)\n", macid);
>> +            return -1;
>> +    }
>> +
>> +    if (qtnf_cmd_get_mac_info(mac)) {
>> +            pr_err("failed to get mac(%d) info\n", macid);
>> +            return -1;
>> +    }
>> +
>> +    vif = qtnf_get_base_vif(mac);
>> +    if (!vif) {
>> +            pr_err("could not get valid vif pointer\n");
>> +            return -1;
>> +    }
>> +
>> +    if (qtnf_cmd_send_add_intf(vif, NL80211_IFTYPE_AP, vif->mac_addr)) {
>> +            pr_err("could not add primary vif for mac(%d)\n", macid);
>> +            return -1;
>> +    }
>> +
>> +    if (qtnf_cmd_send_get_phy_params(mac)) {
>> +            pr_err("could not get phy thresholds for mac(%d)\n", macid);
>> +            return -1;
>> +    }
>> +
>> +    if (qtnf_mac_init_bands(mac)) {
>> +            pr_err("could not get channel info for mac(%d)\n", macid);
>> +            return -1;
>> +    }
>> +
>> +    if (qtnf_register_wiphy(bus, mac)) {
>> +            pr_err("wiphy registration failed for mac(%d)\n", macid);
>> +            return -1;
>> +    }
>> +
>> +    mac->wiphy_registered = 1;
>> +
>> +    /* add primary networking interface */
>> +    rtnl_lock();
>> +    if (qtnf_net_attach(mac, vif, "wlan%d", NET_NAME_ENUM,
>> +                        NL80211_IFTYPE_AP)) {
>> +            pr_err("could not attach primary interface for mac(%d)\n",
>> +                   macid);
>> +            vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
>> +            vif->netdev = NULL;
>> +            rtnl_unlock();
>> +            return -1;
>> +    }
>> +    rtnl_unlock();
>> +
>> +    return 0;
>> +}
>
> You could have more original error codes in qtnf_core_mac_init ;)

Will look into making those more diverse)

>
>
>> (...)
>> +void qtnf_core_detach(struct qtnf_bus *bus)
>> +{
>> +    struct wiphy *wiphy;
>> +    struct qtnf_wmac *mac;
>> +    struct qtnf_vif *vif;
>> +    int i, cnt;
>> +    enum nl80211_band band;
>> +
>> +    for (cnt = 0; cnt < QTNF_MAX_MAC; cnt++) {
>> +            mac = bus->mac[cnt];
>> +
>> +            if (!mac || !mac->mac_started)
>> +                    continue;
>
> I think I'd put all following cfg80211 code in cfg80211.c. This would match
> qtnf_register_wiphy you have in that file.

I see what you mean, will change.

>
>> +            wiphy = priv_to_wiphy(mac);
>> +
>> +            for (i = 0; i < QTNF_MAX_INTF; i++) {
>> +                    vif = &mac->iflist[i];
>> +                    rtnl_lock();
>> +                    if (vif->netdev &&
>> +                        vif->wdev.iftype !=
> NL80211_IFTYPE_UNSPECIFIED) {
>> +                            qtnf_virtual_intf_cleanup(vif->netdev);
>> +                            qtnf_del_virtual_intf(wiphy, &vif->wdev);
>> +                    }
>> +                    rtnl_unlock();
>> +                    qtnf_sta_list_free(&vif->sta_list);
>> +            }
>> +
>> +            if (mac->wiphy_registered)
>> +                    wiphy_unregister(wiphy);
>> +
>> +            for (band = NL80211_BAND_2GHZ;
>> +                 band < NUM_NL80211_BANDS; ++band) {
>> +                    if (!wiphy->bands[band])
>> +                            continue;
>> +
>> +                    kfree(wiphy->bands[band]->channels);
>> +                    wiphy->bands[band]->n_channels = 0;
>> +
>> +                    kfree(wiphy->bands[band]);
>> +                    wiphy->bands[band] = NULL;
>> +            }
>> +
>> +            kfree(mac->macinfo.limits);
>> +            kfree(wiphy->iface_combinations);
>> +            wiphy_free(wiphy);
>> +            bus->mac[cnt] = NULL;
>> +    }
>> +
>> +    if (bus->workqueue) {
>> +            flush_workqueue(bus->workqueue);
>> +            destroy_workqueue(bus->workqueue);
>> +    }
>> +
>> +    qtnf_trans_free(bus);
>> +}
>> +EXPORT_SYMBOL_GPL(qtnf_core_detach);
