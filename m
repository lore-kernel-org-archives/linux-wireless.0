Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:60445 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbXFKXEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 19:04:40 -0400
Date: Tue, 12 Jun 2007 01:04:35 +0200
From: David Lamparter <lists@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] {cfg,nl}80211 API
Message-ID: <20070611230434.GA13221@charon.n2.diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone!

the following intentionally-broken patch outlines the current state of
things in my nl80211 hacking branch. Comments, extensions and feedback
more than welcome.

Human-readable summary:
- struct ieee80211_channel:
  use (phymode, channel, 80211n-mode) as "key"; kill off frequency
  (which will move to some get_channel_foobar function)
- cfg80211: make API more complete:
  - add channel get/set/chanlist;
    - those are using struct ieee80211_channel
    - channel listing works by providing a callback to the driver, which
      iterates then.
  - add get interface type. 
- nl80211: seriously extend API
  - wiphy listing now works via dumping; serves for listing and getting
    current config (including channel, phymode, list of virtual interfaces)
  - add channel get/set/chanlist
    - chanlist exports freq & maxpower from kernel, too
      (solves 20 userspace apps implementing 50 frequency tables)
  - getting virtual interfaces works via ifindex, which needs to be known.
    - no dumping (would have locking issues with userspace MLME)
    - use list of vifs from GET_WIPHY
    - only thing it currently should return is vif type. essid & stuff
      should be retrievable via GET_ASSOCIATION, which won't be valid for
      monitor interfaces

So, what's left?
- more PHY config stuff?
  - TX power? Should be able to configure a lower value...
  - antenna selection?
- Atheros "Turbo" modes - are those useful to add as phymodes or as
  attributes?
- more stuff I forgot.

As for implementation, my hacking tree has a working "proof of concept" for
configuring the phy over nl80211. However, especially the regulatory stuff
will require a reworking of it, and reconfiguring the channel doesn't
produce a notification yet, either. (Configuring something via wext should
trigger that notification too, so hopefully the split-out of the regulatory
stuff will allow adding a central notification call too).

Anyway, for the appetite:

  # iw link; iw phy chanlist phy0 channel 3
  0: phy0: <RENAME,SETCHANNEL,CHANLIST,ADDVIF> mode 802.11g channel 1
      10: wlan0: <DELVIF> type managed
      9: wmaster0: <DELVIF> type ap
  0: phy0: channel   3 mode 802.11g    # 54M 2.422 GHz
  0: phy0: channel   3 mode 802.11b    # 11M 2.422 GHz
  # iw phy set phy0 channel 3 mode b; iw phy
  0: phy0: <RENAME,SETCHANNEL,CHANLIST,ADDVIF> mode 802.11b channel 3

Hoping for feedback, and to reach a preliminary API consent soon,


-David

---
 include/linux/nl80211.h |   41 +++++++++++++++++++++++++++++------------
 include/net/cfg80211.h  |   13 +++++++++++++
 include/net/ieee80211.h |   21 +++++++++++++++++----
 3 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index cef969c..02094a7 100644
