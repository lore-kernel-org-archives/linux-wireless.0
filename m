Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0074.outbound.protection.outlook.com ([104.47.33.74]:21089
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752604AbdLEQA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:00:26 -0500
Date: Tue, 5 Dec 2017 19:00:11 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
Message-ID: <20171205160010.cytra3bqbttwz5db@bars> (sfid-20171205_170030_921749_A8B27950)
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
 <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
 <871skalepz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871skalepz.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
> > From: Vasily Ulyanov <vulyanov@quantenna.com>
> >
> > This allows a running AP to blacklist STAs by their MAC addresses
> > respecting the configured policy (either accept or deny unless listed).
> > It can be setup on .start_ap or with .set_mac_acl commands.
> >
> > Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
> 
> [...]
> 
> > @@ -918,6 +933,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
> >       wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
> >       wiphy->mgmt_stypes = qtnf_mgmt_stypes;
> >       wiphy->max_remain_on_channel_duration = 5000;
> > +     wiphy->max_acl_mac_addrs = mac->macinfo.max_acl_mac_addrs;
> >
> >       wiphy->iface_combinations = iface_comb;
> >       wiphy->n_iface_combinations = 1;
> > @@ -932,6 +948,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
> >                       WIPHY_FLAG_AP_UAPSD |
> >                       WIPHY_FLAG_HAS_CHANNEL_SWITCH;
> >
> > +     if (wiphy->max_acl_mac_addrs > 0)
> > +             wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
> 
> Conditonally enabling WIPHY_FLAG_HAVE_AP_SME looks somewhat suspicious
> to me and from a quick search I don't see any other driver doing
> something similar. Can you explain why AP_SME is related to MAC ACL?

Wireless core performs several sanity check on wiphy registration: see
wiphy_register implementation in net/wireless/core.c. One of those
checks is as follows: if max_acl_mac_addrs is non-zero, then two
conditions should be fulfilled:
- cfg80211 set_mac_acl callback should be available
- WIPHY_FLAG_HAVE_AP_SME should be set

The first condition is perfectly sane: it should be possible to
set MACs to enable ACL feature. The second condition is that clear
to me, but we have to comply in order to pass wiphy_registration.
I assume that it somehow related to hostapd logic, but I haven't
yet check that myself.

The conditional enablement of WIPHY_FLAG_HAVE_AP_SME is easy to
explain. We enable use firmware/hardware features to implement
MAC-based ACL. So we enable it only if firmware report non-zero
max_acl_mac_addrs value.

Regards,
Sergey
