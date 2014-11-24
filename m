Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36361 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaKXOgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:04 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so5996521wid.12
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:03 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/75] iwlwifi: mvm: pull SNAP header into skb->head
Date: Mon, 24 Nov 2014 16:34:16 +0200
Message-Id: <1416839691-28533-40-git-send-email-egrumbach@gmail.com> (sfid-20141124_153623_207964_4EE4DC81)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we pre-populate the skb->head for the stack, we only pull
in the 802.11 header including crypto (assuming the packet isn't
short enough to be in there completely.) This is fine, but in
ieee80211_data_to_8023() we later unconditionally pull 8 more
bytes for the SNAP header and ethertype field (except for mesh
or 4-addr, where it's even more, but we don't care as much about
them).

Avoid the additional later pull by pulling in those 8 bytes here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: IdoX Yariv <ido@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 69fa765..94b6e72 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -104,10 +104,19 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	unsigned int hdrlen, fraglen;
 
 	/* If frame is small enough to fit in skb->head, pull it completely.
-	 * If not, only pull ieee80211_hdr (including crypto if present) so
-	 * that splice() or TCP coalesce are more efficient.
+	 * If not, only pull ieee80211_hdr (including crypto if present, and
+	 * an additional 8 bytes for SNAP/ethertype, see below) so that
+	 * splice() or TCP coalesce are more efficient.
+	 *
+	 * Since, in addition, ieee80211_data_to_8023() always pull in at
+	 * least 8 bytes (possibly more for mesh) we can do the same here
+	 * to save the cost of doing it later. That still doesn't pull in
+	 * the actual IP header since the typical case has a SNAP header.
+	 * If the latter changes (there are efforts in the standards group
+	 * to do so) we should revisit this and ieee80211_data_to_8023().
 	 */
-	hdrlen = (len <= skb_tailroom(skb)) ? len : sizeof(*hdr) + crypt_len;
+	hdrlen = (len <= skb_tailroom(skb)) ? len :
+					      sizeof(*hdr) + crypt_len + 8;
 
 	memcpy(skb_put(skb, hdrlen), hdr, hdrlen);
 	fraglen = len - hdrlen;
-- 
1.9.1

