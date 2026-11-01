Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793493784;
	b=s+STUTHpHgpmv5ObxWBd2WO8HDsZhdwC1se3VE1PvFvEHHA1PF7X8uZZO5gWpixuNbpf
	 U0m7dfvBAEJt1d8KyyIEZggMZ4lXWh+Qb0/15V6ny0yEFADPhkG+5KI7cZl/mVIupA+Vk
	 +tKL3mWFfaE0ldxIcmUb6hF6Q2LDVaOHX5e18ewj021F1Ziq1gHN8zpdqN6SEXq14M1Cw
	 XvleebY4U0JGNyIYWKMV8c4uJuDhjy1irWaLNNveMIqs+veKU+aPvrSlRZm/I1aR5BWyA
	 //h1QBzr9qXSfzLEK7h9zEBX7X4oly367nYP/cQRnEOvrOaXlxgSymV5VQrXlytAJdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793493784;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Wg7J1WKS97sSKSOt6lNwjMTL6E8TpFeXp1Q3liA+6TE=;
	b=V1rhkvkWYi1emtpj1uzpU37UcqW9HYRL2p35iQEEb2he+9us2eTu1/UfTlIZyNiV7ar+
	 Hg5n/ILcM7AkjD1wWoZ/YHmSuTvZPvlRaMAOsVN3gxJ+cLJ0DWG5UPXELdQkRd3VoLbAX
	 Sjx4uZQE/cYjsFJGzLaAf5AcSMzitisLQtb/nkEpWmyHt/19j6KN4twkPPoKSc4SoskFY
	 Ey0i2SZuK5qABCMSlRicFcQfRm6g2T2d4HWpsjB4hPCFnqNGWEqowDETqbzLOdywIekS0
	 E0SH4Zpz7vGqLReisX8yl3FAjyU8EawLO0PttCzTTnlVMgJxP0AEsw7Dqf9zfpyGEZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=maticrobots.com;
	spf=pass smtp.mailfrom=matician.com;
	dkim=pass header.d=maticrobots.com header.i=@maticrobots.com header.a=rsa-sha256 header.s=google header.b=TK0zu6RP;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4090F606A31A
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 00:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4090F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maticrobots.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=matician.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=maticrobots.com header.i=@maticrobots.com header.a=rsa-sha256 header.s=google header.b=TK0zu6RP
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-369f33df08eso3757049eec.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 17:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maticrobots.com; s=google; t=1793493783; x=1794098583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wg7J1WKS97sSKSOt6lNwjMTL6E8TpFeXp1Q3liA+6TE=;
        b=TK0zu6RPNZeNBM/Fu+YjNNrHuJW/RltX2g2OcAeMYHN5bRL4woCKddp3nOb+fqz2eD
         9hlOO1k3IXvpLOALYeUX8hlCMK/qImfowVvVZwskt4ObiEsJdDdNBkekSa23crHToLae
         bhgntX4FfWPS4T4kJSwa4PfgPhezCXgDgMuvryd6cn1I53UzdbiMLqfzlnA83mU1CTCi
         bppk4+lhG7Oj89pX0HtBa5uWvUc4tO0UP2rArpMFyxxJWUg1iHMiUDXw+ivJoVJqwKt4
         vt6NauteJYLjxzCkgfeGai5Bc1wpxoPwtTo9awWriVOPNUhkxGK2kAIk9Cf57VJDRDRP
         i2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793493783; x=1794098583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wg7J1WKS97sSKSOt6lNwjMTL6E8TpFeXp1Q3liA+6TE=;
        b=HjvNPnAodwh11bE6clZwxJIrKfuJziK4f8Y5PURQxeGN3iff9s3Q15Oks5N4VdDATM
         Qxfk++6e1Kqbg70GLcbeRruKtInwalHXX3/vx1iD7aVddg5vKy0KfP6J5zXY2FLeFHfx
         Q+1ibuUE1XQ23SEFHRNdaOo622Iq8MdEFTWOpcOeiuZv8HtfPtQKRzpjumiueku5pPM8
         2oIf352dnpg6fIuccd7QZSUiyfpv02yl/ZoF6FOe6GHqlWKk27oX0RAMTBbrO7no/xYV
         0wK/BuXcV3YUTaTH+wJnpDrbUcEfdPEUgqgqrnqHzn6XYHYBq34AQzcsXdNHJeBsbqBZ
         WVLA==
