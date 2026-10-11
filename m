Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309C43747C
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716725; cv=none; b=L7P8y5PP81l83/BwEPbEnrH62kVtjijnNDFPv+/Wn91dbSxcIdO0zKXGjetiALWNe6LuMReUooXamlquTqBQqRGBOEiDod+WdfDfDo2k+q2FJ/axxizweErPIRorcIfHHXQ77k55p5HjmzIsEvFCv9tCx9Xlt4YfB7BhMdct3LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716725; c=relaxed/simple;
	bh=suGeDK+G78eUlje8k2uqPVGKM7dV8gXSyJX1+JWZXhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UJYmq8bDK6hPbUICiosR7+mm8t4DAXtyUL87myNXjvKHtV40t+GDjipcO36mjTRbHQnoV12OGsn1yKvA8ZOuhfIibKlWtNYDI+o/bxyClGAahktgks2TixlY2xW/US8yGb5eVAvNQmz9D4+VnQZanh9yJTSt4B5SMsmsgTETa4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dA70dqmp; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dA70dqmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716724; x=1823252724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=suGeDK+G78eUlje8k2uqPVGKM7dV8gXSyJX1+JWZXhs=;
  b=dA70dqmpigSwFatExVtSPHS6MZW0MEA7PvB1yxmImW9GB77psxWD6VHr
   FAKKqaJnAVdKheu6ORMaq67eOWsXo2W5hG34+CEFz45LqOXQdscXmc7Nk
   OdrVYfJI9IyXaqpBzA5aNwlIlSSLXRgKwLdEW1y+ke+W0tC/C0P85cVfz
   y8R1Ni+O8V6xoscyZIMUOVAJrqmR1+wNMiZbjXnYd4ZQv58/CAr//CUSP
   cfmPsZVp6fAFbfDeO8YGWWoh1iNIUmt6BFhB6uz/6uqOt+hGHeXADSy3/
   pB97P3LvlUYlHTr8QkiKEdnJVJM8uQT0glpDfzd7KB3p5y0GIAhHYIP0A
   A==;
X-CSE-ConnectionGUID: 7zovV35CRLCHLUtm6ONU4A==
X-CSE-MsgGUID: LMoXw4I5TgyuqNJXhhFv0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454170"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454170"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:23 -0700
X-CSE-ConnectionGUID: qHuCeZB5Soi0hNylulEC9Q==
X-CSE-MsgGUID: 0bbcqfFJRfevcyEuiJYm9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="650948"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:22 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 03/13] wifi: iwlwifi: fw: api: fix D3 sequence counter docs
Date: Sun, 11 Oct 2026 14:07:04 +0300
Message-Id: <20261011140453.5d17b80be44c.Ia3ec5e1f714029561b08ab659b116bc20a60beb3@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Most sequence counters in WoWLAN are documented as "to use next",
but in reality firmware treats them as "last used". Fix the docs
accordingly, while at it noting that for newer versions it only
applies to the offload TID.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
index c469ea965157..327a8c05f4db 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
@@ -373,9 +373,9 @@ enum iwl_wowlan_flags {
 /**
  * struct iwl_wowlan_config_cmd_v6 - WoWLAN configuration (versions 5 and 6)
  * @wakeup_filter: filter from &enum iwl_wowlan_wakeup_filters
- * @non_qos_seq: non-QoS sequence counter to use next.
+ * @non_qos_seq: last used non-QoS sequence counter.
  *               Reserved if the struct has version >= 6.
- * @qos_seq: QoS sequence counters to use next
+ * @qos_seq: last used QoS sequence counters
  * @wowlan_ba_teardown_tids: bitmap of BA sessions to tear down
  * @is_11n_connection: indicates HT connection
  * @offloading_tid: TID reserved for firmware use
@@ -732,8 +732,8 @@ struct iwl_wowlan_igtk_status {
  * @gtk: GTK data
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched pattern
- * @non_qos_seq_ctr: non-QoS sequence counter to use next
- * @qos_seq_ctr: QoS sequence counters to use next
+ * @non_qos_seq_ctr: last used non-QoS sequence counter
+ * @qos_seq_ctr: last used QoS sequence counters
  * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
  * @num_of_gtk_rekeys: number of GTK rekeys
  * @transmitted_ndps: number of transmitted neighbor discovery packets
@@ -763,8 +763,8 @@ struct iwl_wowlan_status_v6 {
  * @igtk: IGTK data
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched pattern
- * @non_qos_seq_ctr: non-QoS sequence counter to use next
- * @qos_seq_ctr: QoS sequence counters to use next
+ * @non_qos_seq_ctr: last used non-QoS sequence counter
+ * @qos_seq_ctr: last used QoS sequence counters
  * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
  * @num_of_gtk_rekeys: number of GTK rekeys
  * @transmitted_ndps: number of transmitted neighbor discovery packets
@@ -796,7 +796,7 @@ struct iwl_wowlan_status_v7 {
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched patterns
  * @reserved1: reserved
- * @qos_seq_ctr: QoS sequence counters to use next
+ * @qos_seq_ctr: last used QoS sequence counters
  * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
  * @num_of_gtk_rekeys: number of GTK rekeys
  * @transmitted_ndps: number of transmitted neighbor discovery packets
@@ -882,7 +882,7 @@ struct iwl_wowlan_mlo_gtk {
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched patterns
  * @reserved1: reserved
- * @qos_seq_ctr: QoS sequence counters to use next
+ * @qos_seq_ctr: last used QoS sequence counters
  * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
  * @num_of_gtk_rekeys: number of GTK rekeys
  * @transmitted_ndps: number of transmitted neighbor discovery packets
@@ -916,7 +916,7 @@ struct iwl_wowlan_info_notif_v3 {
  * @bigtk: BIGTK data
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched patterns
- * @qos_seq_ctr: QoS sequence counters to use next
+ * @qos_seq_ctr: last used QoS sequence counter for @tid_offloaded_tx
  * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
  * @num_of_gtk_rekeys: number of GTK rekeys
  * @transmitted_ndps: number of transmitted neighbor discovery packets
@@ -955,7 +955,7 @@ struct iwl_wowlan_info_notif_v5 {
  * @bigtk: BIGTK data
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched patterns
- * @qos_seq_ctr: QoS sequence counters to use next
+ * @qos_seq_ctr: last used QoS sequence counter for @tid_offloaded_tx
  * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
  * @num_of_gtk_rekeys: number of GTK rekeys
  * @transmitted_ndps: number of transmitted neighbor discovery packets
@@ -995,7 +995,7 @@ struct iwl_wowlan_info_notif_v6 {
  * @cigtk: CIGTK data
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched patterns
- * @qos_seq_ctr: QoS sequence counters to use next
+ * @qos_seq_ctr: last used QoS sequence counter for @tid_offloaded_tx
  * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
  * @num_of_gtk_rekeys: number of GTK rekeys
  * @transmitted_ndps: number of transmitted neighbor discovery packets
-- 
2.34.1

