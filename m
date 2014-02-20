Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:36249 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaBTOph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 09:45:37 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/2] cfg80211: docbook: fix small formatting error
Date: Thu, 20 Feb 2014 16:45:33 +0200
Message-Id: <1392907534-14470-1-git-send-email-luca@coelho.fi> (sfid-20140220_154549_823865_8F4CD626)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

docbook (or one of its friends) gets confused with semi-colons in the
argument descriptions, causing it to think that the semi-colon is
marking a new section in the description of addr_mask in wiphy struct.

Prevent this by using hyphens instead of semi-colons in the mask
example.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c89a5b5..2c53749 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2791,7 +2791,7 @@ struct wiphy_vendor_command {
  * @perm_addr: permanent MAC address of this device
  * @addr_mask: If the device supports multiple MAC addresses by masking,
  *	set this to a mask with variable bits set to 1, e.g. if the last
- *	four bits are variable then set it to 00:...:00:0f. The actual
+ *	four bits are variable then set it to 00-00-00-00-00-0f. The actual
  *	variable bits shall be determined by the interfaces added, with
  *	interfaces not matching the mask being rejected to be brought up.
  * @n_addresses: number of addresses in @addresses.
-- 
1.8.5.3

