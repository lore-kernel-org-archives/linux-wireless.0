Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42765 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2K3J3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 04:29:33 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so316033ieb.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2012 01:29:33 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 30 Nov 2012 14:59:12 +0530
Message-ID: <CABPxzYL=MBQ3uZR=EmcNAa-9iELPKRWtwZNBnxpFdk7z5XpPKw@mail.gmail.com> (sfid-20121130_102938_440132_9B042444)
Subject: [PATCH] iwl4965:Fixing Broken Monitor Mode Functionality
To: johannes@sipsolutions.net
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	maheshp@posedge.com, chaitanyatk@posedge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From the patch  "90b9e446fbb64630c72cab48c007d7081aec2533: mac80211:
support radiotap vendor namespace RX data"
the monitor mode functionality in iwl4965 stopped working, because of
below issues

1) The driver doesnt fill the newly added fields in the ieee80211_rx_status
and also doesn't do a memset leading to junk values.

ieee80211_rx_monitor:

"pskb_may_pull(origskb, 2 + status->vendor_radiotap_len)" the pull
fails because of junk value in vendor_radiotap_len.
And all the frames are dropped.

2) We also see a kernel trace in

ieee80211_rx_radiotap_space:
        if (status->vendor_radiotap_len) {
                if (WARN_ON_ONCE(status->vendor_radiotap_align == 0))

This patch fixed both the issues, this is tested with iwl4965 intel
wireless nic.

Signed-off-by: Chaitanya T K<chaitanya.mgit@gmail.com>
---

 drivers/net/wireless/iwlegacy/4965-mac.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c
b/drivers/net/wireless/iwlegacy/4965-mac.c
index ef68b72..d4b801e 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -671,6 +671,16 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
        /* This will be used in several places later */
        rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);

+        /* To Avoid Junk values to mac80211 causing the frames
+        * to drop when NIC is on monitor mode:wireshark doesnt work
+         * This came in to light with the patch from
+         * johannes "support radiotap vendor namespace RX data"
+         * which introduced 2 more  entries to the rx_stats struct,
+         * but as the driver is not configuring those, they become
+         * junk when accessed at mac80211.
+         */
+        memset(&rx_status,0,sizeof(rx_status));
+
        /* rx_status carries information about the packet to mac80211 */
        rx_status.mactime = le64_to_cpu(phy_res->timestamp);
        rx_status.band =
