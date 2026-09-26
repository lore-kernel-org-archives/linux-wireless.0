Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD1A2D7817
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790437171; cv=pass; b=TNNhwtq1FEmyzQJ4ijOvUxOCQnxa+n00AMK46sZezZ2if3vbSMKL0GT1tT6JkwH5d3pXkAGWrZWNEUWx6IAthhtPBsf0I4U2jrxQm45nJltSrgwuCurDMS+BjyiribcDKBAS3JlxzhpNIgWyFgGxAnIZm6VOsJ6paZc+a57mBGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790437171; c=relaxed/simple;
	bh=ulIE/Pze8ytrd9NyTWBRZclKqbnytmoRdH5iUi7x31o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hrXj1zJGAhw6M8CUhHPpQZbTjZtNIOQC+OQlK4Jtea+K0OYVuTma76Ls07fKygzmCK6l2bY9Aj8LJ8X0OJ5I7+Lj6UR4HhExQ/3iULwWEH6/r5ZxRsRtY8TbBiIkTKfsUDZtIrlwJWRlnPsENrCqS4NCXSXDP6nm16NaJ8qPoRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PoIkFOZn; arc=pass smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PoIkFOZn"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae90f528fso2469351a12.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 08:39:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790437167; cv=none;
        d=google.com; s=arc-20260327;
        b=AZtbcy83rQezuuqq/TQ5PsLSOanbcQcebPlZp3QHvmTDgFw5cDUcC4/tDnyC1hxlfI
         TH3xAe6TI/3SEEFMAAf4MalmytTRiUk4o0IJ763yA0tN7PHfAeDlubU0c2pxTqWe5JLn
         dQcW10pkvyG8QxkOCJgU3fsZl/POmHHBDAcFHrVKV29uWJbWaMIfZ2eUUYunuubf4LlI
         ZIzodBHE7+poTZMroneJ9yQPXU8nQ9758cWY5POlcnXeAZ9IEWcDXPSOuQSoIKppkJoP
         jwK7sKysyGL6Z5FDgvomX4NtEjVSevkii+TuuE5MvraEnp87HEvhfPDoowmFXOnQXoMj
         lNJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=CfBuVwsnDuIBZpMG20JCH1IT1a2DqjSu6hfn2rvOhcg=;
        fh=ZRqwlUHKYMhBQcB9RY1GrbNPNR1/Y7TCfX7XD9Usa1c=;
        b=WkCUCmDUJLYEFZiyNlSeDGcg1FLTjNYWfTCEYOq2Ke6OVufYPO5+hLJ1Jo7/MOPttn
         07VBByTKY4iqQW/gABxfuj7MmkMO/YlY27/GNIuVycTfycDNPDSsbgWgOWhs4sL4A5T+
         cqSWKE12VDRg3F+LR5Nj/X9AWXqDxyz90ANpbwyyCum4BPIxCsad/MZKeW2O2o1E+CBb
         Dskx89iua0r1KjEOUjka+FWNFmXNVHjcDh7W0C6x4nRZe99eX7IPeMdX5byCxF+DZIKi
         0VXY34oyTfjAzIr9hhfiDc2AlOafh2xZQGd9PLCUiS0X8gZFxSwzVi86WIROMhUnZKwo
         OB7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790437167; x=1791041967; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CfBuVwsnDuIBZpMG20JCH1IT1a2DqjSu6hfn2rvOhcg=;
        b=PoIkFOZnFFHDX9ldi5nbJJ1az7OdhkrWom7ojlzHRBViT5z4Uprs9kEGBlpjAnoZQy
         CuprXaJhvD5IgWgD06NDTA1+A2o3pi5v7r9KGLr+XGck0o4IpxZjXPwcEpQBfcG/8TCF
         FeiBBgXJ3VhdtY0h4TgdxduVuMKS4j4OqzHFXGIy/3EtwS++PHfFJpUq97V+oJJZ+9jH
         jiF5VdJpQjfY+QQVCuvb/IkGkLRf3TWSvB00JxKHliZ+LWBQBUEgRhA5nGVzElFhOfS6
         msUoA+nPoHTPnmnVYqcGC5qH65ttOzMADL7zB1vr/OHUmzuColA4f7DnAa/OTkWlJIne
         rKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790437167; x=1791041967;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CfBuVwsnDuIBZpMG20JCH1IT1a2DqjSu6hfn2rvOhcg=;
        b=fNu7Vr5dOD2H5JlNOtbiRPq2GkYpQ8Y1J3zoz8jpukbrizY6INu2d2BuBr8eoczJ5L
         rM+vyY264A7N0VQHvWXCdzhDx0tE1Gqv1gFp4Qh+ZGB4kFstHAwXmj11btFCPKXr0nsX
         CE2SBUHjX5UCRAMseuumJsfDD5cKHkUHIhpAQLRym6g4fIfFkHRuoFvLLRbn9yjOoJe+
         P08VUHpS7XbRFcsLbR9NKfLf4AHHiPAEKL1GRTQXFGTIuXJujj1kBM8RvXCQIPtgQsIY
         n5xw52yPNivn3E+TwuttxedIpMNH+UBRzQEep1Qpa4ZsKwKl0PQLi7zWKgbBKbvP/3qK
         A6wA==
