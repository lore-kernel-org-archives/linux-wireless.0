Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51125 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934398AbaFSVKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2014 17:10:36 -0400
From: Chet Lanctot <clanctot@qca.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Chet Lanctot <clanctot@qca.qualcomm.com>
Subject: [PATCH 1/1] cfg80211: Changes to support key managment offload
Date: Thu, 19 Jun 2014 14:10:07 -0700
Message-Id: <1403212207-12722-1-git-send-email-clanctot@qca.qualcomm.com> (sfid-20140619_231041_111246_43521E03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes represent a small number of extensions to the nl80211/
cfg80211 interface to support the offload of key management to the
device.

Key management offload is a mechanism where a station's device driver
or firmware/hardware does the exchange with the AP to establish the
temporal keys to be used for communications protection, rather than
having the supplicant do it.  This exchange takes place in a Robust
Security Network during initial connection or after a roam between
APs occurs.  It might also happen during after the device handles a
PTK rekeying operation.

This design only supports key managment offload in a station
(non-AP STA).

There are a couple of possible advantages to offloading key
management.
   - Connection time might be reduced (initial connection and after
     roaming) since fewer software components will be involved and
     there will not need to be a switch between kernel space (device
     driver) and user space (wpa_supplicant).
   - Power savings might be achieved since user space modules might
     run on a processor separate from the device driver and/or
     firmware and that processor could be kept in a power saving mode
     since it need not be involved in key management.

The proposed changes enable key management to be offloaded in the
following cases.
   - WPA or WPA2 with PSK
   - 802.11r (Fast Transition) with PSK
   - Opportunistic Key Caching (OKC)

For WPA/WPA2 or 802.11r with PSK, the PSK is supplied to the device
driver by the supplicant.  For the OKC case, the supplicant will handle
the initial 802.1X authentication.  It will pass the resulting PMK
(session key) to the driver.  The driver can subsequently use this key
for connection to an AP that has cached the security association
(PMKSA), allowing the device to offload key management while not having
to do the full 802.1X authentication.

The following topics will now be covered.
   1. Advertisement - The capabilities of the device with relation to
      key management offloads are made known to the supplicant.
   2. Information Passing - The supplicant provides necessary
      information to the device to allow it to accomplish the offload.
   3. Indication - Mechanism for the driver to update the supplicant
      that key management has taken place.
   4. Example - An example of how the interface is used to allow key
      management offload to take place.

Advertisement
-------------

The host driver's capability to offload key management is advertised by
the wiphy capability flag WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD.  Individual
key management and key derivation capabilities are advertised as part
of the device attributes.

The following key management offload capabilities can be advertised.
   NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PSK
   NL80211_KEY_MGMT_OFFLOAD_SUPPORT_FT_PSK
   NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PMKSA

The following key derivation capabilities can be advertised.
   NL80211_KEY_DERIVE_OFFLOAD_SUPPORT_IGTK

The decision to enable key management offload for a particular
connection is indicated to the driver by the flag
ASSOC_REQ_OFFLOAD_KEY_MGMT in cfg80211_assoc_req_flags which is passed
in a cfg80211_connect command.

Information Passing
-------------------
The device will need information from the supplicant to handle the key
management offload.  For each type of key management offload, the
following information is needed.

NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PSK
   The PSK will be needed.  The PSK will be included in the
   cfg80211_connect_params that is passed as part of cfg80211_connect.

NL80211_KEY_MGMT_OFFLOAD_SUPPORT_FT_PSK
   The PSK will be needed.  The PSK will be included in the
   cfg80211_connect_params that is passed as part of cfg80211_connect.

NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PMKSA
   The PMK (MSK) will be needed.  It is not available at initial
   association connect time because the 802.1X authentication must
   first take place before the PMK is established.  The PMK will be
   passed to the driver using cfg80211_add_key in this case once it is
   known.  A new cipher suite type is defined to identify the value as
   a PMK when cfg80211_add_key is used in this way.

Indication
----------

On a successful key management offload, the driver will invoke
cfg80211_authorization_event with status NL80211_AUTHORIZED.  If the
key management offload is not successful, then NL80211_CONNECTED is
passed as the status in cfg80211_authorization_event and it is expected
the supplicant will take over key management.

The last used EAPOL key reply counter value is passed to the supplicant
in cfg80211_authorization_event.

In the case of key management offload after roaming,
cfg80211_authorization_event will always be called immediately after a
call to cfg80211_roamed.

In the case of PTK rekeying, cfg80211_authorization_event is called
after the device has handled rekeying.  This allows the supplicant
to recieve an updated EAPOL key reply counter value.

Example
-------

As an example of how this interface can be used, the case of key
management offloading for a WPA2 connection is examined.

   1. The driver advertises general key management offload capability
      with the wiphy flag WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD.  Device
      attributes NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PSK and
      NL80211_KEY_DERIVE_OFFLOAD_SUPPORT_IGTK are advertised.

   2. Using existing mechanisms, the supplicant decides that a
      connection should be made to a network.  The network is an RSN
      supporting WPA2 and Protected Management Frames.  Seeing that the
      device supports key management offload for WPA2 and key derivation
      for IGTK, it signals to the driver that it wants to take advantage
      of key management offload by specifying ASSOC_REQ_OFFLOAD_KEY_MGMT
      in cfg80211_assoc_req_flags in the cfg80211_connect command.  The
      PSK for the connection is also included in cfg80211_connect.

   3. The supplicant enters the "connected" state as it currently does,
      waiting for the first EAPOL frame to arrive so that the security
      exchange can be done.  The EAPOL frame is presented to the
      supplicant and it completes the security exchange.  This is all
      existing functionality.  No key management offload took place
      during this initial connection (but it could have).

   4. Sometime later, the supplicant gets a cfg80211_roamed indication,
      telling the supplicant that the device roamed to a different AP.
      Again, the supplicant enters "connected" state, waiting for the
      first EAPOL frame so that the security exchange can be done with
      the new AP.

   5. Immediately, the supplicant gets a cfg80211_authorization_event
      with success status, indicating that the key management has been
      done by the device.  The supplicant enters "authorized" state for
      the connection and allows transmission and reception of data
      frames on the network.  Here, during roaming, the key management
      was offloaded to the device and did not need to be handled by the
      supplicant.

Signed-off-by: Chet Lanctot <clanctot@qca.qualcomm.com>
---
 include/net/cfg80211.h       |  62 ++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 102 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  98 +++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  12 +++++
 net/wireless/trace.h         |  23 ++++++++++
 5 files changed, 297 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f2c3186..2bcd88d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1581,10 +1581,14 @@ struct cfg80211_auth_request {
  *
  * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
  * @ASSOC_REQ_DISABLE_VHT:  Disable VHT
+ * @ASSOC_REQ_OFFLOAD_KEY_MGMT:  Requests that device handle establishment
+ *	of temporal keys if possible during initial RSN connection or after
+ *	roaming
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT		= BIT(0),
 	ASSOC_REQ_DISABLE_VHT		= BIT(1),
+	ASSOC_REQ_OFFLOAD_KEY_MGMT	= BIT(2),
 };
 
 /**
@@ -1745,6 +1749,8 @@ struct cfg80211_ibss_params {
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
  * @vht_capa:  VHT Capability overrides
  * @vht_capa_mask: The bits of vht_capa which are to be used.
+ * @psk:  The Preshared Key to be used for the connection.
+ *	(only valid if ASSOC_REQ_OFFLOAD_KEY_MGMT is set)
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1767,6 +1773,7 @@ struct cfg80211_connect_params {
 	struct ieee80211_ht_cap ht_capa_mask;
 	struct ieee80211_vht_cap vht_capa;
 	struct ieee80211_vht_cap vht_capa_mask;
+	const u8 *psk;
 };
 
 /**
@@ -2294,6 +2301,10 @@ struct cfg80211_qos_map {
  * @set_ap_chanwidth: Set the AP (including P2P GO) mode channel width for the
  *	given interface This is used e.g. for dynamic HT 20/40 MHz channel width
  *	changes during the lifetime of the BSS.
+ *
+ * @key_mgmt_set_pmk: Used to pass the PMK to the device for key management
+ *	offload.  This will be used in the case of key management offload on an
+ *	already established PMKSA.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2544,6 +2555,9 @@ struct cfg80211_ops {
 
 	int	(*set_ap_chanwidth)(struct wiphy *wiphy, struct net_device *dev,
 				    struct cfg80211_chan_def *chandef);
+
+	int	(*key_mgmt_set_pmk)(struct wiphy *wiphy, struct net_device *dev,
+				   u8 *pmk);
 };
 
 /*
@@ -2590,6 +2604,14 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
  *	beaconing mode (AP, IBSS, Mesh, ...).
+ * @WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD: Device operating as a station is
+ *	capable of doing the exchange necessary to establish temporal keys
+ *	during initial RSN connection, after roaming, or during a PTK rekeying
+ *	operation.  Supplicant should expect to do the exchange itself, by
+ *	preparing to process the EAPOL-Key frames, until
+ *	NL80211_CMD_AUTHORIZATION_EVENT is sent with success status.  The
+ *	supported types of key management offload are advertised by
+ *	NL80211_ATTR_KEY_MGMT_OFFLOAD.
  */
 enum wiphy_flags {
 	/* use hole at 0 */
@@ -2615,6 +2637,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
+	WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD		= BIT(24),
 };
 
 /**
@@ -2925,6 +2948,14 @@ struct wiphy_vendor_command {
  *	(including P2P GO) or 0 to indicate no such limit is advertised. The
  *	driver is allowed to advertise a theoretical limit that it can reach in
  *	some cases, but may not always reach.
+ *
+ * @key_mgmt_offload_support: Bitmap of supported types of key management
+ *	that can be offloaded to the device. See
+ *	nl80211_key_mgmt_offload_support.  Only valid when
+ *	WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD is set.
+ * @key_derive_offload_support: Bitmap of supported key derivations used as
+ *	part of key management offload.  See nl80211_key_derive_offload_support.
+ *	Only valid when WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD is set.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3042,6 +3073,9 @@ struct wiphy {
 
 	u16 max_ap_assoc_sta;
 
+	u32 key_mgmt_offload_support;
+	u32 key_derive_offload_support;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -4768,6 +4802,34 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 					    void *data),
 			       void *data);
 
+/**
+ * cfg80211_authorization_event - indicates key management offload complete
+ * @dev: the device reporting offload
+ * @auth_status: whether offload was successful
+ * @key_replay_ctr: Key Replay Counter value last used in a valid
+ *	EAPOL-Key frame
+ * @gfp: allocation flags
+ *
+ * This function reports that the device offloaded the key management
+ * operation and established temporal keys for an RSN connection.  In
+ * this case, the device handled the exchange necessary to establish
+ * the temporal keys by processing the EAPOL-Key frames instead of
+ * the supplicant doing it.  This means the initial connection, roam
+ * operation, or PKT rekeying is complete and the supplicant should
+ * enter the authorized state for the port.  This event can be signaled
+ * after cfg80211_connect_result during initial connection or after
+ * cfg80211_roamed in the case of roaming.  This event might also be
+ * signaled after the device handles a PTK rekeying operation.  If the
+ * auth_status parameter indicates that offload was not successful,
+ * then the supplicant should expect to do the necessary key management
+ * with the AP and the EAPOL-Key frames should be delivered to
+ * the supplicant.
+ */
+void cfg80211_authorization_event(struct net_device *dev,
+				  enum nl80211_authorization_status auth_status,
+				  const u8 *key_replay_ctr,
+				  gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 406010d..2a8f2d6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -719,6 +719,24 @@
  *	QoS mapping is relevant for IP packets, it is only valid during an
  *	association. This is cleared on disassociation and AP restart.
  *
+ * @NL80211_CMD_AUTHORIZATION_EVENT: Indicates that the device offloaded
+ *	the establishment of temporal keys for an RSN connection.  This is
+ *	used as part of key managment offload, where a device operating as a
+ *	station is capable of doing the exchange necessary to establish
+ *	temporal keys during initial RSN connection or after roaming.  This
+ *	event might also be sent after the device handles a PTK rekeying
+ *	operation.  The supplicant should expect to do the exchange itself,
+ *	by preparing to process the EAPOL-Key frames, until
+ *	NL80211_CMD_AUTHORIZATION_EVENT is sent with success status.  The
+ *	NL80211_ATTR_AUTHORIZATION_STATUS attribute provides the status of
+ *	the offload and NL80211_KEY_REPLAY_CTR provides the Key Replay
+ *	Counter value last used in a valid EAPOL-Key frame.
+ *
+ * @NL80211_CMD_KEY_MGMT_SET_PMK: Used to pass the PMK to the device for
+ *	key management offload.  This will be used in the case of key
+ *	management offload on an already established PMKSA.  The PMK is passed
+ *	in NL80211_ATTR_PMK once it is known by the supplicant.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -890,6 +908,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_QOS_MAP,
 
+	NL80211_CMD_AUTHORIZATION_EVENT,
+	NL80211_CMD_KEY_MGMT_SET_PMK,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1583,6 +1604,19 @@ enum nl80211_commands {
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed
  *
+ * @NL80211_ATTR_AUTHORIZATION_STATUS: Status of key management offload.
+ * @NL80211_ATTR_KEY_REPLAY_CTR: Key Replay Counter value last used in a
+ *	valid EAPOL-Key frame.
+ * @NL80211_ATTR_PSK: The Preshared Key to be used for the connection.
+ * @NL80211_ATTR_OFFLOAD_KEY_MGMT: Requests that device handle establishment
+ *	of temporal keys if possible.
+ * @NL80211_ATTR_KEY_MGMT_OFFLOAD_SUPPORT: Supported types of device key
+ *	management offload.
+ * @NL80211_ATTR_KEY_DERIVE_OFFLOAD_SUPPORT: Supported types of device key
+ *	derivation used as part of key management offload.
+ * @NL80211_ATTR_PMK: The Pairwise Master Key to be used for the
+ *	connection.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1920,6 +1954,14 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_IFACE_SOCKET_OWNER,
 
+	NL80211_ATTR_AUTHORIZATION_STATUS,
+	NL80211_ATTR_KEY_REPLAY_CTR,
+	NL80211_ATTR_PSK,
+	NL80211_ATTR_OFFLOAD_KEY_MGMT,
+	NL80211_ATTR_KEY_MGMT_OFFLOAD_SUPPORT,
+	NL80211_ATTR_KEY_DERIVE_OFFLOAD_SUPPORT,
+	NL80211_ATTR_PMK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4145,4 +4187,64 @@ enum nl80211_tdls_peer_capability {
 	NL80211_TDLS_PEER_WMM = 1<<2,
 };
 
+#define NL80211_KEY_LEN_PSK				32
+#define NL80211_KEY_LEN_PMK				32
+#define NL80211_KEY_REPLAY_CTR_LEN		8
+
+/**
+ * enum nl80211_key_mgmt_offload_support - key management offload types
+ *
+ * Supported types of device key management offload.  Allows device
+ * to advertise types of connections where it can offload establishment
+ * of temporal keys during initial RSN connection or after roaming.
+ *
+ * @NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PSK: WPA/WPA2 PSK key management.
+ *	The NL80211_ATTR_PSK attribute is passed in NL80211_CMD_CONNECT.
+ * @NL80211_KEY_MGMT_OFFLOAD_SUPPORT_FT_PSK: 802.11r (FT) PSK key
+ *	management.  The NL80211_ATTR_PSK attribute is passed in
+ *	NL80211_CMD_CONNECT.
+ * @NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PMKSA: Key management on already
+ *	established PMKSA.  The PMK will be passed using
+ *	NL80211_CMD_KEY_MGMT_SET_PMK once it is known.
+ */
+enum nl80211_key_mgmt_offload_support {
+	NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PSK	= 1 << 0,
+	NL80211_KEY_MGMT_OFFLOAD_SUPPORT_FT_PSK	= 1 << 1,
+	NL80211_KEY_MGMT_OFFLOAD_SUPPORT_PMKSA	= 1 << 2,
+};
+
+/**
+ * enum nl80211_key_derive_offload_support - key derivation offload types
+ *
+ * Supported types of device key derivation used as part of key
+ * management offload.  Assumes that GTK key derivation is supported
+ * by default for all supported key management offload types.
+ *
+ * @NL80211_KEY_DERIVE_OFFLOAD_SUPPORT_IGTK: IGTK key derivation.
+ */
+enum nl80211_key_derive_offload_support {
+	NL80211_KEY_DERIVE_OFFLOAD_SUPPORT_IGTK	= 1 << 0,
+};
+
+/**
+ * enum nl80211_authorization_status - key management offload status
+ *
+ * Status of key management offload.  Provided as part of
+ * NL80211_CMD_AUTHORIZATION_EVENT.
+ *
+ * @NL80211_CONNECTED: Device did not successfully offload key
+ *	management.  Supplicant should expect to do the security
+ *	exchange necessary to establish the temporal keys for the
+ *	connection.
+ * @NL80211_AUTHORIZED: Device successfully offloaded key
+ *	management and established temporal keys for the connection,
+ *	signfiying that the initial connection, roaming, or PTK
+ *	rekeying is complete.  Supplicant should enter the
+ *	authorized state for the port.
+ */
+enum nl80211_authorization_status {
+	NL80211_CONNECTED,
+	NL80211_AUTHORIZED,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0f1b18f2..fc3105c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -386,6 +386,16 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFACE_SOCKET_OWNER] = { .type = NLA_FLAG },
+	[NL80211_ATTR_AUTHORIZATION_STATUS] = { .type = NLA_U8 },
+	[NL80211_ATTR_KEY_REPLAY_CTR] = { .type = NLA_BINARY,
+				   .len = NL80211_KEY_REPLAY_CTR_LEN },
+	[NL80211_ATTR_PSK] = { .type = NLA_BINARY,
+				   .len = NL80211_KEY_LEN_PSK },
+	[NL80211_ATTR_OFFLOAD_KEY_MGMT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_KEY_MGMT_OFFLOAD_SUPPORT] = { .type = NLA_U32 },
+	[NL80211_ATTR_KEY_DERIVE_OFFLOAD_SUPPORT] = { .type = NLA_U32 },
+	[NL80211_ATTR_PMK] = { .type = NLA_BINARY,
+				   .len = NL80211_KEY_LEN_PMK },
 };
 
 /* policy for the key attributes */
@@ -1293,6 +1303,13 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if ((rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
+		if ((dev->wiphy.flags & WIPHY_FLAG_HAS_KEY_MGMT_OFFLOAD) &&
+		    (nla_put_u32(msg, NL80211_ATTR_KEY_MGMT_OFFLOAD_SUPPORT,
+				 dev->wiphy.key_mgmt_offload_support) ||
+		     nla_put_u32(msg, NL80211_ATTR_KEY_DERIVE_OFFLOAD_SUPPORT,
+				 dev->wiphy.key_derive_offload_support)))
+			goto nla_put_failure;
+
 		state->split_start++;
 		if (state->split)
 			break;
@@ -7191,6 +7208,12 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(connect.vht_capa));
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_OFFLOAD_KEY_MGMT]))
+		connect.flags |= ASSOC_REQ_OFFLOAD_KEY_MGMT;
+
+	if (info->attrs[NL80211_ATTR_PSK])
+		connect.psk = nla_data(info->attrs[NL80211_ATTR_PSK]);
+
 	wdev_lock(dev->ieee80211_ptr);
 	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
