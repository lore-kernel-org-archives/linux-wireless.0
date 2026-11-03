Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701270;
	b=RdK57DjUsBtRUwZAowUVdR1dGzfdQ7Mj56OR5YX9MYlFUT4DJe/91WNKoeMiIHVenfH6
	 tzAjE+h+8V4tdubf4V9/PxYxXr+ufmTzzqV2gCsTXqgG/eBs+J12uGOPMFJ55BQmfOWSw
	 XY++ez4TDJAixRNie6h4jO8X64XkTZkfAW1eIBKA+XsCN9icceNAFu/skKxnb9ue6R82c
	 qITk3y/4rqipq5SmSsQNXwNCBJK9aakdWUQIu+f0hzcPE7ctSTBwRtZPcs8fG9eOvOHUs
	 HBVFG1kcxOVbDi7RJHQC3gNSwUXSFm4X5vAHugQIbPN9QYHLxbQI17oa3VrNV6bAdmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701270;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DiJ7c3DH94g4PPOYMuYG5KlPD0pT8/QUOTw8cKhHSkE=;
	b=ar1KO7MuSg2Vb728TudZz6j8upUVEVUiDYChBcA/AYyw4zGDSP6UGfQ0y3K0129HS3pu
	 7Ohi3iLTgZkfrGt8V0yRRTGyhWrJxbazzXl3M4v/N22d2DWoHAjgkOj3THUEG0c+YhuoN
	 gUcScww3LH0DQcIhTeYeBL8315k+toGHvkNwuGkToOlHd9VTtHbquJttdAKxYLkcW5jQ7
	 ZhjZ4O3NNhClvNm3KFmnrwzDOHJKpYmO8LYsFNsAVxKEiT5zrsjgE16EfWDU7nIjk7P8r
	 ixPwilb0O1uv445Wq7RC9S+/Xgyci18QCai76RS6ZsBZsmh7i34pCfzi17Z/FkAi2Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ufGwE5yq;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C33606A814
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 10:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ufGwE5yq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=DiJ7c3DH94g4PPOYMuYG5KlPD0pT8/QUOTw8cKhHSkE=; t=1793701268; x=1794910868; 
	b=ufGwE5yqP6zCvnpkitE+amYLpLL6p+OmBK5cEk8VGI+N+GfDlK+cXnqRv3rfbO2C2MKBCi4/Kf7
	F4524viWilfqxtGjLSBdkT4SS5gkQleQTkIIe0QpAdBJxEcYUTzUf0Cej39rgmcfvk9ATM35xayZK
	mOqWq33+4ETo6D7QTJ56XmJYA8LnVvPcpmV8LyLJnimnQMyOAgv/hV5BrzMU8WAYMxmJUoRx0ayca
	TnFScIswCTgliCSJluBkDKLB4JVSWZxElGcu4PYKDccUIZJ3Mbtzoh2QpAKc+QehFNcGsxX1YXss3
	cIkeIJCOly54vFtASPW3NCYbzNqsmjrDloUA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOBdY-00000003Hdj-3hBf;
	Tue, 03 Nov 2026 11:21:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 wireless-next] wifi: cfg80211: add APIs for SMD transition
Date: Tue,  3 Nov 2026 11:21:02 +0100
Message-ID: <20261103112102.a1b53635b494.Id451626c78a925e85aaf2598ab471120940a91c7@changeid>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Add the APIs necessary to prepare and abandon or execute SMD
transitions. The downlink draining TID bitmap may be specified
by userspace; the execution mode (current or target AP MLD) is
by driver choice (but may be overridden by debugfs).

Some additional APIs handle channel switching while already in
prepared state, and abandoning just some links when removed.

Document the intended behaviour and how keys are handled etc.
in a new documentation section.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: remove array parameter in tracing to avoid compiler warnings
v3: really do that in all places ...
---
 include/net/cfg80211.h       | 235 ++++++++++++++++++++++++
 include/uapi/linux/nl80211.h |  96 ++++++++++
 net/wireless/core.c          |   7 +
 net/wireless/core.h          |   4 +
 net/wireless/mlme.c          | 226 +++++++++++++++++++++--
 net/wireless/nl80211.c       | 340 ++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h       |  11 ++
 net/wireless/rdev-ops.h      |  42 +++++
 net/wireless/scan.c          |   7 +-
 net/wireless/trace.h         | 228 +++++++++++++++++++++++
 10 files changed, 1180 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 46ba0fb27b14..ead6d8627f6b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3496,6 +3496,52 @@ struct cfg80211_assoc_request {
 	u16 ext_mld_capa_ops;
 };
 