X-Gm-Message-State: AFq9FYLVbipcJk1wplOBjGOMucOTzaJapoY+I1Y4jo3u4NcGjmhvAUQ2
	RqO41Qa7NkDrYdMUgs/+Qwr0hSMPBpYX0icdMyNO8NXELpx+lVQ+fUxbhZfmr4oq0aa/bMxb4+R
	AQDj1isE=
X-Gm-Gg: AYBFou25dD+SARJ29URud/XbkUJYk4eelhaLMy7sla2a7SBqZB3nvjw8ERQm6p08LYt
	KCAjNJNtLfcP7/dcrTIQM+waQroGyBGFld8lXs1N6j4dWgTymN5fesuPIz5jORtcCd5KP1PZUsE
	lFN+NTxVsZF91oh81AgXnoBmucwVxu7k97TCxCtnRdOw7W95OmbkWEsah9Psy0SN3kT/EtiNEkM
	oo+ADWCiANsMMxzZad878KtbXiuJji6Soh5HWhMheKTOHiHFOjpzxPqe67DlCnlvQ1K1w2q9l2t
	BskxkcJEBQ/UFuPJm+CFiwfBEGD5Xu+/SBNORr8puAEnIPBXLQDwdVkZOnAT8XgD37rqYJ02YL6
	h9NYRtODdkOLmz85QpxYdzdW+yOeuwJd01iai+O5QEb+yUFh3f06QGfHP2Q+BT3cM+ospAs+NOe
	jT+151bAE0+w+VvgW+zR1CMy3HZvfoipw2zGymZvCQDdUynQWpGaMXG5Gi/4twQysZDRqWXnNnS
	bMC5/lAvNpt5recol9cPTEmLuMyWwx+u8spkhlZEG6VXEQJnZ58Jrf42oxg7NNfLMiELCpViz9K
	hzzHOnv2L+9lN0ROXMQgL0GKNMKk7TP1Vo0xbqtajBoAhZMKvciagu5mXoCIz7T791n6re3fTd4
	4
X-Received: by 2002:a05:7300:3b0c:b0:36a:238:1485 with SMTP id 5a478bee46e88-36a4244276cmr13559937eec.37.1793493783140;
        Sat, 31 Oct 2026 17:43:03 -0700 (PDT)
Received: from abeBadDesktop (157-131-71-212.fiber.dynamic.sonic.net. [157.131.71.212])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a429467cdsm20551213eec.19.2026.10.31.17.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 17:43:02 -0700 (PDT)
From: Abraham Zukor <abe@maticrobots.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Abraham Zukor <abe@maticrobots.com>
Subject: [PATCH backport-iwlwifi] [BUGFIX][NOUPSTREAM] wifi: iwlwifi: Fix thermal zone registration for kernel < 6.3
Date: Sat, 31 Oct 2026 17:42:32 -0700
Message-ID: <20261101004232.51269-1-abe@maticrobots.com>
X-Mailer: git-send-email 2.55.0
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

This is a backport-iwlwifi-only fix; upstream does not need it.

Before commit 7c3d5c20dc16 ("thermal/core: Add a generic
thermal_zone_get_trip() function"), merged in 6.3,
thermal_zone_device_register_with_trips() rejects a zone with trips
unless both .get_trip_temp and .get_trip_type are provided, even when
a trips array is passed. As a result, both mvm and mld fail to register
their thermal zone on older kernels. Provide the callbacks for
kernels older than 6.3.

Signed-off-by: Abraham Zukor <abe@maticrobots.com>
---
Build-tested against v5.15 and v6.1 (mvm and mld); runtime-tested on 5.15.
6.2-6.4 aren't buildable in this tree any more (no guard(rcu) compat).

 .../net/wireless/intel/iwlwifi/mld/thermal.c  | 40 ++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c   | 34 ++++++++++++++++
 2 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
index a4265a6ca..deeffd636 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
@@ -238,11 +238,6 @@ unlock:
 	return ret;
 }
 
