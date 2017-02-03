Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:53448 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751520AbdBCHL3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 02:11:29 -0500
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Moni Shoua <monis@voltaire.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [PATCH net] ipv6: Fix IPv6 packet loss in scenarios involving roaming + snooping switches
Date: Fri,  3 Feb 2017 08:11:03 +0100
Message-Id: <20170203071103.25976-1-linus.luessing@c0d3.blue> (sfid-20170203_081203_272237_D0921153)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When for instance a mobile Linux device roams from one access point to
another with both APs sharing the same broadcast domain and a
multicast snooping switch in between:

1)    (c) <~~~> (AP1) <--[SSW]--> (AP2)

2)              (AP1) <--[SSW]--> (AP2) <~~~> (c)

Then currently IPv6 multicast packets will get lost for (c) until an
MLD Querier sends its next query message. The packet loss occurs
because upon roaming the Linux host so far stayed silent regarding
MLD and the snooping switch will therefore be unaware of the
multicast topology change for a while.

This patch fixes this by always resending MLD reports when an interface
change happens, for instance from NO-CARRIER to CARRIER state.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>

---

Initial problem report was sent to the bridge mailing list a while ago:
- https://lists.linuxfoundation.org/pipermail/bridge/2015-September/009754.html

The RFCs concerning IGMP, MLD and snooping switches seem a have a hole
concerning roaming. A request for clarification to mcast-wifi@ietf.org
was left unanswered, unfortunately:
- https://mailarchive.ietf.org/arch/msg/mcast-wifi/Ghn2cGy1oN2ZwG1qaQO9SE13g6g

However, simply resending reports seems to be the straight forward way
to me to fix the issue mentioned above.
---
 net/ipv6/addrconf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f60e88e..81f7b4e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3386,9 +3386,15 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			}
 
 			if (idev) {
-				if (idev->if_flags & IF_READY)
-					/* device is already configured. */
+				if (idev->if_flags & IF_READY) {
+					/* device is already configured -
+					 * but resend MLD reports, we might
+					 * have roamed and need to update
+					 * multicast snooping switches
+					 */
+					ipv6_mc_up(idev);
 					break;
+				}
 				idev->if_flags |= IF_READY;
 			}
 
-- 
2.1.4