+/**
+ * struct cfg80211_st_prep_request - SMD transition preparation request data
+ *
+ * This structure provides the information needed to prepare an SMD transition
+ * to a new AP MLD within the SMD.
+ *
+ * See the nl80211 documentation for link order and element inheritance.
+ *
+ * @links: Per-link information for the target AP MLD's links; the BSS pointer
+ *	is set for each link that is part of the transition.
+ *	Link BSSes must be passed back in either preparation response
+ *	(for failed links), transition switch callback (after successful
+ *	transition), or to the abandon callback.
+ * @ap_mld_addr: AP MLD address of the target AP MLD within the SMD
+ * @elems: extra elements to include in the UHR link reconfiguration request
+ * @elems_len: length of @elems
+ * @ext_mld_capa_ops: extended MLD capabilities and operations set by
+ *	userspace for the UHR link reconfiguration request
+ */
+struct cfg80211_st_prep_request {
+	struct cfg80211_assoc_link links[IEEE80211_MLD_MAX_NUM_LINKS];
+	const u8 *ap_mld_addr;
+	const u8 *elems;
+	size_t elems_len;
+	u16 ext_mld_capa_ops;
+};
+
+/**
+ * struct cfg80211_st_exec_request - SMD transition execution request data
+ *
+ * This structure provides the information needed to execute a previously
+ * prepared SMD transition.
+ *
+ * @ap_mld_addr: AP MLD address of the target AP MLD within the SMD
+ * @drain_tids: bitmap of TIDs that are requested to be drained during the
+ *	transition
+ * @elems: extra elements to include in the UHR link reconfiguration request
+ * @elems_len: length of @elems
+ */
+struct cfg80211_st_exec_request {
+	const u8 *ap_mld_addr;
+	u8 drain_tids;
+	const u8 *elems;
+	size_t elems_len;
+};
+
 /**
  * struct cfg80211_deauth_request - Deauthentication request data
  *
@@ -4924,6 +4970,12 @@ struct mgmt_frame_regs {
  *	For MLO connection, @link_id will be >= 0 for group key and -1 for
  *	pairwise key, @mac_addr will be peer's MLD address for MLO pairwise key.
  *
+ *	Note: If %WIPHY_FLAG_SMD_TRANSITION_CLIENT is set, the link ID cannot
+ *	be validated by cfg80211, since it only tracks link IDs per interface
+ *	and on SMD Transition other link IDs are valid for new keys for the
+ *	new AP MLD. The driver must validate all link IDs, even not during
+ *	SMD Transition, if it supports it.
+ *
  * @get_key: get information about the key with the given parameters.
  *	@mac_addr will be %NULL when requesting information for a group
  *	key. All pointers given to the @callback function need not be valid
@@ -5335,6 +5387,13 @@ struct mgmt_frame_regs {
  *
  * @start_pd: Start the PD interface.
  * @stop_pd: Stop the PD interface.
+ *
+ * @prepare_st: Prepare an SMD transition to the given AP MLD and
+ *	parameters, drivers should return -EBUSY if no more preparations can
+ *	be made, and -EALREADY if the requested AP MLD is already prepared
+ * @execute_st: Execute a previously prepared SMD transition
+ * @abandon_st: Abandon a prepared SMD transition to the given AP MLD.
+ *	If @local_only is true don't send the ST abandon action frame.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -5733,6 +5792,12 @@ struct cfg80211_ops {
 			    bool val);
 	int	(*start_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
 	void	(*stop_pd)(struct wiphy *wiphy, struct wireless_dev *wdev);
+	int	(*prepare_st)(struct wiphy *wiphy, struct net_device *dev,
+			      struct cfg80211_st_prep_request *req);
+	int	(*execute_st)(struct wiphy *wiphy, struct net_device *dev,
+			      struct cfg80211_st_exec_request *req);
+	int	(*abandon_st)(struct wiphy *wiphy, struct net_device *dev,
+			      const u8 *ap_mld_addr, bool local_only);
 };
 
 /*
@@ -5796,6 +5861,8 @@ struct cfg80211_ops {
  *	STA) basis for station and P2P client interfaces.
  *	(Note that if userspace doesn't give the MAC address, the AP's address
  *	is substituted to allow for older userspace versions.)
+ * @WIPHY_FLAG_SMD_TRANSITION_CLIENT: Device supports SMD transition as client,
+ *	setting this requires the required ops to be assigned
  */
 enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK		= BIT(0),
@@ -5823,6 +5890,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 	WIPHY_FLAG_NOTIFY_REGDOM_BY_DRIVER	= BIT(24),
 	WIPHY_FLAG_CHANNEL_CHANGE_ON_BEACON     = BIT(25),
+	WIPHY_FLAG_SMD_TRANSITION_CLIENT	= BIT(26),
 };
 
 /**
@@ -10915,6 +10983,173 @@ struct cfg80211_mlo_reconf_done_data {
 void cfg80211_mlo_reconf_add_done(struct net_device *dev,
 				  struct cfg80211_mlo_reconf_done_data *data);
 
+/**
+ * struct cfg80211_st_preparation_resp_data - SMD transition preparation response data
+ *
+ * @ap_mld_addr: the target AP MLD address the transition was prepared for
+ * @req_elems: the UHR link reconfiguration request frame's elements
+ * @req_elems_len: length of @req_elems
+ * @buf: the UHR link reconfiguration response frame (header + body), or %NULL
+ *	if no response was received (timeout)
+ * @len: length of @buf
+ * @links: for each rejected link (or all for timeout), the BSS that was
+ *	previously passed to the prepare_st() operation; ownership of the
+ *	reference and hold is handed back to cfg80211. Links that were
+ *	accepted must not be set here and remain owned by the driver until
+ *	the transition is completed or abandoned.
+ */
+struct cfg80211_st_preparation_resp_data {
+	const u8 *ap_mld_addr;
+	const u8 *req_elems;
+	size_t req_elems_len;
+	const u8 *buf;
+	size_t len;
+	struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS];
+};
+
+/**
+ * cfg80211_rx_st_preparation_response - notify SMD transition preparation result
+ * @dev: network device
+ * @data: the preparation response data, see &struct cfg80211_st_preparation_resp_data
+ *
+ * Inform userspace about the result of an SMD transition preparation that was
+ * previously requested via the prepare_st() operation. The wiphy mutex must be
+ * held.
+ */
+void cfg80211_rx_st_preparation_response(struct net_device *dev,
+					 struct cfg80211_st_preparation_resp_data *data);
+
+/**
+ * struct cfg80211_st_execution_resp_data - SMD transition execution response data
+ * @ap_mld_addr: the target AP MLD address the transition was executed for
+ * @buf: the response frame (header + body), or %NULL if no response was
+ *	received (timeout)
+ * @len: length of @buf
+ * @links: per-link information for accepted links,
+ *	both bssid/local_addr must be set for accepted links,
+ *	neither for not accepted links
+ * @links.bssid: the BSSID for the link
+ * @links.local_addr: the local address for the link
+ */
+struct cfg80211_st_execution_resp_data {
+	const u8 *ap_mld_addr;
+	const u8 *buf;
+	size_t len;
+	struct {
+		const u8 *bssid;
+		const u8 *local_addr;
+	} links[IEEE80211_MLD_MAX_NUM_LINKS];
+};
+
+/**
+ * cfg80211_rx_st_execution_response - notify SMD transition execution result
+ * @dev: network device
+ * @data: the execution response data, see &struct cfg80211_st_execution_resp_data
+ *
+ * Inform userspace about the result of an SMD transition execution that was
+ * previously requested via the execute_st() operation. The wiphy mutex must
+ * be held.
+ */
+void cfg80211_rx_st_execution_response(struct net_device *dev,
+				       struct cfg80211_st_execution_resp_data *data);
+
+/**
+ * struct cfg80211_st_switched_data - SMD transition switch data
+ * @ap_mld_addr: the AP MLD address connected to now
+ * @links: per-link information for the links of the target AP MLD; both
+ *	bss/addr must be set for the links that are valid after the transition,
+ *	neither for the others
+ * @links.bss: the BSS the station is connected to on this link after the
+ *	transition; cfg80211 installs it as the link's current BSS and takes
+ *	over ownership of the reference and hold that was previously passed to
+ *	the prepare_st() operation
+ * @links.addr: the local address used on this link after the transition
+ */
+struct cfg80211_st_switched_data {
+	const u8 *ap_mld_addr;
+	struct {
+		struct cfg80211_bss *bss;
+		const u8 *addr;
+	} links[IEEE80211_MLD_MAX_NUM_LINKS];
+};
+
+/**
+ * cfg80211_st_switched - indicate that the AP MLD is switched
+ * @dev: network device
+ * @data: the transition switch data, see &struct cfg80211_st_switched_data
+ *
+ * Inform cfg80211 that a previously started SMD Transition switched over to
+ * the target AP MLD, i.e. update the AP MLD address, the per-link BSSes and
+ * the local link addresses. For each link, the given BSS becomes the link's
+ * current BSS, replacing (and releasing) the previous one.
+ *
+ * This is separate from cfg80211_st_done() because for execution with the
+ * target AP MLD, this is done before sending the execution request frame,
+ * which might still fail (and disconnect), but then the switch was already
+ * done and the target AP MLD's link BSSes must be released etc.
+ *
+ * The wiphy mutex must be held.
+ *
+ * After this, cfg80211_st_done() must be called to notify userspace, unless
+ * the transition still failed and the client disconnects.
+ */
+void cfg80211_st_switched(struct net_device *dev,
+			  struct cfg80211_st_switched_data *data);
+
+/**
+ * cfg80211_st_done - notify that an SMD transition took place
+ * @dev: network device
+ *
+ * Inform userspace that a previously executed SMD transition has completed,
+ * using the data that cfg80211_st_switched() previously stored.
+ *
+ * The wiphy mutex must be held.
+ */
+void cfg80211_st_done(struct net_device *dev);
+
+/**
+ * cfg80211_st_abandoned - notify that an SMD transition was abandoned
+ * @dev: network device
+ * @links: for each link, the BSS that was previously passed to the
+ *	prepare_st() operation and is now released; ownership of the
+ *	reference and hold is handed back to cfg80211.
+ *
+ * Inform cfg80211 that a previously prepared SMD transition was abandoned and
+ * will not take place. The given BSSes are released.
+ *
+ * This must be called for any prepared but unused SMD Transition, e.g. on
+ * execution of another, disconnect, and also during the abandon_st() method,
+ * as cfg80211 doesn't track active prepared SMD Transitions.
+ *
+ * It should only be called after cfg80211_rx_st_preparation_response() was
+ * already called, if the preparation was successful but never executed.
+ *
+ * It can also be called for only some of the links, if they're no longer
+ * part of the prepared SMD transition, e.g. if the target AP MLD removed
+ * the corresponding affiliated APs.
+ *
+ * The wiphy mutex must be held.
+ */
+void cfg80211_st_abandoned(struct net_device *dev,
+			   struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS]);
+
+/**
+ * cfg80211_st_update_bss_channel - update the channel of a prepared ST link
+ * @dev: network device
+ * @bss: the BSS of a link of a prepared SMD transition, as previously passed
+ *	to the prepare_st() operation
+ * @chan: the new channel of the BSS
+ *
+ * If the AP of a link of a prepared SMD transition switched channel, update
+ * the channel of the BSS entry accordingly before the SMD transition is
+ * executed.
+ *
+ * The wiphy mutex must be held.
+ */
+void cfg80211_st_update_bss_channel(struct net_device *dev,
+				    struct cfg80211_bss *bss,
+				    struct ieee80211_channel *chan);
+
 /**
  * cfg80211_schedule_channels_check - schedule regulatory check if needed
  * @wdev: the wireless device to check
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b56a96f57bec..97a9dd7588c3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -343,6 +343,64 @@
  * processing of peer DH IE to generate PMK.
  */
 