-static  struct thermal_zone_device_ops tzone_ops = {
-	.get_temp = iwl_mld_tzone_get_temp,
-	.set_trip_temp = iwl_mld_tzone_set_trip_temp,
-};
-
 #if LINUX_VERSION_IS_LESS(6,9,0)
 static struct thermal_trip trips[IWL_MAX_DTS_TRIPS] = {
 	[0 ... IWL_MAX_DTS_TRIPS - 1] = {
@@ -253,6 +248,41 @@ static struct thermal_trip trips[IWL_MAX_DTS_TRIPS] = {
 };
 #endif
 
+#if LINUX_VERSION_IS_LESS(6,3,0)
+static int iwl_mld_tzone_get_trip_temp(struct thermal_zone_device *device,
+				       int trip, int *temp)
+{
+	if (trip < 0 || trip >= IWL_MAX_DTS_TRIPS)
+		return -EINVAL;
+
+	*temp = trips[trip].temperature;
+	if (*temp == THERMAL_TEMP_INVALID)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int iwl_mld_tzone_get_trip_type(struct thermal_zone_device *device,
+				       int trip, enum thermal_trip_type *type)
+{
+	if (trip < 0 || trip >= IWL_MAX_DTS_TRIPS)
+		return -EINVAL;
+
+	*type = trips[trip].type;
+
+	return 0;
+}
+#endif /* LINUX_VERSION_IS_LESS(6,3,0) */
+
+static  struct thermal_zone_device_ops tzone_ops = {
+	.get_temp = iwl_mld_tzone_get_temp,
+	.set_trip_temp = iwl_mld_tzone_set_trip_temp,
+#if LINUX_VERSION_IS_LESS(6,3,0)
+	.get_trip_temp = iwl_mld_tzone_get_trip_temp,
+	.get_trip_type = iwl_mld_tzone_get_trip_type,
+#endif /* LINUX_VERSION_IS_LESS(6,3,0) */
+};
+
 static void iwl_mld_thermal_zone_register(struct iwl_mld *mld)
 {
 	int ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 9d7b8f78f..18fa38ec5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -652,9 +652,43 @@ static int iwl_mvm_tzone_set_trip_temp(struct thermal_zone_device *device,
 	return iwl_mvm_send_temp_report_ths_cmd(mvm);
 }
 
+#if LINUX_VERSION_IS_LESS(6,3,0)
+static int iwl_mvm_tzone_get_trip_temp(struct thermal_zone_device *device,
+				       int trip, int *temp)
+{
+	struct iwl_mvm *mvm = thermal_zone_device_priv(device);
+
+	if (trip < 0 || trip >= IWL_MAX_DTS_TRIPS)
+		return -EINVAL;
+
+	*temp = mvm->tz_device.trips[trip].temperature;
+	if (*temp == THERMAL_TEMP_INVALID)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int iwl_mvm_tzone_get_trip_type(struct thermal_zone_device *device,
+				       int trip, enum thermal_trip_type *type)
+{
+	struct iwl_mvm *mvm = thermal_zone_device_priv(device);
+
+	if (trip < 0 || trip >= IWL_MAX_DTS_TRIPS)
+		return -EINVAL;
+
+	*type = mvm->tz_device.trips[trip].type;
+
+	return 0;
+}
+#endif /* LINUX_VERSION_IS_LESS(6,3,0) */
+
 static  struct thermal_zone_device_ops tzone_ops = {
 	.get_temp = iwl_mvm_tzone_get_temp,
 	.set_trip_temp = iwl_mvm_tzone_set_trip_temp,
+#if LINUX_VERSION_IS_LESS(6,3,0)
+	.get_trip_temp = iwl_mvm_tzone_get_trip_temp,
+	.get_trip_type = iwl_mvm_tzone_get_trip_type,
+#endif /* LINUX_VERSION_IS_LESS(6,3,0) */
 };
 
 static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
-- 
2.55.0

