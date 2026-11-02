Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793658206;
	b=okxNt+RnLXKLX3JElhzfxokiS3ivOu3qlxdHbZFTCBzzuwrJ3Y4XfTgXXrTXphvF/568
	 WdegmFskI/MXgbeFixr2DoPsZt+sDhXn94dsKDwFfaMhJ6ERkaVAnr/5e4ggdI18W6D7s
	 QaJ4KKNOKDapOFq8ql5A/zw/uVwNX3BE8SGhMlmdI+VuOYeuBFk9G58P/a0MkOaFMrpll
	 OeYga0bM6vm5/C49u4/rBP7cWgFr1BlmH2cRKmR4AG9KAGtT/AUGMGPhh7DBggvee972G
	 DA8rA+y8dGZQsNHRm4gWMTCTS/uHJQDg18WEgJnrmKO9XPgTpYWAqWddu81iQheuqPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658206;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4RZBeR6aOnmKf4jF/yKr66I4UczIwxCD2n3e4WCY4l4=;
	b=JTwZs2rGJ3o3kPDBDOa6ZYhFfnTmqogArcA103IbH4+GzxWHEWAYKd+S2DMl92f/pW8j
	 GK3OGL6+lc2WPjWRisep3iYNEMzfGAwnPuVEBKZ2MC5YO1uH8kUchaYqkIMsDQUQgexIL
	 AU6D9jwUAvYXd7lW7LzJljIJ5M8rnJkQw0am1diO/jcQpNoSQKSpaeSttXfbzBWIUnobK
	 U+7yIvihZaRytG/Xgup5T1fOE0XfwVp2uKr9mDKflvqTTL6KRH0U4aAqYSRB2DuiZiCLe
	 rw0SHB2phADJoSRPDIa4iuWqr7HUa3NIPyaghMmRg3AbwnBiBYxfAtSYzUbMYL+oreA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZB2HPMmy;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7FA606A337
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZB2HPMmy
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=4RZBeR6aOnmKf4jF/yKr66I4UczIwxCD2n3e4WCY4l4=; t=1793658205; x=1794867805; 
	b=ZB2HPMmylMR0qCdcl4yci9kw4ftNcez93SyccimdJh19vsBvEgu42faQ3XwmFwqL5jaBy8FAzNf
	9bm18L3EyTxQap8NpZqJfWVnERk0bSBfi9yHCWrULjXoU+by3sN+zb5Gue7Upn2+ECkUMv0cxAXim
	bO6xB/4bY3Sq99aa63L9UklWOhpsP50mplTTQKsZ9UgdJp4uNA2VQ6q2mi+dQmq/vau30OaSzAA6R
	ydq1VQWK2kzgL4rTZXRpihEzfxF+H3YcDysz2IOktKzqq5CpJLvKO0vCAY7aQtRNQ2wGV6xVhs43s
	OQn49UFK0+syJGo5I1unjljyj2q8sluJGSXQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0R0-000000023ve-40GS;
	Mon, 02 Nov 2026 23:23:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [RFC wireless-next] wifi: mac80211: add client-side SMD Transition APIs
Date: Mon,  2 Nov 2026 23:23:17 +0100
Message-ID: <20261102232320.eb102e327049.I3ee08ed4af8d404bf3103780d52eda57014bc020@changeid>
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

Despite being similar to link switching, SMD transition
has a number of differences, and in particular it's not
easy to capture the complexity of vif link changes with
the APIs for link switching.

SMD Transition preparation is done with action frames
exchanged with the current AP MLD, and entirely handled
by mac80211 without driver involvement.

SMD Transition execution must have driver support:
- st_exec() steps through the different phases of SMD
  Transition execution:
  - begin: just before execution request, driver stops
    sending data frames
  - add-links: insert the target AP MLD links (driver
    chooses which ones)
  - move-sta: move necessary state from the old AP STA
    to the new AP STA (blockack sessions, key/PN, ...)
  - move-sta-keys: move station key(s), after new keys
    are installed
  - remove-links: remove old AP MLD links
  - done: transition completed, resume TX to new AP
  - abort: transition aborted, resume TX to old AP
- st_config() is optional but allows driver influence
  over the SMD Transition execution, notably execution
  mode (current/target AP MLD)

The full transition also involves adding new keys and
the STA and deleting old ones.

Assisted-by: LLM
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 163 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 76ff86ff9974..65da37dc334b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4087,6 +4087,142 @@ struct ieee80211_prep_tx_info {
 	int link_id;
 };
 