@@ -9289,6 +9312,23 @@ static int nl80211_set_qos_map(struct sk_buff *skb,
 	return ret;
 }
 
+static int nl80211_key_mgmt_set_pmk(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u8 *pmk;
+
+	if (info->attrs[NL80211_ATTR_PMK])
+		pmk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+	else
+		return -EINVAL;
+
+	if (!rdev->ops->key_mgmt_set_pmk)
+		return -EOPNOTSUPP;
+
+	return rdev_key_mgmt_set_pmk(rdev, dev, pmk);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -10029,6 +10069,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_KEY_MGMT_SET_PMK,
+		.doit = nl80211_key_mgmt_set_pmk,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
@@ -11820,6 +11868,56 @@ void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 	nlmsg_free(msg);
 }
 
+void cfg80211_authorization_event(struct net_device *dev,
+				  enum nl80211_authorization_status auth_status,
+				  const u8 *key_replay_ctr,
+				  gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	/* Valid only in SME_CONNECTED state */
+	if (wdev->sme_state != CFG80211_SME_CONNECTED)
+		return;
+
+	trace_cfg80211_authorization_event(wdev->wiphy, dev, auth_status);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_AUTHORIZATION_EVENT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put_u8(msg, NL80211_ATTR_AUTHORIZATION_STATUS, auth_status) ||
+		nla_put(msg, NL80211_ATTR_KEY_REPLAY_CTR,
+			  NL80211_KEY_REPLAY_CTR_LEN, key_replay_ctr))
+		goto nla_put_failure;
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_authorization_event);
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 00cdf73..737f091 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -963,4 +963,16 @@ rdev_set_ap_chanwidth(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_key_mgmt_set_pmk(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev, u8 *pmk)
+{
+	int ret;
+
+	trace_rdev_key_mgmt_set_pmk(&rdev->wiphy, dev, pmk);
+	ret = rdev->ops->key_mgmt_set_pmk(&rdev->wiphy, dev, pmk);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f3c13ff..76984c3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2636,6 +2636,29 @@ TRACE_EVENT(cfg80211_ft_event,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(target_ap))
 );
 
+DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_key_mgmt_set_pmk,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *pmk),
+	TP_ARGS(wiphy, netdev, pmk)
+);
+
+TRACE_EVENT(cfg80211_authorization_event,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 enum nl80211_authorization_status auth_status),
+	TP_ARGS(wiphy, netdev, auth_status),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(enum nl80211_authorization_status, auth_status)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->auth_status = auth_status;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", auth_status: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->auth_status)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.12.rc0.22.gcdd159b

