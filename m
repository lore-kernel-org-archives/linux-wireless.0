Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793248861;
	b=ClZLsG8AiwHnb0ztmPHoZbL3M84L6STnTBCqbN6eBAnHTHPkkVhM6R7lDg6CMBQMUzZz
	 v1JQD/i1w4aMOYGf6d6CQpnTJbHLz8rNUFUElG+jkv654GsO9mUZZMKovaJ71KpJ2Yzm2
	 BCz/UEqRe2F2ijLdVnAQ3aLG/mNFXyEUPAHAzwkXFRPBYNbLFdOvRab79tDRLg2zkuI8o
	 HvvMqS74gXEIu5fgx7KfwS3UXgaiWOaCJRzN++V94bT7OE2rAU+urqt5YMQJdXx+EtiPZ
	 1QV7KPK2EJBodDbrSUUk5EVY40zIaaqKeTZlrEmJRzg67Izx48lYS7WZdyFOdNFOXQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793248861;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=Tzyq7wW47Y1a/kLHOY6oQDnXew/OxbLFwLH5/BNKl4U=;
	b=vsw46sDx3ffLpcuaxIVGaXBmiv8AMrcb2mHpe7rNTxoQWTp7jys//oEXtz5c3xtwfSmQ
	 J8r5BNTpsB7qyAUTle4iwLArLNooLpgYRReGNVFCBHhg19QixE/l4HEa2Cdl+nKafPONk
	 0ffJbKwF07gOcC9CkByDw8R6C5gQic8018hGz/y0bqxrNIVo2xbnXD7vZiUUqSaUFr1c5
	 qo3oIXccDBifyw4tc3RpOcbpx0llnyCPn417kCl8BlYq6J5zftg6N1oxBIUCIT1IEfhK0
	 WKjAT1/eTrQws1TfEjhBCs5bScFsQy9Wf5NjKKUbWBgwByYWkrUMj4kyMX1jQ+67ZJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="lQvvWx/w";
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C129606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 04:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C129606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lQvvWx/w
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso959330a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 21:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793248860; x=1793853660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tzyq7wW47Y1a/kLHOY6oQDnXew/OxbLFwLH5/BNKl4U=;
        b=lQvvWx/w6BpdqaTv1IdXe3t/JxxbyORY4AJK1SdaDJqv2xifqlrNWAIzsAv6zem332
         9YSxo+KFcefUVW/ToORDvvygpFCyWKXzSKNaaT2jKCxmx3hsr7zVdmnr/446n5SAwPhS
         zdVxRMpzN1SG6WrIs6Q8Efw12OYMkicfTObokbBqWd4vvhkCECKgamtEoKyONXXJz+q7
         Zi4YY8f65M91YMciMpL6/f5Jope6yYFHV8DQktw92/0EEBZFIeP90JO5DNIgQXLQckGV
         El5XC0EDN3koos7XiRrkYG88MHiOxLGLmoxu7v07cfVBxF014zvkj6J8dySnTjBOAJT+
         9hfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793248860; x=1793853660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tzyq7wW47Y1a/kLHOY6oQDnXew/OxbLFwLH5/BNKl4U=;
        b=x3c4WmsIXi3KItVzIJ2sZVs1kLRwjWBdGhJbsjPfvKd1tOFRFGRx50/hY0ANop/w6B
         x4GXmhgZRf4VF8Spo+aBm6XilUiVwaio75Mv04aJX8/nWUv1DfrSG2svIEFDMC8kUJYd
         Clnajeb9F0PTYp8h8NqtvjRnLH0DBTMpVxwK4hj9K4/gArI9kx1KkZe4gXzhbJBAe0gO
         Gu2xtiprAftxvfubsuwd+zpTou9UNuajzVbAe3ile31zI5uH2ROOoRsfDoL5EG8Motzm
         0MQQVDGuJTkTNvxut50XA+gRcM6YAOuavLtmPtbydrwpm8yfMScsqRL0Zsu23QcMHSmk
         bfHQ==
X-Gm-Message-State: AFq9FYL+MLOEqxt1P/QUCHQRtaW/wVbbHTPpmFIMCyGpF/5m1td0M6rL
	X9eqrOSGWMcD4VS9URsAPKNaiw5vwYLhFynuy95aaKvC8QsWG3MAvF2CiyyQ8Q==
X-Gm-Gg: AYBFou3iM0Yy8cCSxOMxmJ4MOiuUifAzvD2SmemGDyUVLNxs7Lwq/HjXdTW7WRgxVG6
	AEh6hNKDCgsNl/kLSkEhotvQf7aEJVvGIF0hvMN+IKc6pU/00RmuXyxe7SFIZV57edDcs2KPiIa
	ldTMY3AGamTJJBly1TyvekiTs2/3oZh0ab+fDM+n0UrdzgD8TJI+tvTh7AGb7UKCMIj8t4bRBXn
	Qsasa3H1qklrR8Lsmuj1Xq0jc08NWTJxpNokueNJLDBJ+LI5Kt74B79JKH0Z4RFXZlt1ZSMqQOy
	QTAXQIhobo/oVjU5NOYmflt+hktMq7YxYcb2GsUeAELuBMR7xTEtCECMG484AHZQ2W7ByhzZW8Z
	bfvKvlL8JTd5GxnjHnjKp+SQlsBti6qF2MFzoiE7/ZQskz62uAqnWuihQVRg9rqmL8wZiXZ05Hr
	pmIOTPV/5z5XFCtNiTS/2ihzvgR0jCfXRevno2Vn5v9TlQlXHZrMxqjXjDTVsE1NKXt2wMf9ouu
	y6+wAqG/a/mBfVjFGmlScmNyObyR2eUB2gx3etB+OKTuTnlmHdFz22b240F1PMIcsPie6rRac3D
	5seyjblWtfIqSVa4SQJwR7V4KthrHny9
