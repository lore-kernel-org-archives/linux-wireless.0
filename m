Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752672AbdLROBu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 09:01:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
        <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
        <871skalepz.fsf@purkki.adurom.net>
        <20171205160010.cytra3bqbttwz5db@bars>
Date: Mon, 18 Dec 2017 16:01:45 +0200
In-Reply-To: <20171205160010.cytra3bqbttwz5db@bars> (Sergey Matyukevich's
        message of "Tue, 5 Dec 2017 19:00:11 +0300")
Message-ID: <878te0kud2.fsf@kamboji.qca.qualcomm.com> (sfid-20171218_150154_536225_A574D9AF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle,
>
>> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>> 
>> > From: Vasily Ulyanov <vulyanov@quantenna.com>
>> >
>> > This allows a running AP to blacklist STAs by their MAC addresses
>> > respecting the configured policy (either accept or deny unless listed).
>> > It can be setup on .start_ap or with .set_mac_acl commands.
>> >
>> > Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
>> 
>> [...]
>> 
>> > @@ -918,6 +933,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
>> >       wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
>> >       wiphy->mgmt_stypes = qtnf_mgmt_stypes;
>> >       wiphy->max_remain_on_channel_duration = 5000;
>> > +     wiphy->max_acl_mac_addrs = mac->macinfo.max_acl_mac_addrs;
>> >
>> >       wiphy->iface_combinations = iface_comb;
>> >       wiphy->n_iface_combinations = 1;
>> > @@ -932,6 +948,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
>> >                       WIPHY_FLAG_AP_UAPSD |
>> >                       WIPHY_FLAG_HAS_CHANNEL_SWITCH;
>> >
>> > +     if (wiphy->max_acl_mac_addrs > 0)
>> > +             wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
>> 
>> Conditonally enabling WIPHY_FLAG_HAVE_AP_SME looks somewhat suspicious
>> to me and from a quick search I don't see any other driver doing
>> something similar. Can you explain why AP_SME is related to MAC ACL?
>
> Wireless core performs several sanity check on wiphy registration: see
> wiphy_register implementation in net/wireless/core.c. One of those
> checks is as follows: if max_acl_mac_addrs is non-zero, then two
> conditions should be fulfilled:
> - cfg80211 set_mac_acl callback should be available
> - WIPHY_FLAG_HAVE_AP_SME should be set
>
> The first condition is perfectly sane: it should be possible to
> set MACs to enable ACL feature. The second condition is that clear
> to me, but we have to comply in order to pass wiphy_registration.
> I assume that it somehow related to hostapd logic, but I haven't
> yet check that myself.
>
> The conditional enablement of WIPHY_FLAG_HAVE_AP_SME is easy to
> explain. We enable use firmware/hardware features to implement
> MAC-based ACL. So we enable it only if firmware report non-zero
> max_acl_mac_addrs value.

To me this looks like an ugly hack, either your firmware has AP_SME
support or not. It should not be enabled based on what settings user
space provides. If cfg80211 is giving you problems you should fix
cfg80211, not try to a workaround it in the driver like the vendor
drivers do. We work differently in upstream.

But Johannes (CCed) might think differently, and if he acks this, then
I'll of course take this.

-- 
Kalle Valo