+/**
+ * DOC: SMD Transition
+ *
+ * If not offloaded, SMD Transition is done via the commands
+ * %NL80211_CMD_PREPARE_SMD_TRANSITION and %NL80211_CMD_EXECUTE_SMD_TRANSITION.
+ *
+ * The original association must have been to the SMD.
+ *
+ * Note that the links are expected to be sent in the UHR link reconfiguration
+ * frame in ascending order of link ID, which is important for element
+ * inheritance, and userspace can make use of receiver inheritance behaviour
+ * by including elements only in the lowest link ID link. Note that currently
+ * there's no mechanism for non-inheritance.
+ *
+ * Upon successful SMD preparation, the underlying driver will create the
+ * station entry with link stations for the new AP MLD, which then allows
+ * the pairwise key to be installed if needed; if per-SMD PTK is used the
+ * driver handles it.
+ *
+ * The result of the preparation is indicated to userspace using the prepare
+ * command as a notification, including
+ *  - %NL80211_ATTR_MLD_ADDR (the requested AP MLD's address)
+ *  - %NL80211_ATTR_REQ_IE (the request frame's elements)
+ *  - %NL80211_ATTR_FRAME (the response frame, if any; if no response was
+ *    received due to a timeout, this attribute is not present)
+ *
+ * There may be a driver-specific limit on how many preparations can be pending
+ * at any given time. Currently, no advertisement of such limits exists as the
+ * initial implementation is intended to proceed to SMD Transition execution
+ * immediately. Drivers should return -EALREADY when there's already one with
+ * the requested AP MLD, and -EBUSY if another preparation isn't possible.
+ *
+ * In case a preparation is no longer used or e.g. MIC failure occurred, it can
+ * be abandoned with the %NL80211_CMD_ABANDON_SMD_TRANSITION command (given the
+ * target AP MLD address).
+ *
+ * After successful SMD preparation, userspace may use the newly created state
+ * by sending the %NL80211_CMD_EXECUTE_SMD_TRANSITION command. This command
+ * includes the target AP MLD address, as well as optionally the
+ * %NL80211_ATTR_TID_BITMAP attribute controlling which downlink TIDs are
+ * requested for draining, if not given all TIDs are requested. If per-AP MLD
+ * PTK mode is used, %NL80211_ATTR_IE needs to carry the MIC element.
+ *
+ * The result of the SMD Transition execution is indicated to userspace in the
+ * %NL80211_CMD_EXECUTE_SMD_TRANSITION event, which also carries AP MLD address
+ * and - except in cases of timeout - the response frame as well as executed
+ * links (%NL80211_ATTR_MLO_LINKS with link ID, BSSID and local link address).
+ * There might be fewer links here if the target AP MLD removed a link between
+ * preparation and execution.
+ *
+ * Given internal state switches, failure or timeout of SMD Transition execution
+ * may lead to disconnection, rather than staying connected to the old AP MLD,
+ * which is then indicated by appropriate disconnect events.
+ *
+ * Any prepared SMD transitions are dropped when disconnecting or executing one
+ * of them.
+ */
+
 /**
  * enum nl80211_commands - supported nl80211 commands
  *
@@ -1468,6 +1526,39 @@
  *	and multiple can be nested in %NL80211_ATTR_MLO_LINKS but then the
  *	update isn't atomic if any failures happen.
  *	Only supported with %NL80211_EXT_FEATURE_UPDATE_BEACON.
+ *
+ * @NL80211_CMD_PREPARE_SMD_TRANSITION: Prepare an SMD transition to a new
+ *	AP MLD in the SMD, which needs to be specified like in an association
+ *	request command (%NL80211_ATTR_MLD_ADDR, %NL80211_ATTR_MLO_LINKS,
+ *	elements can be specified for the UHR link reconfiguration request
+ *	frame, %NL80211_ATTR_IE for the outer frame elements).
+ *	The driver is responsible for sending the link reconfiguration request,
+ *	handling the response, but also forwards the response to userspace to
+ *	handle it. See the SMD Transition documentation section.
+ *	This is also used as an event notification to carry the ST preparation
+ *	response, carrying the target AP MLD address (%NL80211_ATTR_MLD_ADDR),
+ *	response frame (%NL80211_ATTR_FRAME) and request elements
+ *	(%NL80211_ATTR_REQ_IE).
+ * @NL80211_CMD_ABANDON_SMD_TRANSITION: Abandon a prepared SMD transition.
+ *	Requires %NL80211_ATTR_MLD_ADDR identifying the target AP MLD,
+ *	can optionally use %NL80211_ATTR_LOCAL_STATE_CHANGE to not transmit
+ *	a frame.
+ * @NL80211_CMD_EXECUTE_SMD_TRANSITION: Execute an SMD transition that was
+ *	previously prepared. The AP's MLD address must be given (in the
+ *	%NL80211_ATTR_MLD_ADDR attribute).
+ *	This is also used as an event notification to carry the ST execution
+ *	response, carrying the AP MLD address (%NL80211_ATTR_MLD_ADDR), the
+ *	response frame (%NL80211_ATTR_FRAME, except on timeout) and a nested
+ *	%NL80211_ATTR_MLO_LINKS array with the %NL80211_ATTR_MLO_LINK_ID, local
+ *	link address (%NL80211_ATTR_MAC) and %NL80211_ATTR_BSSID each.
+ *
+ * @NL80211_CMD_COMPLETED_SMD_TRANSITION: Notification that a previously
+ *	executed SMD transition has completed and the STA is now connected to
+ *	the target AP MLD. Carries the target AP MLD address
+ *	(%NL80211_ATTR_MLD_ADDR) and the per-link BSSIDs and local link
+ *	addresses (%NL80211_ATTR_MLO_LINKS, each nested link with
+ *	%NL80211_ATTR_MLO_LINK_ID, %NL80211_ATTR_BSSID and %NL80211_ATTR_MAC).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1750,6 +1841,11 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_BEACON,
 
+	NL80211_CMD_PREPARE_SMD_TRANSITION,
+	NL80211_CMD_ABANDON_SMD_TRANSITION,
+	NL80211_CMD_EXECUTE_SMD_TRANSITION,
+	NL80211_CMD_COMPLETED_SMD_TRANSITION,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f4153c249599..711070bdcbac 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1180,6 +1180,13 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 #endif
 
+	if (WARN_ON(wiphy->flags & WIPHY_FLAG_SMD_TRANSITION_CLIENT &&
+		    (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_MLO) ||
+		     !rdev->ops->prepare_st ||
+		     !rdev->ops->execute_st ||
+		     !rdev->ops->abandon_st)))
+		return -EINVAL;
+
 	if (!wiphy->max_num_akm_suites)
 		wiphy->max_num_akm_suites = NL80211_MAX_NR_AKM_SUITES;
 	else if (wiphy->max_num_akm_suites < NL80211_MAX_NR_AKM_SUITES ||
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7318cec3a956..0c5999a4a9e9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -643,6 +643,10 @@ int cfg80211_assoc_ml_reconf(struct cfg80211_registered_device *rdev,
 			     struct net_device *dev,
 			     struct cfg80211_ml_reconf_req *req);
 
+int cfg80211_prepare_st(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			struct cfg80211_st_prep_request *req);
+
 /**
  * struct cfg80211_colocated_ap - colocated AP information
  *
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 80ca9031d29c..99596701cff5 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -211,6 +211,20 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr)
 }
 EXPORT_SYMBOL(cfg80211_auth_timeout);
 
+static void cfg80211_unhold_link_bss_list(struct wiphy *wiphy,
+					  struct cfg80211_bss **links)
+{
+	for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+		struct cfg80211_bss *bss = links[i];
+
+		if (!bss)
+			continue;
+
+		cfg80211_unhold_bss(bss_from_pub(bss));
+		cfg80211_put_bss(wiphy, bss);
+	}
+}
+
 void cfg80211_assoc_failure(struct net_device *dev,
 			    struct cfg80211_assoc_failure *data)
 {
@@ -218,7 +232,6 @@ void cfg80211_assoc_failure(struct net_device *dev,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	const u8 *addr = data->ap_mld_addr ?: data->bss[0]->bssid;
-	int i;
 
 	trace_cfg80211_send_assoc_failure(dev, data);
 
@@ -229,15 +242,7 @@ void cfg80211_assoc_failure(struct net_device *dev,
 		cfg80211_sme_abandon_assoc(wdev);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(data->bss); i++) {
-		struct cfg80211_bss *bss = data->bss[i];
-
-		if (!bss)
-			continue;
-
-		cfg80211_unhold_bss(bss_from_pub(bss));
-		cfg80211_put_bss(wiphy, bss);
-	}
+	cfg80211_unhold_link_bss_list(wiphy, data->bss);
 }
 EXPORT_SYMBOL(cfg80211_assoc_failure);
 
@@ -1577,3 +1582,204 @@ void cfg80211_mlo_reconf_add_done(struct net_device *dev,
 	nl80211_mlo_reconf_add_done(dev, data);
 }
 EXPORT_SYMBOL(cfg80211_mlo_reconf_add_done);
+
+static bool cfg80211_st_check_ssid(struct wireless_dev *wdev,
+				   struct cfg80211_st_prep_request *req)
+{
+	if (!wdev->u.client.ssid_len)
+		return false;
+
+	guard(rcu)();
+
+	for (int link_id = 0; link_id < ARRAY_SIZE(req->links); link_id++) {
+		const struct element *ssid;
+
+		if (!req->links[link_id].bss)
+			continue;
+
+		/*
+		 * Check SSID, but don't bother for hidden networks.
+		 * Yes, this ignores the old-style "zeroed out SSID"
+		 * hidden networks, I _really_ hope those don't exist
+		 * any more ...
+		 */
+		ssid = ieee80211_bss_get_elem(req->links[link_id].bss,
+					      WLAN_EID_SSID);
+		if (!ssid ||
+		    (ssid->datalen &&
+		     (ssid->datalen != wdev->u.client.ssid_len ||
+		      memcmp(ssid->data, wdev->u.client.ssid, ssid->datalen))))
+			return false;
+	}
+
+	return true;
+}
+
+int cfg80211_prepare_st(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			struct cfg80211_st_prep_request *req)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int link_id, err;
+
+	lockdep_assert_wiphy(wdev->wiphy);
+
+	if (!cfg80211_st_check_ssid(wdev, req)) {
+		for (link_id = 0; link_id < ARRAY_SIZE(req->links); link_id++)
+			cfg80211_put_bss(&rdev->wiphy, req->links[link_id].bss);
+		return -EINVAL;
+	}
+
+	/*
+	 * The caller passes ownership of one reference per target BSS; take a
+	 * hold in addition so the BSSes stay in the scan list for the duration
+	 * of the transition. On success ownership of the reference and hold
+	 * passes to the driver, which hands each one back via the preparation
+	 * response (rejected links), the transition switch callback (accepted
+	 * links) or the abandon callback.
+	 */
+	for (link_id = 0; link_id < ARRAY_SIZE(req->links); link_id++) {
+		if (!req->links[link_id].bss)
+			continue;
+		cfg80211_hold_bss(bss_from_pub(req->links[link_id].bss));
+	}
+
+	err = rdev_prepare_st(rdev, dev, req);
+	if (err) {
+		for (link_id = 0; link_id < ARRAY_SIZE(req->links); link_id++) {
+			if (!req->links[link_id].bss)
+				continue;
+			cfg80211_unhold_bss(bss_from_pub(req->links[link_id].bss));
+			cfg80211_put_bss(&rdev->wiphy, req->links[link_id].bss);
+		}
+	}
+
+	return err;
+}
+
+void cfg80211_rx_st_preparation_response(struct net_device *dev,
+					 struct cfg80211_st_preparation_resp_data *data)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	lockdep_assert_wiphy(wiphy);
+
+	trace_cfg80211_rx_st_preparation_response(dev, data->ap_mld_addr,
+						  data->buf, data->len,
+						  data->links);
+
+	if (WARN_ON(!wdev->valid_links))
+		return;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
+		return;
+
+	/* release the rejected links handed back by the driver */
+	cfg80211_unhold_link_bss_list(wiphy, data->links);
+
+	nl80211_st_preparation_response(rdev, dev, data);
+}
+EXPORT_SYMBOL(cfg80211_rx_st_preparation_response);
+
+void cfg80211_rx_st_execution_response(struct net_device *dev,
+				       struct cfg80211_st_execution_resp_data *data)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	lockdep_assert_wiphy(wiphy);
+
+	trace_cfg80211_rx_st_execution_response(dev, data);
+
+	if (WARN_ON(!wdev->valid_links))
+		return;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
+		return;
+
+	nl80211_st_execution_response(rdev, dev, data);
+}
+EXPORT_SYMBOL(cfg80211_rx_st_execution_response);
+
+void cfg80211_st_switched(struct net_device *dev,
+			  struct cfg80211_st_switched_data *data)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+
+	lockdep_assert_wiphy(wiphy);
+
+	trace_cfg80211_st_switched(dev, data);
+
+	if (WARN_ON(!wdev->valid_links))
+		return;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
+		return;
+
+	ether_addr_copy(wdev->u.client.connected_addr, data->ap_mld_addr);
+
+	cfg80211_wdev_release_link_bsses(wdev, ~0);
+
+	for (int link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
+		struct cfg80211_bss *bss = data->links[link_id].bss;
+
+		if (!bss)
+			continue;
+		wdev->links[link_id].client.current_bss = bss_from_pub(bss);
+		if (!WARN_ON(!data->links[link_id].addr))
+			ether_addr_copy(wdev->links[link_id].addr,
+					data->links[link_id].addr);
+		wdev->valid_links |= BIT(link_id);
+	}
+}
+EXPORT_SYMBOL(cfg80211_st_switched);
+
+void cfg80211_st_done(struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	lockdep_assert_wiphy(wiphy);
+
+	trace_cfg80211_st_done(dev);
+
+	if (WARN_ON(!wdev->valid_links))
+		return;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
+		return;
+
+	nl80211_st_done(rdev, dev);
+}
+EXPORT_SYMBOL(cfg80211_st_done);
+
+void cfg80211_st_abandoned(struct net_device *dev,
+			   struct cfg80211_bss *links[IEEE80211_MLD_MAX_NUM_LINKS])
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+
+	lockdep_assert_wiphy(wiphy);
+
+	trace_cfg80211_st_abandoned(dev, links);
+
+	if (WARN_ON(!wdev->valid_links))
+		return;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
+		return;
+
+	/* release the links handed back by the driver */
+	cfg80211_unhold_link_bss_list(wiphy, links);
+}
+EXPORT_SYMBOL(cfg80211_st_abandoned);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..6fb0b197e893 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3415,6 +3415,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			if (rdev->wiphy.sar_capa)
 				CMD(set_sar_specs, SET_SAR_SPECS);
 			CMD(assoc_ml_reconf, ASSOC_MLO_RECONF);
