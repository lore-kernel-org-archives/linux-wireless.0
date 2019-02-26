Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6262C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC9D5213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfBZJmJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:42:09 -0500
Received: from mout.gmx.net ([212.227.15.19]:45339 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfBZJmI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:42:08 -0500
Received: from w210-65-v4.eduroam.dynamic.rbg.tum.de.de ([131.159.210.221]) by
 mail.gmx.com (mrgmx003 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0MK0ur-1gxCCF208b-001OFE; Tue, 26 Feb 2019 10:41:30 +0100
From:   Julius Niedworok <julius.n@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     julius.n@gmx.net, ga58taw@mytum.de, david@redhat.com,
        nc@net.in.tum.de, "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] mac80211: Use IFF_ECHO to force delivery of tx_status frames
Date:   Tue, 26 Feb 2019 10:40:52 +0100
Message-Id: <20190226094104.35192-1-julius.n@gmx.net>
X-Mailer: git-send-email 2.10.1 (Apple Git-78)
X-Provags-ID: V03:K1:opVjtOQsi5gK9nJJUau61uKw6WWFV1xEC/gsICGQlWUWyka6RXw
 +g2l8qlrDkq9vVOz5krQIQrcNyC8TU3Sfk4Z4c+w/L+iSaFzi/QX+aWIV2GM0px789Z2Zm7
 MNttUJhBAVjGvmZGH8PUtdPLN0jVuVk9rZOtT0QcCZlyEFYL5Ua1x64+WlaYiShQSkmguzM
 lAoq0j3l5ey1YON7oFm/w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8ehB49dngxM=:7KpHg0KNfhtIP8aJ2CYWS5
 H99ee66GkrixXA6uIquyKoINwcNzG0dgdU2xwPxt+r0778/JrOu/m/q5hhx7MVsPL3GWNAGdZ
 5PstZJwCsnCF8XA16q995au+GwMS9QArfPGBpJ3CKIKzYVLhkK+J9MEaPQFbeFi0UIwqFOkPz
 7hPxpBIC0JecWc0g2x2MzTysAh4MsScOh3AKmuO59q++67tHWSCvZXBm3uAGxUl/jrZiEs16b
 7W37sAFGGFwYpH0w5fmcke0MTevG5iS6TkJRSVYrBHphxX/dke0PuxMKjcn+/BQAJBrWmxLG9
 RGwFRKHyXpR+98Rei0OgdeiPfwP6IwBtzFmUmvF2rt5R3dNg+NZ83OS0WO1wcLQsnd+fHNbWf
 hFCwX78Gg1KSg+AG8pgznsqmIhW4nmSNRioB3HSmg4sRTCWhvOyBJ6XM2qlWHt2aRK4OGQ9ym
 gi41OHqgeVVMo5nTEyNVIrGwhhnOL0+TUWitsD/T0ONOU7zSt7iuZWy18wQ2TGj8G/8eH/jYf
 XDMbSCNLpBfcIRU9a3p9TLI1lBaHHe0QydOCBzApxPK0F018AUT9A5Xq2KDOYK4iWBRMgcQ4N
 tPATqIMbk+UiB5fvRP+SdRD7R8Xxoj76IHrK1xfJEfRRyqYWlw4DgnK2IV0FDGa9R13DqCw1u
 fFjBim5u3onojStTtS/FHa/ImyVrsLq553auqiFmIG1Zb7gXjtLqprEXG4ZIBt08YP+o95BLY
 AJ79nTYpcV+Z8lnNqQSJf7vGv+JEY6uSeJq+knuhlBIGJeGAvmLUPXYVdxrRVPX7+rnSlNiYq
 KE8Vo58iH6S6TU59Fh1WiYy9udhCyQii+9LECATuxb8FTvy74lJVCtFSWAnLB+o+s3fR2l08q
 KQ707gJfpmsc13iUAC+NzdTpp0LVYcpAJxkcQwt97O+5F7GnTfPmhHH0rIxTKI
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

At Technical University of Munich we use MAC 802.11 TX status frames to
perform several measurements in MAC 802.11 setups.

With ath based drivers this was possible until commit d94a461d7a7df6
("ath9k: use ieee80211_tx_status_noskb where possible") as the driver
ignored the IEEE80211_TX_CTL_REQ_TX_STATUS flag and always delivered
TX status frames. Since this commit, this behavior was changed and the
driver now adheres to IEEE80211_TX_CTL_REQ_TX_STATUS.

Due to performance reasons, IEEE80211_TX_CTL_REQ_TX_STATUS is not set for
data frames from interfaces in managed mode. Hence, frames that are sent
from a managed mode interface do never deliver TX status frames. This
remains true even if a monitor mode interface (e.g. a measurement
interface) is added to the same wireless hardware device. Thus, there is
no possibility for receiving TX status frames for frames sent on an
interface in managed mode if the driver adheres to
IEEE80211_TX_CTL_REQ_TX_STATUS.

In order to force delivery of TX status frames for research and debugging
purposes, implement the IFF_ECHO flag for ieee80211 devices. When this flag
is set for a specific interface, IEEE80211_TX_CTL_REQ_TX_STATUS is enabled
in all packets sent from that interface. IFF_ECHO can be set via
/sys/class/net/<dev>/flags. The default is disabled.

Co-developed-by: Charlie Groh <ga58taw@mytum.de>
Signed-off-by: Charlie Groh <ga58taw@mytum.de>
Signed-off-by: Julius Niedworok <julius.n@gmx.net>
---
 net/core/dev.c    | 8 ++++++++
 net/mac80211/tx.c | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8e276e0..076b556 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7543,6 +7543,14 @@ int __dev_change_flags(struct net_device *dev, unsigned int flags,
 			       IFF_AUTOMEDIA)) |
 		     (dev->flags & (IFF_UP | IFF_VOLATILE | IFF_PROMISC |
 				    IFF_ALLMULTI));
+	/*
+	 *	Force TX status frames on ieee80211 devices.
+	 *	Since IFF_ECHO is used by CAN devices for a different
+	 *	purpose, we must check dev->ieee80211_ptr.
+	 */
+
+	if (dev->ieee80211_ptr)
+		dev->flags = (dev->flags & ~IFF_ECHO) | (flags & IFF_ECHO);
 
 	/*
 	 *	Load in the correct multicast list now the flags have changed.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 928f13a..2a02f66 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2463,6 +2463,9 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	if (IS_ERR(sta))
 		sta = NULL;
 
+	if (sdata->dev->flags & IFF_ECHO)
+		info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
 	ethertype = (skb->data[12] << 8) | skb->data[13];
@@ -3468,6 +3471,9 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
 	info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT;
 
+	if (sdata->dev->flags & IFF_ECHO)
+		info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		*ieee80211_get_qos_ctl(hdr) = tid;
-- 
2.10.1 (Apple Git-78)