-%-- a/include/linux/nl80211.h
+%++ b/include/linux/nl80211.h
@@ -9,9 +9,17 @@
 /**
  * enum nl80211_commands - supported nl80211 commands
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
+ * @NL80211_CMD_GET_WIPHY: request a wiphy or dump request to get a list.
+ * @NL80211_CMD_NEW_WIPHY: returned list of all wiphys. Has attributes
+ *      corresponding to the PHY's configuration capabilities. Has at least
+ *      %NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME
  * @NL80211_CMD_RENAME_WIPHY: rename a wiphy, needs
  *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME
  * @NL80211_CMD_WIPHY_NEWNAME: rename notification
+ * @NL80211_CMD_SET_CHANNEL: configure a PHY.
+ * @NL80211_CMD_NEW_CHANNEL: reconfiguration notification.
+ * @NL80211_CMD_GET_CHANLIST: TBA
+ * @NL80211_CMD_NEW_CHANLIST: TBA
  * @NL80211_CMD_GET_CMDLIST: TO BE DEFINED PROPERLY. currently the code makes
  *	it depend on the wiphy only but it really should depend on the
  *	interface type too....
@@ -24,12 +32,12 @@
  * @NL80211_CMD_CHANGE_VIRTUAL_INTERFACE: change type of virtual interface to
  *	the type given by %NL80211_ATTR_IFTYPE, the interface is identified by
  *	%NL80211_ATTR_IFINDEX.
- * @NL80211_CMD_GET_WIPHYS: request a list of all wiphys present in the system
- * @NL80211_CMD_NEW_WIPHYS: returned list of all wiphys
- * @NL80211_CMD_GET_INTERFACES: request a list of all interfaces belonging to
- *	the wiphy identified by %NL80211_ATTR_WIPHY
- * @NL80211_CMD_NEW_INTERFACES: result for %NL80211_CMD_GET_INTERFACES
- * @NL80211_CMD_INITIATE_SCAN: initiate a scan with the passed parameters. THe
+ * @NL80211_CMD_GET_INTERFACE: request an interface's configuration.
+ *      pass a %NL80211_ATTR_IFINDEX, get below reply.
+ * @NL80211_CMD_NEW_INTERFACE: result for %NL80211_CMD_GET_INTERFACES.
+ *      Has %NL80211_ATTR_WIPHY, %NL80211_ATTR_IFINDEX and
+ *      %NL80211_ATTR_IFTYPE attributes.
+ * @NL80211_CMD_INITIATE_SCAN: initiate a scan with the passed parameters. The
  *	parameters may contain %NL80211_ATTR_FLAG_SCAN_ACTIVE,
  *	%NL80211_ATTR_PHYMODE and a list of channels in an
  *	%NL80211_ATTR_CHANNEL_LIST attribute (an array of nested attributes)
@@ -52,9 +60,17 @@
 enum nl80211_commands {
 /* don't change the order or add anything inbetween, this is ABI! */
 	NL80211_CMD_UNSPEC,
+	/* %input: */
+	NL80211_CMD_GET_WIPHY,		/* may dump req */
+	NL80211_CMD_NEW_WIPHY,
 	/* %input: wiphy, wiphy_name */
 	NL80211_CMD_RENAME_WIPHY,
 	NL80211_CMD_WIPHY_NEWNAME,
+	/* %input: wiphy */
+	NL80211_CMD_SET_CHANNEL,
+	NL80211_CMD_NEW_CHANNEL,
+	NL80211_CMD_GET_CHANLIST,
+	NL80211_CMD_NEW_CHANLIST,
 	/* %input: wiphy|ifindex */
 	NL80211_CMD_GET_CMDLIST,
 	NL80211_CMD_NEW_CMDLIST,