+
+			if (rdev->wiphy.flags & WIPHY_FLAG_SMD_TRANSITION_CLIENT)
+				CMD(execute_st, EXECUTE_SMD_TRANSITION);
 		}
 #undef CMD
 
@@ -5439,6 +5442,8 @@ static int nl80211_validate_key_link_id(struct genl_info *info,
 					struct wireless_dev *wdev,
 					int link_id, bool pairwise)
 {
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
 	if (pairwise) {
 		if (link_id != -1) {
 			GENL_SET_ERR_MSG(info,
@@ -5455,7 +5460,9 @@ static int nl80211_validate_key_link_id(struct genl_info *info,
 					 "link ID must be set for MLO group key");
 			return -EINVAL;
 		}
-		if (!(wdev->valid_links & BIT(link_id))) {
+		/* for SMD transition support the driver must check itself */
+		if (!(wdev->valid_links & BIT(link_id)) &&
+		    !(rdev->wiphy.flags & WIPHY_FLAG_SMD_TRANSITION_CLIENT)) {
 			GENL_SET_ERR_MSG(info, "invalid link ID for MLO group key");
 			return -EINVAL;
 		}
@@ -20018,6 +20025,148 @@ nl80211_epcs_cfg(struct sk_buff *skb, struct genl_info *info)
 	return rdev_set_epcs(rdev, dev, val);
 }
 
+static int nl80211_prepare_st(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_st_prep_request req = {};
+	bool have_link = false;
+	int err;
+
+	if (!wdev->valid_links)
+		return -EINVAL;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SMD_TRANSITION_CLIENT))
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR] ||
+	    !info->attrs[NL80211_ATTR_MLO_LINKS])
+		return -EINVAL;
+
+	req.ap_mld_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+
+	if (ether_addr_equal(req.ap_mld_addr, wdev->u.client.connected_addr))
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		req.elems = nla_data(info->attrs[NL80211_ATTR_IE]);
+		req.elems_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	if (info->attrs[NL80211_ATTR_EXT_MLD_CAPA_AND_OPS])
+		req.ext_mld_capa_ops =
+			nla_get_u16(info->attrs[NL80211_ATTR_EXT_MLD_CAPA_AND_OPS]);
+
+	err = nl80211_process_links(rdev, req.links,
+				    IEEE80211_MLD_MAX_NUM_LINKS,
+				    NULL, 0, info);
+	if (err)
+		goto free;
+
+	for (int link_id = 0; link_id < ARRAY_SIZE(req.links); link_id++) {
+		if (req.links[link_id].bss) {
+			have_link = true;
+			break;
+		}
+	}
+
+	if (!have_link) {
+		err = -EINVAL;
+		goto free;
+	}
+
+	return cfg80211_prepare_st(rdev, dev, &req);
+free:
+	for (int link_id = 0; link_id < ARRAY_SIZE(req.links); link_id++)
+		cfg80211_put_bss(&rdev->wiphy, req.links[link_id].bss);
+	return err;
+}
+
+static int nl80211_execute_st(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_st_exec_request req = {
+		.drain_tids = 0xFF, /* only 8 TIDs in ST preparation */
+	};
+
+	if (!wdev->valid_links)
+		return -EINVAL;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SMD_TRANSITION_CLIENT))
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR])
+		return -EINVAL;
+
+	req.ap_mld_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+
+	if (info->attrs[NL80211_ATTR_TID_BITMAP]) {
+		u16 drain_tids =
+			nla_get_u16(info->attrs[NL80211_ATTR_TID_BITMAP]);
+
+		if (drain_tids > 0xFF)
+			return -EINVAL;
+
+		req.drain_tids = drain_tids;
+	}
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		req.elems = nla_data(info->attrs[NL80211_ATTR_IE]);
+		req.elems_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	return rdev_execute_st(rdev, dev, &req);
+}
+
+static int nl80211_abandon_st(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const u8 *ap_mld_addr;
+
+	if (!wdev->valid_links)
+		return -EINVAL;
+
+	if (dev->ieee80211_ptr->conn_owner_nlportid &&
+	    dev->ieee80211_ptr->conn_owner_nlportid != info->snd_portid)
+		return -EPERM;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SMD_TRANSITION_CLIENT))
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MLD_ADDR])
+		return -EINVAL;
+
+	ap_mld_addr = nla_data(info->attrs[NL80211_ATTR_MLD_ADDR]);
+
+	return rdev_abandon_st(rdev, dev, ap_mld_addr,
+			       info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE]);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -21367,6 +21516,24 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
+	{
+		.cmd = NL80211_CMD_PREPARE_SMD_TRANSITION,
+		.doit = nl80211_prepare_st,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
+	{
+		.cmd = NL80211_CMD_EXECUTE_SMD_TRANSITION,
+		.doit = nl80211_execute_st,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
+	{
+		.cmd = NL80211_CMD_ABANDON_SMD_TRANSITION,
+		.doit = nl80211_abandon_st,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -21709,6 +21876,7 @@ struct nl80211_mlme_event {
 	const u8 *req_ies;
 	size_t req_ies_len;
 	bool reconnect;
+	const u8 *mld_addr;
 };
 
 static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
@@ -21731,12 +21899,17 @@ static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
-	    nla_put(msg, NL80211_ATTR_FRAME, event->buf_len, event->buf) ||
+	    (event->buf_len &&
+	     nla_put(msg, NL80211_ATTR_FRAME, event->buf_len, event->buf)) ||
 	    (event->req_ies &&
 	     nla_put(msg, NL80211_ATTR_REQ_IE, event->req_ies_len,
 		     event->req_ies)))
 		goto nla_put_failure;
 
+	if (event->mld_addr &&
+	    nla_put(msg, NL80211_ATTR_MLD_ADDR, ETH_ALEN, event->mld_addr))
+		goto nla_put_failure;
+
 	if (event->reconnect &&
 	    nla_put_flag(msg, NL80211_ATTR_RECONNECT_REQUESTED))
 		goto nla_put_failure;
@@ -22288,6 +22461,169 @@ void nl80211_mlo_reconf_add_done(struct net_device *dev,
 	nl80211_send_mlme_event(rdev, dev, &event, GFP_KERNEL);
 }
 
+void nl80211_st_preparation_response(struct cfg80211_registered_device *rdev,
+				     struct net_device *dev,
+				     struct cfg80211_st_preparation_resp_data *data)
+{
+	struct nl80211_mlme_event event = {
+		.cmd = NL80211_CMD_PREPARE_SMD_TRANSITION,
+		.buf = data->buf,
+		.buf_len = data->len,
+		.req_ies = data->req_elems,
+		.req_ies_len = data->req_elems_len,
+		.mld_addr = data->ap_mld_addr,
+	};
+
+	nl80211_send_mlme_event(rdev, dev, &event, GFP_KERNEL);
+}
+
+void nl80211_st_execution_response(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct cfg80211_st_execution_resp_data *data)
+{
+	size_t link_info_size = NLA_HDRLEN +
+				nla_total_size(sizeof(u8)) +
+				nla_total_size(ETH_ALEN) +
+				nla_total_size(ETH_ALEN);
+	struct nlattr *nested;
+	struct sk_buff *msg;
+	int link_count = 0;
+	void *hdr;
+	int i = 1;
+
+	for (unsigned int link = 0; link < IEEE80211_MLD_MAX_NUM_LINKS; link++) {
+		if (!data->links[link].bssid ||
+		    WARN_ON(!data->links[link].local_addr))
+			continue;
+
+		link_count++;
+	}
+
+	msg = nlmsg_new(100 + data->len + link_info_size * link_count,
+			GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_EXECUTE_SMD_TRANSITION);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MLD_ADDR, ETH_ALEN, data->ap_mld_addr))
+		goto nla_put_failure;
+
+	if (!data->len)
+		goto send;
+
+	if (nla_put(msg, NL80211_ATTR_FRAME, data->len, data->buf))
+		goto nla_put_failure;
+
+	nested = nla_nest_start(msg, NL80211_ATTR_MLO_LINKS);
+	if (!nested)
+		goto nla_put_failure;
+
+	for (unsigned int link = 0; link < IEEE80211_MLD_MAX_NUM_LINKS; link++) {
+		const u8 *bssid = data->links[link].bssid;
+		const u8 *local_addr = data->links[link].local_addr;
+		struct nlattr *nested_mlo_links;
+
+		if (!bssid || !local_addr)
+			continue;
+
+		nested_mlo_links = nla_nest_start(msg, i);
+		if (!nested_mlo_links)
+			goto nla_put_failure;
+
+		if (nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link) ||
+		    nla_put(msg, NL80211_ATTR_BSSID, ETH_ALEN, bssid) ||
+		    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, local_addr))
+			goto nla_put_failure;
+
+		nla_nest_end(msg, nested_mlo_links);
+		i++;
+	}
+	nla_nest_end(msg, nested);
+
+send:
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	nlmsg_free(msg);
+}
+
+void nl80211_st_done(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct nlattr *nested;
+	struct sk_buff *msg;
+	void *hdr;
+	int i = 1;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0,
+			     NL80211_CMD_COMPLETED_SMD_TRANSITION);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MLD_ADDR, ETH_ALEN,
+		    wdev->u.client.connected_addr))
+		goto nla_put_failure;
+
+	nested = nla_nest_start(msg, NL80211_ATTR_MLO_LINKS);
+	if (!nested)
+		goto nla_put_failure;
+
+	for (unsigned int link = 0; link < IEEE80211_MLD_MAX_NUM_LINKS; link++) {
+		struct cfg80211_internal_bss *bss;
+		struct nlattr *nested_mlo_links;
+
+		if (!(wdev->valid_links & BIT(link)))
+			continue;
+
+		bss = wdev->links[link].client.current_bss;
+		if (WARN_ON(!bss))
+			continue;
+
+		nested_mlo_links = nla_nest_start(msg, i);
+		if (!nested_mlo_links)
+			goto nla_put_failure;
+
+		if (nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link) ||
+		    nla_put(msg, NL80211_ATTR_BSSID, ETH_ALEN, bss->pub.bssid) ||
+		    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN,
+			    wdev->links[link].addr))
+			goto nla_put_failure;
+
+		nla_nest_end(msg, nested_mlo_links);
+		i++;
+	}
+	nla_nest_end(msg, nested);
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	nlmsg_free(msg);
+}
+
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index bdb065d14054..1e75b38ad88d 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -129,4 +129,15 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
 void nl80211_mlo_reconf_add_done(struct net_device *dev,
 				 struct cfg80211_mlo_reconf_done_data *data);
 
