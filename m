Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37354 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab1LOQab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 11:30:31 -0500
Received: by pbdu13 with SMTP id u13so336823pbd.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 08:30:31 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Dec 2011 17:30:31 +0100
Message-ID: <CAGXE3d9dCL+tnXg5ero51cxf3T9VPVgv8oKo51Vi_gWd8as9Xw@mail.gmail.com> (sfid-20111215_173035_477199_25946640)
Subject: QoS frames in AP mode?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

just noticed a problem with QoS frames in AP mode when mac80211
relays for example a VOIP frame from STA1 to STA2 the frame will be
sent out on AC_BE and not on AC_VO.

When the frame is processed in the rx path we will send it to the wireless media
with the code path below (from rx.c):

        if (xmit_skb) {
                /* send to wireless media */
                xmit_skb->protocol = htons(ETH_P_802_3);
                skb_reset_network_header(xmit_skb);
                skb_reset_mac_header(xmit_skb);
                dev_queue_xmit(xmit_skb);
        }

So, skb->priority is the same as the received frame but will be overwritten
because the the netstack will call ieee80211_select_queue to select the
appropriate queue which in turn will use cfg80211_classify8021d to select
the skb->priority and the according queue (from net/wireless/util.c):

unsigned int cfg80211_classify8021d(struct sk_buff *skb)
{
        unsigned int dscp;

        /* skb->priority values from 256->263 are magic values to
         * directly indicate a specific 802.1d priority.  This is used
         * to allow 802.1d priority to be passed directly in from VLAN
         * tags, etc.
         */
        if (skb->priority >= 256 && skb->priority <= 263)
                return skb->priority - 256;

        switch (skb->protocol) {
        case htons(ETH_P_IP):
                dscp = ip_hdr(skb)->tos & 0xfc;
                break;
        default:
                return 0;
        }

        return dscp >> 5;
}

Unfortunately we don't have an skb priority between 256 and 263 and
we don't have skb->protocol set to ETH_P_IP here since we've just set
it to ETH_P_802_3.

I tried using eth_type_trans on the frame but that will "pull" the ethernet
header and adding an skb_push afterwards seems a little bit ugly to me.

Is it possible to just shortcut the classification if the priority is
already set?
Or should we just add 256 to the priority before sending the frame to
dev_queue_xmit?

What would be an appropriate fix for this?

Thanks,
Helmut