@@ -64,12 +80,9 @@ enum nl80211_commands {
 	NL80211_CMD_DEL_VIRTUAL_INTERFACE,
 	/* %input: ifindex, iftype */
 	NL80211_CMD_CHANGE_VIRTUAL_INTERFACE,
-	/* %input: */
-	NL80211_CMD_GET_WIPHYS,
-	NL80211_CMD_NEW_WIPHYS,
 	/* %input: wiphy */
-	NL80211_CMD_GET_INTERFACES,
-	NL80211_CMD_NEW_INTERFACES,
+	NL80211_CMD_GET_INTERFACE,	/* may dump req */
+	NL80211_CMD_NEW_INTERFACE,
 	NL80211_CMD_INITIATE_SCAN,
 	NL80211_CMD_SCAN_RESULT,
 	NL80211_CMD_GET_ASSOCIATION,
@@ -151,11 +164,15 @@ enum nl80211_attrs {
 	/* %type: u32 */
 	NL80211_ATTR_IFTYPE,
 	NL80211_ATTR_INTERFACE_LIST,
-	NL80211_ATTR_WIPHY_LIST,
 	NL80211_ATTR_BSSID,
 	NL80211_ATTR_SSID,
 	NL80211_ATTR_CHANNEL,
 	NL80211_ATTR_PHYMODE,
+	NL80211_ATTR_11N_MODE,
+	/* the following two are ONLY for channel list: */
+	NL80211_ATTR_FREQ,
+	NL80211_ATTR_MAXPOWER,
+	/* ^ ^ ^ */
 	NL80211_ATTR_CHANNEL_LIST,
 	NL80211_ATTR_BSS_LIST,
 	NL80211_ATTR_BSSTYPE,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1398c21..efdd8b4 100644
-%-- a/include/net/cfg80211.h
+%++ b/include/net/cfg80211.h
@@ -78,6 +78,10 @@ struct key_params {
 /* from net/wireless.h */
 struct wiphy;
 
+/* callback to be called by driver to give nl80211 a channel list */
+typedef int (*cfg80211_chanlist_cb)(void *arg,
+				    struct ieee80211_channel *channel);
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -121,6 +125,15 @@ struct cfg80211_ops {
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
 				       enum nl80211_iftype type);
+	int	(*get_virtual_intf)(struct wiphy *wiphy, int ifindex,
+				    enum nl80211_iftype *type);
+
+	int	(*get_channel)(struct wiphy *wiphy,
+			       struct ieee80211_channel *channel);
+	int	(*set_channel)(struct wiphy *wiphy, int chan,
+			       struct ieee80211_channel *channel);
+	int	(*get_chanlist)(struct wiphy *wiphy, cfg80211_chanlist_cb cb,
+				void *arg);
 
 	int	(*associate)(struct wiphy *wiphy, struct net_device *dev,
 			     struct association_params *params);
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index bbd85cd..148ed90 100644
-%-- a/include/net/ieee80211.h
+%++ b/include/net/ieee80211.h
@@ -28,6 +28,7 @@
 #include <linux/if_ether.h>	/* ETH_ALEN */
 #include <linux/kernel.h>	/* ARRAY_SIZE */
 #include <linux/wireless.h>
+#include <linux/nl80211.h>
 
 #define IEEE80211_VERSION "git-1.1.13"
 
@@ -973,7 +974,7 @@ enum ieee80211_state {
 #define IEEE80211_52GHZ_CHANNELS (IEEE80211_52GHZ_MAX_CHANNEL - \
 				  IEEE80211_52GHZ_MIN_CHANNEL + 1)
 
-enum {
+enum ieee80211_channel_flags {
 	IEEE80211_CH_PASSIVE_ONLY = (1 << 0),
 	IEEE80211_CH_80211H_RULES = (1 << 1),
 	IEEE80211_CH_B_ONLY = (1 << 2),
@@ -983,10 +984,22 @@ enum {
 	IEEE80211_CH_INVALID = (1 << 6),
 };
 
+enum ieee80211n_subchannel {
+	IEEE80211N_SUBCH_LEGACY,	/* 20 MHz 11a/g compat */
+	IEEE80211N_SUBCH_LEGACY_DUP,	/* 2x20 MHz, same data */
+	IEEE80211N_SUBCH_NATIVE,	/* 40 MHz native */
+	IEEE80211N_SUBCH_LOWER,		/* lower 20MHz, legacy & native */
+	IEEE80211N_SUBCH_UPPER,		/* upper 20MHz, legacy & native */
+};
+
 struct ieee80211_channel {
-	u32 freq;	/* in MHz */
-	u8 channel;
-	u8 flags;
+	/* configurable: */
+	enum nl80211_phymode phymode;
+	u16 channel;
+	enum ieee80211_subchannel n_subch;
+
+	/* fixed: */
+	enum ieee80211_channel_flags flags;
 	u8 max_power;	/* in dBm */
 };
 
-- 
1.5.2.1

