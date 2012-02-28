Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2B1CCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 21:02:33 -0500
Received: by iagj37 with SMTP id j37so566033iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 18:02:32 -0800 (PST)
Date: Mon, 27 Feb 2012 20:02:14 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	651199@bugs.debian.org, Andreas Gustafsson <olangu@impressions.se>,
	Marco d'Itri <md@Linux.IT>,
	Gabriel Kerneis <kerneis@pps.jussieu.fr>
Subject: Re: iwlwifi WPA-TKIP crypto failure after group rekeying
Message-ID: <20120228020214.GA21699@burratino> (sfid-20120228_030258_938221_C1722320)
References: <1330320802.8460.105.camel@deadeye>
 <1330333354.3483.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
In-Reply-To: <1330333354.3483.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tags 651199 = upstream patch
quit

Johannes Berg wrote:

> I think this is due to my patch "iwlagn: rewrite HW crypto" which
> accidentally broke key *removal* (of all things), which causes issues
> when the first GTK is removed on the second rekeying.
>
> This patch
> [...]h=5dcbf480473f6c3f06ad2426b7517038a2a18911
>
> should fix it.

Thanks.  The fix is in Linville's wireless tree, hence in linux-next.
I've attached it as a patch against 3.2.y in case someone wants to
try it.

(Instructions:

 # prerequisites
 apt-get install git build-essential

 # get a copy of the kernel
 git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 cd linux

 # fetch point releases
 git remote add -f stable \
  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
 
 # try 3.2.y
 git checkout stable/linux-3.2.y
 cp /boot/config-$(uname -r) .config; # current configuration
 make localmodconfig; # optional: minimize configuration
 make deb-pkg; # optionally with -j<num> for parallel build
 dpkg -i ../<name of package>
 reboot

 # hopefully it reproduces the problem, so try the patch:
 git am -3sc thepatch
 make deb-pkg; # maybe with -j4
 dpkg -i ../<name of package>
 reboot
)

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwlwifi-fix-key-removal.patch"

From: Johannes Berg <johannes.berg@intel.com>
Date: Fri, 17 Feb 2012 09:47:14 -0800
Subject: iwlwifi: fix key removal

commit 5dcbf480473f6c3f06ad2426b7517038a2a18911 upstream.

When trying to remove a key, we always send key
flags just setting the key type, not including
the multicast flag and the key ID. As a result,
whenever any key was removed, the unicast key 0
would be removed, causing a complete connection
loss after the second rekey (the first doesn't
cause a key removal). Fix the key removal code
to include the key ID and multicast flag, thus
removing the correct key.

Reported-by: Alexander Schnaidt <alex.schnaidt@googlemail.com>
Tested-by: Alexander Schnaidt <alex.schnaidt@googlemail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 4b2aa1da0953..5cfb3d17a2bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1211,6 +1211,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	unsigned long flags;
 	struct iwl_addsta_cmd sta_cmd;
 	u8 sta_id = iwlagn_key_sta_id(priv, ctx->vif, sta);
+	__le16 key_flags;
 
 	/* if station isn't there, neither is the key */
 	if (sta_id == IWL_INVALID_STATION)
@@ -1236,7 +1237,14 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		IWL_ERR(priv, "offset %d not used in uCode key table.\n",
 			keyconf->hw_key_idx);
 
-	sta_cmd.key.key_flags = STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
+	key_flags = cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags |= STA_KEY_FLG_MAP_KEY_MSK | STA_KEY_FLG_NO_ENC |
+		     STA_KEY_FLG_INVALID;
+
+	if (!(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	sta_cmd.key.key_flags = key_flags;
 	sta_cmd.key.key_offset = WEP_INVALID_OFFSET;
 	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
-- 
1.7.9.2


--cNdxnHkX5QqsyA0e--