X-Gm-Message-State: AFq9FYKdbYobtTSNz5f0kPzaGeYgij76w/rFmHNrzu0l8+pgB3cceL73
	wAhG4cePP1Fo2JelURrbcWlZz/QV+ncclqT9a50mtKoxzBQrBtEWE4x5rhFAXf4mcEBeMkEZWrw
	8d17st6fa3bbFiwqxWKP2dvngLqiJboW9h8d+SQI=
X-Gm-Gg: AYBFou1v6TcH5wTmb685ENAjS4XJfMQs5Vx88f61ub5YKR42dTZL1FMMgkzIv6NEPJc
	7sgHIKwaXVZkLkuUvAlSmvCUdSgThNkXGPYkqavMXqIQdojzHjVjd008pbDBxRwkeLA4n1h3Txe
	Spm2z2fqa4CsU9REaoukG1221dsVBmCR5rkqyD73ZaQ98tjBr+U78HAWS5GXQfZBOP1KwfDXqy1
	s30+OCkO3m4InzekBsxxM3Hp1lArWys27CcQdnLF9SAWSkML9axPYvz1bpw8jq2PTaW2Y1GALWi
	Akq0BPcfoj/o0EcPFZvEKWsDWv90hI44Rc9dpbIpaD7dVM+lqgA34K9NLQT6oq3z
X-Received: by 2002:a05:6402:50c7:b0:6a6:774e:8a44 with SMTP id
 4fb4d7f45d1cf-6aac8f6670bmr8257752a12.12.1790437167016; Sat, 26 Sep 2026
 08:39:27 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 26 Sep 2026 11:39:26 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 26 Sep 2026 11:39:26 -0400
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: hc86862997@gmail.com
Date: Sat, 26 Sep 2026 11:39:26 -0400
X-Gm-Features: AclHuK--J38jjGJaoQVIJ4GfOx7J-TmIwB04X2csUhmWzEouZ7lmvj0C0iRh4DI
Message-ID: <CAG0XsJF3ch8WSGfKLORkL4vORc_pqYqXoUJ0NMB8dwNxrsfNWg@mail.gmail.com>
Subject: [PATCH] wifi: mac80211: allow RX decap offload for single-peer mesh links
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name
Content-Type: text/plain; charset="UTF-8"

Hi,

mac80211 currently restricts RX decap offload to AP/STATION interfaces via
ieee80211_iftype_supports_hdr_offload(), so 802.11s mesh peers never get
IEEE80211_OFFLOAD_DECAP_ENABLED and never reach drv_sta_set_decap_offload().
All mesh data frames take the full software RX path
(ieee80211_rx_mesh_data() per packet).