X-Received: by 2002:a17:90b:53ce:b0:3ad:a17d:f46c with SMTP id 98e67ed59e1d1-3ae5823cec2mr3187998a91.62.1793248860344;
        Wed, 28 Oct 2026 21:41:00 -0700 (PDT)
Received: from ThinkBook.lan ([183.13.224.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6f01e8a5sm892027a91.0.2026.10.28.21.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 21:40:59 -0700 (PDT)
From: Edwin Huish <edwinhuish@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] wifi: iwlwifi: mld: don't dereference link_sta->sta unchecked
Date: Thu, 29 Oct 2026 12:40:46 +0800
Message-ID: <20261029044046.1255442-1-edwinhuish@gmail.com>
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

mld->fw_id_to_link_sta[] can hold an entry whose ->sta is not set.  The
driver already documents this in iwl_mld_rx_agg_session_expired():

	/* sta should be valid unless the following happens:
	 * The firmware asserts which triggers a reconfig flow, but
	 * the reconfig fails before we set the pointer to sta into
	 * the fw_id_to_link_sta pointer table. mac80211 can't stop
	 * A-MPDU and hence the timer continues to run. Then, the
	 * timer expires and sta is NULL.
	 */

Three other users of the table only check the link_sta pointer itself
and then go straight for ->sta:

  iwl_mld_teardown_tdls_peers(), iwl_mld_tdls_sta_count(),
  iwl_mld_mac80211_flush()

	link_sta = wiphy_dereference(mld->wiphy, mld->fw_id_to_link_sta[i]);
	if (IS_ERR_OR_NULL(link_sta))
		continue;

	if (!link_sta->sta->tdls)	/* ->sta may be NULL */

iwl_mld_tdls_sta_count() was hit in the field on an Intel BE201
(8086:7740) running firmware bz-b0-fm-c0-c101 (101.6e695a70.0), in
exactly the situation described above: the firmware asserted twice
within a second (0x85 ADVANCED_SYSASSERT followed by 0x20100508) and
the restart failed with "FW error in SYNC CMD INIT_EXTENDED_CFG_CMD".
About a minute later wpa_supplicant re-associated and issued
NL80211_CMD_SET_STATION to update the power save parameters, which
ends up in iwl_mld_power_build_cmd() -> iwl_mld_tdls_sta_count():

  BUG: kernel NULL pointer dereference, address: 0000000000000018
  #PF: supervisor read access in kernel mode
  Oops: 0000 [#1] SMP NOPTI
  CPU: 7 PID: 1740 Comm: wpa_supplicant
  RIP: 0010:iwl_mld_tdls_sta_count+0x48/0xd0 [iwlmld]
  RAX: 000000000000000c  RCX: ffff8c51a95ba0a8  RDX: 0000000000000000
  Call Trace:
   <TASK>
   iwl_mld_power_build_cmd+0x11f/0x480 [iwlmld]
   iwl_mld_update_mac_power+0x66/0xe0 [iwlmld]
   iwl_mld_mac80211_vif_cfg_changed+0x58/0x120 [iwlmld]
   ieee80211_vif_cfg_change_notify+0x10d/0x230 [mac80211]
   ieee80211_recalc_ps_vif+0x41/0x60 [mac80211]
   ieee80211_change_station+0x1e0/0x280 [mac80211]
   nl80211_set_station+0x4e2/0x660 [cfg80211]
   genl_family_rcv_msg_doit+0x120/0x190
  note: wpa_supplicant[1740] exited with irqs disabled

The registers match the source: RAX is the loop index (12), RCX is mld,
and RDX - the result of loading link_sta->sta - is zero.  The faulting
instruction reads sta->tdls at offset 0x18:

    6d70: test   %rdx,%rdx          ; link_sta != NULL checked
    6d73: je     6d8b
    6d75: mov    (%rdx),%rdx        ; link_sta->sta, NOT checked
    6d78: movzbl 0x18(%rdx),%edx    ; sta->tdls  <- faulting insn

Since the oops happened with interrupts disabled, the task died in
kernel mode without releasing the cfg80211/rtnl locks it held, which
then blocked gnome-shell on the leaked lock and froze the whole
desktop.  The impact is therefore not limited to a dropped connection.

Handle the entries the same way agg.c already does, and skip them.

Tested on the affected machine: builds cleanly against 7.0.0-38-generic,
all three sites now test ->sta before loading sta->tdls, and WiFi still
associates and reconnects normally.

Signed-off-by: Edwin Huish <edwinhuish@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -913,6 +913,11 @@ static void iwl_mld_teardown_tdls_peers(struct iwl_mld *mld)
 		if (IS_ERR_OR_NULL(link_sta))
 			continue;
 
+		if (!link_sta->sta) {
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
 		if (!link_sta->sta->tdls)
 			continue;
 
@@ -1630,6 +1635,11 @@ int iwl_mld_tdls_sta_count(struct iwl_mld *mld)
 		if (IS_ERR_OR_NULL(link_sta))
 			continue;
 
+		if (!link_sta->sta) {
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
 		if (!link_sta->sta->tdls)
 			continue;
 
@@ -1937,6 +1947,11 @@ static void iwl_mld_mac80211_flush(struct ieee80211_hw *hw,
 		if (IS_ERR_OR_NULL(link_sta))
 			continue;
 
+		if (!link_sta->sta) {
+			WARN_ON_ONCE(1);
+			continue;
+		}
+
 		/* Check that the sta belongs to the given vif */
 		if (vif && vif != iwl_mld_sta_from_mac80211(link_sta->sta)->vif)
 			continue;
-- 
2.43.0