+/**
+ * DOC: SMD Transition (client)
+ *
+ * If the driver implements UHR and the necessary features/callbacks,
+ * it can set the cfg80211 WIPHY_FLAG_SMD_TRANSITION_CLIENT flag to
+ * make it available to userspace.
+ *
+ * SMD Transition preparation intentionally isn't visible to the
+ * driver as it doesn't create any state that the driver needs to
+ * be aware of.
+ *
+ * A lot happens during SMD Transition execution, but a few key things
+ * are new relative to other roaming flows:
+ *  - a station entry for the target AP MLD is added before the
+ *    one for the current AP MLD is removed, so two AP stations
+ *    live concurrently for a brief time
+ *  - the vif doesn't go through an unassociated phase
+ *  - the sequence is somewhat similar to link switch rather than
+ *    roaming, except with a new AP MLD station instead of the old
+ *    one, and the link bitmap could be identical before/after
+ *
+ * Via the st_config() callback, the driver also has a chance to
+ * influence the ST execution settings, this is called before the
+ * execution request is transmitted, and can also control sending
+ * it to the current or target AP MLD.
+ *
+ * With the st_exec() callback, the driver is informed of the stage
+ * of the transition and has certain responsibilities, see the step
+ * documentation.
+ *
+ * The link changes are also communicated through st_exec(), and
+ * change_vif_links() is not called during the transition at all.
+ * This is necessary because a link ID may be used by both the current
+ * and the target AP MLD, while referring to different BSSes, so both
+ * links must exist at the same time - which the vif's link_conf[]
+ * array cannot express. The bss_conf pointers are therefore passed
+ * to st_exec() directly, and the ones for the target AP MLD are not
+ * reachable through the vif until the transition completed.
+ */
+
+/**
+ * enum ieee80211_st_exec_mode - ST execution mode
+ * @IEEE80211_ST_EXEC_MODE_CURRENT_AP_MLD: execution with current AP MLD
+ * @IEEE80211_ST_EXEC_MODE_TARGET_AP_MLD: execution with target AP MLD
+ */
+enum ieee80211_st_exec_mode {
+	IEEE80211_ST_EXEC_MODE_CURRENT_AP_MLD,
+	IEEE80211_ST_EXEC_MODE_TARGET_AP_MLD,
+};
+
+/**
+ * struct ieee80211_st_config - ST execution configuration
+ * @mode: indicates whether to execute with the current or target AP MLD
+ * @timeout: downlink draining timeout (jiffies), used unless the AP MLD
+ *	indicated a shorter duration
+ */
+struct ieee80211_st_config {
+	enum ieee80211_st_exec_mode mode;
+	unsigned long timeout;
+};
+
+/**
+ * enum ieee80211_st_exec_step - ST execution step
+ * @IEEE80211_ST_EXEC_STEP_BEGIN: Begin ST execution, before sending the
+ *	execution request with software data queues already stopped. The
+ *	driver must also pause/flush data frames so none go out after the
+ *	execution request frame.
+ * @IEEE80211_ST_EXEC_STEP_ADD_LINKS: Add the links for the target AP MLD,
+ *	the driver gets all links in @link_conf, picks one or more, and
+ *	must set ones not added to %NULL. The new links are not reachable
+ *	through the vif yet since the same link IDs may be used by the
+ *	target AP MLD.
+ *	The station entry for the target AP MLD is added after this step.
+ *	This is the only step allowed to fail; on failure the transition is
+ *	abandoned and the interface disconnects.
+ * @IEEE80211_ST_EXEC_STEP_MOVE_STA: After adding the station entry for the
+ *	target AP MLD, with the previous one still alive, in this step the
+ *	driver must move state from the old to the new, namely TX/RX BA
+ *	sessions, pending frames, etc.
+ * @IEEE80211_ST_EXEC_STEP_MOVE_STA_KEYS: After adding new keys for the
+ *	target station, instruct the driver to move the ones that didn't
+ *	get replaced. The station pointers like in _MOVE_STA are also
+ *	valid, and a new PTK is indicated in new_ptk.
+ * @IEEE80211_ST_EXEC_STEP_REMOVE_LINKS: Remove the links of the previous
+ *	AP MLD, now the @link_conf points to the old links and the vif
+ *	already points to the new links, inverted from _ADD_LINKS.
+ * @IEEE80211_ST_EXEC_STEP_DONE: ST execution completed, so transmit can
+ *	now resume.
+ * @IEEE80211_ST_EXEC_STEP_ABORT: Only for execution with current AP MLD,
+ *	the execution was rejected by the AP MLD and connection continues,
+ *	so the driver just resumes transmission that was paused before.
+ *
+ * Note: due to failures it's possible to not go through all
+ * of the steps but disconnect instead.
+ */
+enum ieee80211_st_exec_step {
+	IEEE80211_ST_EXEC_STEP_BEGIN,
+	IEEE80211_ST_EXEC_STEP_ADD_LINKS,
+	IEEE80211_ST_EXEC_STEP_MOVE_STA,
+	IEEE80211_ST_EXEC_STEP_MOVE_STA_KEYS,
+	IEEE80211_ST_EXEC_STEP_REMOVE_LINKS,
+	IEEE80211_ST_EXEC_STEP_DONE,
+	IEEE80211_ST_EXEC_STEP_ABORT,
+};
+
+/**
+ * struct ieee80211_st_exec - ST execution data
+ * @step: indicates the step of the ST execution
+ * @mode: indicates the mode (current/target AP MLD)
+ * @ap_mld_addr: MAC address of the target AP MLD
+ * @link_conf: link information for ADD_LINKS/REMOVE_LINKS steps
+ *
+ * @prev_sta: station entry for the current AP MLD, for MOVE_STA/_KEYS
+ * @sta: station of the target AP MLD, for MOVE_STA/_KEYS
+ * @dl_sn_reset: DL SNs were reset (for MOVE_STA)
+ * @ul_sn_reset: UL SNs were reset (for MOVE_STA)
+ * @new_ptk: a new PTK was installed, i.e. per-AP MLD PTK mode
+ *	(for MOVE_STA_KEYS)
+ * @max_dl_ba_buf_size: limit for transferred DL BA sessions (for MOVE_STA)
+ * @ul_ba_buf_size: per-TID adjusted buffer size of UL BA sessions, 0 if
+ *	no changes were indicated (for MOVE_STA)
+ * @csa_links: bitmap of links of target AP MLD doing CSA (for ADD_LINKS)
+ */
+struct ieee80211_st_exec {
+	enum ieee80211_st_exec_step step;
+	enum ieee80211_st_exec_mode mode;
+	const u8 *ap_mld_addr;
+	struct ieee80211_bss_conf *link_conf[IEEE80211_MLD_MAX_NUM_LINKS];
+	struct ieee80211_sta *prev_sta, *sta;
+	bool dl_sn_reset, ul_sn_reset;
+	bool new_ptk;
+	u16 max_dl_ba_buf_size;
+	u16 ul_ba_buf_size[IEEE80211_NUM_TIDS];
+	u16 csa_links;
+};
+
 /**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
@@ -4766,6 +4902,12 @@ struct ieee80211_prep_tx_info {
  * @set_eml_op_mode: Configure eMLSR/eMLMR operation mode in the underlay
  *	driver according to the parameter received in the EML Operating mode
  *	notification frame.
+ * @st_config: Query the driver for the preferred SMD Transition execution.
+ *	Can return an error to reject the operation, adjust the current state
+ *	to prepare for ST execution, and configure the ST execution.
+ *	Optional even for ST, can sleep.
+ * @st_exec: Required for ST, informs the driver of the ST execution steps,
+ *	driver must act according to the step documentation. Can sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -5179,6 +5321,13 @@ struct ieee80211_ops {
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
 			       struct ieee80211_eml_params *eml_params);
+
+	int (*st_config)(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_st_config *config);
+	int (*st_exec)(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_st_exec *exec);
 };
 
 /**
@@ -8156,6 +8305,20 @@ void ieee80211_set_active_links_async(struct ieee80211_vif *vif,
  */
 void ieee80211_send_teardown_neg_ttlm(struct ieee80211_vif *vif);
 
+/**
+ * ieee80211_vif_st_executing - check if an SMD transition is executing
+ * @vif: the (station) interface
+ *
+ * Drivers can use this to avoid operations that might affect downlink
+ * drain during ST execution (e.g. scanning) without tracking on their
+ * own.
+ *
+ * Must be called with the wiphy mutex held.
+ *
+ * Return: %true during ST, %false otherwise.
+ */
+bool ieee80211_vif_st_executing(struct ieee80211_vif *vif);
+
 /**
  * ieee80211_chan_width_to_rx_bw - convert channel width to STA RX bandwidth
  * @width: the channel width value to convert
-- 
2.56.0