On MT7996 this is measurable: a 6 GHz EHT320 single-hop mesh backhaul is
capped at ~600-700 Mbps with 55-72% CPU on the receiving node, while the
same link in 4-address WDS mode (which gets decap offload) reaches ~1006
Mbps with 1-2% CPU. The mt76 side is already prepared for mesh decap:
mt7996_mcu_sta_hdr_trans_tlv() sets the dedicated mesh flag in the
sta_rec_hdr_trans TLV for MESH_POINT vifs (commit 88d1b002), but the
translation stays disabled because mac80211 never asks for it.

This patch enables RX decap offload where mesh semantics are provably
inert: a leaf mesh point with at most one established peer
(point-to-point backhaul). With a single peer no mesh-layer forwarding
can occur, and the local bridge never forwards frames back out the
ingress mesh interface, so no loop can form. When the established peer
count crosses the boundary, the offload evaluation is re-run from mesh
deferred work (wiphy locked), which tears down or sets up per-peer decap
state through the normal fast-rx path.

Design points:

- Hardware decap strips the 802.11 header including the Mesh Control
  field, so decapped frames bypass ieee80211_rx_mesh_data() - mesh
  forwarding, TTL handling, proxy (AE) learning and RMC duplicate
  suppression. That is why this stays gated on estab_plinks <= 1;
  multi-peer / multi-hop meshes keep the full software path.
- TX is intentionally left on the software mesh path (no
  OFFLOAD_ENCAP_ENABLED for mesh - the 802.3 xmit ops have no mesh
  nexthop resolution).
- Security model unchanged: PN/replay checking runs in hardware exactly
  as for AP/STA/WDS decap offload; no duplicate-processing checks are
  skipped or faked.
- Management frames (plink, HWMP) are never translated by the hardware.

Measurements (Airoha AN7581 + MT7996, 6 GHz EHT320 single-hop backhaul,
NPU active):

- Without the patch: TCP single stream ~600-700 Mbps, receiving node
  55-72% CPU; full forwarding path (wired -> mesh -> wired) 676 Mbps.
- With the patch: TCP single stream 1.31 Gbps at load 0.29; full
  forwarding path 676-728 Mbps with the busiest napi thread at <=19%.

The patch is based on a backports-7.2 tree; I will rebase on
wireless-next if the approach looks acceptable. Also filed with
measurements at https://github.com/openwrt/openwrt/issues/25417

---
 net/mac80211/ieee80211_i.h   |  1 +
 net/mac80211/iface.c         | 34 ++++++++++++++++++++++++++++++++--
 net/mac80211/mesh.c          |  3 +++
 net/mac80211/mesh.h          | 12 ++++++++++++
 net/mac80211/mesh_plink.c    | 10 ++++++++++
 5 files changed, 59 insertions(+), 1 deletion(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2216,6 +2216,7 @@
 void ieee80211_recalc_txpower(struct ieee80211_link_data *link,
 			      bool update_bss);
 void ieee80211_recalc_offload(struct ieee80211_local *local);
+void ieee80211_mesh_recalc_rx_decap(struct ieee80211_sub_if_data *sdata);

 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1067,6 +1067,27 @@
 	}
 }