+void nl80211_st_preparation_response(struct cfg80211_registered_device *rdev,
+				     struct net_device *dev,
+				     struct cfg80211_st_preparation_resp_data *data);
+
+void nl80211_st_execution_response(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct cfg80211_st_execution_resp_data *data);
+
+void nl80211_st_done(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 7b8440c1f697..44a4255bbc03 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1713,4 +1713,46 @@ rdev_set_epcs(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_prepare_st(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev,
+				  struct cfg80211_st_prep_request *req)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	int ret;
+
+	trace_rdev_prepare_st(wiphy, dev, req);
+	ret = rdev->ops->prepare_st(wiphy, dev, req);
+	trace_rdev_return_int(wiphy, ret);
+
+	return ret;
+}
+
+static inline int rdev_execute_st(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev,
+				  struct cfg80211_st_exec_request *req)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	int ret;
+
+	trace_rdev_execute_st(wiphy, dev, req);
+	ret = rdev->ops->execute_st(wiphy, dev, req);
+	trace_rdev_return_int(wiphy, ret);
+
+	return ret;
+}
+
+static inline int rdev_abandon_st(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev,
+				  const u8 *ap_mld_addr, bool local_only)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	int ret;
+
+	trace_rdev_abandon_st(wiphy, dev, ap_mld_addr, local_only);
+	ret = rdev->ops->abandon_st(wiphy, dev, ap_mld_addr, local_only);
+	trace_rdev_return_int(wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ac56338f0f43..0d654fd29fa7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3481,13 +3481,12 @@ void cfg80211_bss_iter(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_bss_iter);
 
-void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
-				     unsigned int link_id,
-				     struct ieee80211_channel *chan)
+static void cfg80211_update_bss_channel(struct wireless_dev *wdev,
+				       struct cfg80211_internal_bss *cbss,
+				       struct ieee80211_channel *chan)
 {
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_internal_bss *cbss = wdev->links[link_id].client.current_bss;
 	struct cfg80211_internal_bss *new = NULL;
 	struct cfg80211_internal_bss *bss;
 	struct cfg80211_bss *nontrans_bss;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 31000ffebe43..b0ff3cc4176d 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3281,6 +3281,84 @@ TRACE_EVENT(rdev_set_epcs,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->val)
 );
 