+/*
+ * RX decap offload makes the hardware strip the 802.11 header including
+ * the Mesh Control field, so decapped frames bypass ieee80211_rx_mesh_data()
+ * and with it mesh forwarding, TTL handling, proxy (AE) learning and RMC
+ * duplicate suppression.
+ *
+ * This is only safe for a leaf mesh point with at most one established
+ * peer (e.g. a point-to-point wireless backhaul): with a single peer no
+ * mesh-layer forwarding can take place, and the local bridge never
+ * forwards frames back out the mesh interface, so no loop can form.
+ * Meshes with more than one established peer must keep the full software
+ * mesh RX path.
+ */
+static bool ieee80211_mesh_rx_decap_allowed(struct
ieee80211_sub_if_data *sdata)
+{
+	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+		return false;
+
+	return atomic_read(&sdata->u.mesh.estab_plinks) <= 1;
+}
+
 static bool ieee80211_set_sdata_offload_flags(struct
ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1089,7 +1110,8 @@
 	}

 	if (ieee80211_hw_check(&local->hw, SUPPORTS_RX_DECAP_OFFLOAD) &&
-	    ieee80211_iftype_supports_hdr_offload(sdata->vif.type)) {
+	    (ieee80211_iftype_supports_hdr_offload(sdata->vif.type) ||
+	     ieee80211_mesh_rx_decap_allowed(sdata))) {
 		flags |= IEEE80211_OFFLOAD_DECAP_ENABLED;

 		if (local->virt_monitors &&
@@ -1152,6 +1174,14 @@
 	}
 }

+/* called from mesh deferred work when the established peer count changes */
+void ieee80211_mesh_recalc_rx_decap(struct ieee80211_sub_if_data *sdata)
+{
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+
+	ieee80211_recalc_sdata_offload(sdata);
+}
+
 void ieee80211_recalc_offload(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1751,6 +1751,9 @@

 	if (test_and_clear_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags))
 		mesh_bss_info_changed(sdata);
+
+	if (test_and_clear_bit(MESH_WORK_RX_DECAP_RECALC, &ifmsh->wrkq_flags))
+		ieee80211_mesh_recalc_rx_decap(sdata);
 }


--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -54,12 +54,15 @@
  * @MESH_WORK_DRIFT_ADJUST: time to compensate for clock drift
relative to other
  * mesh nodes
  * @MESH_WORK_MBSS_CHANGED: rebuild beacon and notify driver of BSS changes
+ * @MESH_WORK_RX_DECAP_RECALC: re-evaluate mesh RX decap offload after the
+ *	established peer count changed
  */
 enum mesh_deferred_task_flags {
 	MESH_WORK_HOUSEKEEPING,
 	MESH_WORK_ROOT,
 	MESH_WORK_DRIFT_ADJUST,
 	MESH_WORK_MBSS_CHANGED,
+	MESH_WORK_RX_DECAP_RECALC,
 };

@@ -393,6 +396,12 @@
 	return mesh_accept_plinks_update(sdata) | BSS_CHANGED_BEACON;
 }

+static inline void mesh_request_rx_decap_recalc(struct
ieee80211_sub_if_data *sdata)
+{
+	set_bit(MESH_WORK_RX_DECAP_RECALC, &sdata->u.mesh.wrkq_flags);
+	wiphy_work_queue(sdata->local->hw.wiphy, &sdata->work);
+}
+
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
 {
 	return sdata->u.mesh.mshcfg.dot11MeshMaxPeerLinks -
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -375,8 +375,13 @@

 	lockdep_assert_held(&sta->mesh->plink_lock);

-	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB)
+	if (sta->mesh->plink_state == NL80211_PLINK_ESTAB) {
 		changed = mesh_plink_dec_estab_count(sdata);
+		/* the link may have dropped to a single established peer;
+		 * re-evaluate RX decap offload from deferred work
+		 */
+		mesh_request_rx_decap_recalc(sdata);
+	}
 	sta->mesh->plink_state = NL80211_PLINK_BLOCKED;

 	ieee80211_mps_sta_status_update(sta);
@@ -849,6 +854,10 @@
 	timer_delete(&sta->mesh->plink_timer);
 	sta->mesh->plink_state = NL80211_PLINK_ESTAB;
 	changed |= mesh_plink_inc_estab_count(sdata);
+	/* the new peer may have taken the link past the single-peer
+	 * boundary; re-evaluate RX decap offload from deferred work
+	 */
+	mesh_request_rx_decap_recalc(sdata);
 	changed |= mesh_set_ht_prot_mode(sdata);
 	changed |= mesh_set_short_slot_time(sdata);
 	mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n", sta->sta.addr);