+TRACE_EVENT(rdev_prepare_st,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_st_prep_request *req),
+	TP_ARGS(wiphy, netdev, req),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(ap_mld_addr)
+		__field(u16, link_mask)
+		__array(u8, bssids, IEEE80211_MLD_MAX_NUM_LINKS * ETH_ALEN)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(ap_mld_addr, req->ap_mld_addr);
+
+		__entry->link_mask = 0;
+
+		memset(__entry->bssids, 0, sizeof(__entry->bssids));
+		for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+			if (!req->links[i].bss)
+				continue;
+			__entry->link_mask |= BIT(i);
+			memcpy(__entry->bssids + i * ETH_ALEN,
+			       req->links[i].bss->bssid, ETH_ALEN);
+		}
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", ap_mld_addr: %pM, link_mask: 0x%x",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->ap_mld_addr,
+		  __entry->link_mask)
+);
+
+TRACE_EVENT(rdev_execute_st,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_st_exec_request *req),
+	TP_ARGS(wiphy, netdev, req),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(ap_mld_addr)
+		__field(u8, drain_tids)
+		__dynamic_array(u8, elems, req->elems_len)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(ap_mld_addr, req->ap_mld_addr);
+		__entry->drain_tids = req->drain_tids;
+		if (req->elems)
+			memcpy(__get_dynamic_array(elems),
+			       req->elems, req->elems_len);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", ap_mld_addr: %pM, drain_tids: 0x%x, elems_len: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->ap_mld_addr,
+		  __entry->drain_tids, __get_dynamic_array_len(elems))
+);
+
+TRACE_EVENT(rdev_abandon_st,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *ap_mld_addr, bool local),
+	TP_ARGS(wiphy, netdev, ap_mld_addr, local),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(ap_mld_addr)
+		__field(bool, local)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(ap_mld_addr, ap_mld_addr);
+		__entry->local = local;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", ap_mld_addr: %pM, local:%d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->ap_mld_addr,
+		  __entry->local)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
@@ -4474,6 +4552,156 @@ TRACE_EVENT(cfg80211_nan_channel_evac,
 	TP_printk(WDEV_PR_FMT ", " WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT,
 		  WDEV_PR_ARG, WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
 );
+
+TRACE_EVENT(cfg80211_rx_st_preparation_response,
+	TP_PROTO(struct net_device *netdev, const u8 *ap_mld_addr,
+		 const u8 *buf, size_t len,
+		 struct cfg80211_bss **links),
+	TP_ARGS(netdev, ap_mld_addr, buf, len, links),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(ap_mld_addr)
+		__dynamic_array(u8, frame, len)
+		__field(u16, rejected_links)
+		__array(u8, bssids, IEEE80211_MLD_MAX_NUM_LINKS * ETH_ALEN)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(ap_mld_addr, ap_mld_addr);
+		if (buf)
+			memcpy(__get_dynamic_array(frame), buf, len);
+
+		__entry->rejected_links = 0;
+
+		memset(__entry->bssids, 0, sizeof(__entry->bssids));
+		for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+			if (!links[i])
+				continue;
+			__entry->rejected_links |= BIT(i);
+			memcpy(__entry->bssids + i * ETH_ALEN,
+			       links[i]->bssid, ETH_ALEN);
+		}
+	),
+	TP_printk(NETDEV_PR_FMT ", ap_mld_addr: %pM, frame_len: %u, rejected_links: 0x%x",
+		  NETDEV_PR_ARG, __entry->ap_mld_addr,
+		  __get_dynamic_array_len(frame), __entry->rejected_links)
+);
+
+TRACE_EVENT(cfg80211_rx_st_execution_response,
+	TP_PROTO(struct net_device *netdev,
+		 struct cfg80211_st_execution_resp_data *data),
+	TP_ARGS(netdev, data),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(ap_mld_addr)
+		__dynamic_array(u8, frame, data->len)
+		__field(u16, links)
+		__array(u8, bssids, IEEE80211_MLD_MAX_NUM_LINKS * ETH_ALEN)
+		__array(u8, local_addrs, IEEE80211_MLD_MAX_NUM_LINKS * ETH_ALEN)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(ap_mld_addr, data->ap_mld_addr);
+		if (data->buf)
+			memcpy(__get_dynamic_array(frame), data->buf, data->len);
+
+		__entry->links = 0;
+
+		memset(__entry->bssids, 0, sizeof(__entry->bssids));
+		memset(__entry->local_addrs, 0, sizeof(__entry->local_addrs));
+		for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+			if (!data->links[i].bssid || !data->links[i].local_addr)
+				continue;
+			__entry->links |= BIT(i);
+			memcpy(__entry->bssids + i * ETH_ALEN,
+			       data->links[i].bssid, ETH_ALEN);
+			memcpy(__entry->local_addrs + i * ETH_ALEN,
+			       data->links[i].local_addr, ETH_ALEN);
+		}
+	),
+	TP_printk(NETDEV_PR_FMT ", ap_mld_addr: %pM, frame_len: %u, links: 0x%x",
+		  NETDEV_PR_ARG, __entry->ap_mld_addr,
+		  __get_dynamic_array_len(frame), __entry->links)
+);
+
+DECLARE_EVENT_CLASS(cfg80211_st_evt,
+	TP_PROTO(struct net_device *netdev,
+		 struct cfg80211_bss **links),
+	TP_ARGS(netdev, links),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		__field(u16, links)
+		__array(u8, bssids, IEEE80211_MLD_MAX_NUM_LINKS * ETH_ALEN)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+
+		__entry->links = 0;
+
+		memset(__entry->bssids, 0, sizeof(__entry->bssids));
+		for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+			if (!links[i])
+				continue;
+			__entry->links |= BIT(i);
+			memcpy(__entry->bssids + i * ETH_ALEN,
+			       links[i]->bssid, ETH_ALEN);
+		}
+	),
+	TP_printk(NETDEV_PR_FMT ", links: 0x%x",
+		  NETDEV_PR_ARG, __entry->links)
+);
+
+TRACE_EVENT(cfg80211_st_switched,
+	TP_PROTO(struct net_device *netdev,
+		 struct cfg80211_st_switched_data *data),
+	TP_ARGS(netdev, data),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(ap_mld_addr)
+		__field(u16, links)
+		__array(u8, bssids, IEEE80211_MLD_MAX_NUM_LINKS * ETH_ALEN)
+		__array(u8, addrs, IEEE80211_MLD_MAX_NUM_LINKS * ETH_ALEN)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(ap_mld_addr, data->ap_mld_addr);
+
+		__entry->links = 0;
+
+		memset(__entry->bssids, 0, sizeof(__entry->bssids));
+		memset(__entry->addrs, 0, sizeof(__entry->addrs));
+		for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
+			if (!data->links[i].bss)
+				continue;
+			__entry->links |= BIT(i);
+			memcpy(__entry->bssids + i * ETH_ALEN,
+			       data->links[i].bss->bssid, ETH_ALEN);
+			if (data->links[i].addr)
+				memcpy(__entry->addrs + i * ETH_ALEN,
+				       data->links[i].addr, ETH_ALEN);
+		}
+	),
+	TP_printk(NETDEV_PR_FMT ", ap_mld_addr: %pM, links: 0x%x",
+		  NETDEV_PR_ARG, __entry->ap_mld_addr, __entry->links)
+);
+
+TRACE_EVENT(cfg80211_st_done,
+	TP_PROTO(struct net_device *netdev),
+	TP_ARGS(netdev),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+	),
+	TP_printk(NETDEV_PR_FMT, NETDEV_PR_ARG)
+);
+
+DEFINE_EVENT(cfg80211_st_evt, cfg80211_st_abandoned,
+	TP_PROTO(struct net_device *netdev,
+		 struct cfg80211_bss **links),
+	TP_ARGS(netdev, links)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.56.0

