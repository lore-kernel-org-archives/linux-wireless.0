Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793066184;
	b=FkBU9RUFkzgaz6cmY82b3/1MB5ZRn+rzCVGAuJh9NRzLVQ8wJnU+3ynCecRtySJQi3DX
	 3gZl0nrNKr+3171C4Kop3xAKHxzwYY/lIv4gau+A6zRMNS72Nkvu2v1WGF78dFsKm6tUT
	 mPsnRwe8VOloYit4iAUCWcAzL61NYfd/Hqg3UzGLG86Kz2/wYME217c5GT++soCVhHHvZ
	 wiiQ/NQhl7UIfu+1kYVsWkm7mJVSIGG/GxWJO6gG6q8hsjYA9iHME81hk+TT6r4R22Gan
	 t0SAHKFegTEF+NlGs2Cy+JUZK37vgtD/owSSd79PCJ12hwZrwx87eGmQcW1hFVZAsgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793066184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=MnnFd0HiOos9iEFulqxTt8hlW096T7H13qBtT/3EgOM=;
	b=Coi+hZXSuliNhjFeLE2QfmRZNo4if6PzIU1tlrhKocit7rfyEYNeEe6pykaChdCjDJcX
	 LrbmWn448+m75MDwh8QMwCFWQNfSHILGN5Re8lJbmvaL15/z9L8M8BYZS2w1dQSBWfBe3
	 iMykxpdCv9XYBEn479ltaz3H4Qw8TvaA+5l1W5Cx8DXO9Cpzp2+qYmo0kmXk6D3c7ocXh
	 VTTNIOm7PzBYTwBL4Qb4z2TmLyyiGlDY60g7fXjqtR2EfFiuwJLCg8Bh95rErSvOl2cBD
	 4P2irB7O87x/vz4grmCUqt2BSRJi/bIsCw5PuevefKIGNek3UvTjY4bumZtBxYXwl0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L4Xjp2bU;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA813606A328
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 01:56:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA813606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=L4Xjp2bU
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so23471205e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793066182; x=1793670982; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MnnFd0HiOos9iEFulqxTt8hlW096T7H13qBtT/3EgOM=;
        b=L4Xjp2bUi6Z2Hn2iyaUyCKq0owzFblRHRlb1uxHl27WGlXGOY8cgV0jeqv0OgOZJvF
         WUCq/alzOaHo2u4ny3Rg0dnNs4F9aHQoIPV6rfvCltHv833G99RPV+/+Cw90K6JD2snW
         8pH3XJzs5UCmqjZK6n87jWdBY9yS1qePPg5hQS7LHaj1dswhponmJukus10jrzHRx7Vw
         TJi+v3Vn4wN3gUMlS9MXSonh4UsYoLrirwhruy8ujri03PoSt1zwUHOBtctsdH5wcs+j
         F2Xoi7Q605GHI1zFmygQ8byYDObK16P5rmUK0U/HeLtBE/4abQUzByldDzJxnGP6HGmT
         Sqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793066182; x=1793670982;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=MnnFd0HiOos9iEFulqxTt8hlW096T7H13qBtT/3EgOM=;
        b=ge8yqchmUng3FC9oKuH6+DxjtxQN3FAlVgWtvZ3un+jQN8IXXw9WFlAEqAQsP/l9cv
         hTl8IbjSG3J9XdSr7XydJsGtXdWoOYseeCZpiUhucEQAMLRvuf+qe2vjJXUgSlOGXtA9
         P4/Y6K67xP2114lf6+joO6rOWyvqkkPP9uFDBhpVjGnyk4jidE+Q4EUUzZAYbqtzyLaS
         bQU2MR1EV+vB5fXsJwS3G41tYllVjdcF4dqWHDlFVKFw02tWRIfF0h0Bsqujw1rdzMDf
         7W3fKFgg4GYJhfld4d960onsJi3V8B+S7qpN9os4S15yKsHjuS2G++DM5ojEqkbxGxQH
         qoMg==
X-Forwarded-Encrypted: i=1; AKwUvBxp8pvtoeOXr4fQR6a9Tj2uvmc1SgD4cvdC8N3nlitGLATil9XXkwV8wNFXm4Q/pixYxCS2Yxv1pw5YwWqzmw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLWSSFpiL0OW5xvKVH/KuDxyBqd8vaAHyQoEbsIT1P+zFPtAs5z
	PS0b2cEPsH9zsRBOP9MN5pHUw/HjAh075NPA08IJW4yg4nbdlm/hun+9OrBk9kcoLS0=
X-Gm-Gg: AYBFou3Hn806mhhntfW8cc2L4I+56TiompSiZR6sklrj5HY4jdWhr4hiuXwLzLGUsYv
	wminzCZueNS732gLmPNf8JqtUsZV+NF8783Pgd6bwmuazgAThKRx9LuT/GK68tUn/CipMPQS9PD
	WSuvJgyXFQ6fIfC70SOmI+huGmX8JME65h5Fib7I5K4VPPBXL64ibmc1hucYFdISD16eTLUA/8V
	W13SLZVAFpS2r2y6kTsWTfFRiIf25UgLWW8IG5Tx//GsZjDBn+wBV0pDAW3kogOUQ4v8PDZzxMI
	fs3lcXe+WLGl/3l5YZXDuzMo2DKeLGy06ts2LX31MzSfZFmnRjV1kJmdV4h7XMw1P3OhnwYVWel
	yd+w3JKL40QHeD99q9lhV3GtsId0+bWBrGzgAmCz6CuxHuK0wHMguoeAYd4u6rFGua0lc709hvh
	BqOnE50ASU2rUiilz1Fv/kh9RKliKVeHMsnlvOvedmI5k8k3jQuHQ8cPqw7QIfkx/8gQsfUQzNh
	FgDfDg1QL7mHAjjJ9dEEmelEF1+Ht1w9cZQ7b4qBPAJDDenSVjjI8LdQ/IckV339wcRTlb2vua2
	jXXWiudhUwW6ZRetfntV9ZGRbgCvspVhXNeDwQ4=
X-Received: by 2002:a05:600c:3493:b0:4a2:a6e:80f5 with SMTP id 5b1f17b1804b1-4a35ac9d0e8mr157003625e9.11.1793066181977;
        Mon, 26 Oct 2026 18:56:21 -0700 (PDT)
Received: from [127.0.0.1] (smal-20-b2-v4wan-173097-cust1152.vm20.cable.virginm.net. [77.97.36.129])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0aa0bcsm289674855e9.4.2026.10.26.18.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 18:56:21 -0700 (PDT)
From: Filippo Falezza <effeffe99@gmail.com>
Date: Tue, 27 Oct 2026 01:56:20 +0000
Subject: [PATCH v2] wifi: ath10k: Stop unanswered temperature reads
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-ath10k-temperature-v2-1-0793e80d73bc@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22Nyw6CMBBFf4XM2hpmEmp05X8YFqWdwqg80haiI
 fy7gHHn8iT3njND5CAc4ZLNEHiSKH23Ah0ysI3palbiVgbKSWNOpExqMH+oxO3AwaQxsCKqEM/
 eaSwsrMchsJfXLr2VX45jdWebNtO2aCSmPrz36oTb7hfQ/wITKlRcWKe945NHvtatkefR9i2Uy
 7J8AA8VZLrGAAAA
X-Change-ID: 20261022-ath10k-temperature-22b119fd615c
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, 
 Loic Poulain <loic.poulain@oss.qualcomm.com>, 
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Filippo Falezza <effeffe99@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793066181; l=5040;
 i=effeffe99@gmail.com; s=20261022; h=from:subject:message-id;
 bh=hPT1uLYKS1NCl1gE+0KTb0caCJTisLRSF4QlmjovWDo=;
 b=arFxWloT1KfTE4e0x+lGRO5qlJLn0ARuEMY64ZknvHDszn8Xy8kOYVZAHm1Cgtr653nxjz884
 zoKgmBHgwCfDwO1fIStfYwxaWWLtKPw2AbJI/FKIxupmBYpRgxcq1Yu
X-Developer-Key: i=effeffe99@gmail.com; a=ed25519;
 pk=7PPwl4QILojrh+ATB5QOpvXVmmoxaxyLQhrLRLWEL0I=

Reading the ath10k hwmon temperature sends WMI_PDEV_GET_TEMPERATURE and
waits up to 5 s (ATH10K_THERMAL_SYNC_TIMEOUT_HZ) for the reply event,
holding conf_mutex. Not all firmware answers: the WCN3990 firmware
WLAN.HL.3.3.1-00694-QCAHLSWMTPLZ-1 on a Motorola Moto G 5G Plus
codename nairo (SM7250) never sends the event, so every read of
temp1_input stalls for 5 s, logs

  ath10k_snoc 18800000.wifi: failed to synchronize thermal read

and returns -ETIMEDOUT. Tools that read all hwmon sensors, such as
lm-sensors, hang for 5 s on every run, and configuration changes of the
interface wait for conf_mutex in the meantime.

Whether the firmware answers cannot be told from the chip: firmware that
answers and firmware that does not both advertise
WMI_SERVICE_THERM_THROT, and WCN3990 firmware differs between devices.
Instead, remember that the running firmware did not answer, and return
-EOPNOTSUPP right away on later reads. Forget it when the firmware
starts, so that a restarted or updated firmware is asked again.

The first read after each firmware start still takes 5 s when the
firmware does not answer. Reads on firmware that answers are unchanged.

This change was written with the help of an AI coding assistant; see
the notes below.

Fixes: e98199a8c27f ("ath10k: enable QCA6174/QCA9377 to read the chip temperature")
Signed-off-by: Filippo Falezza <effeffe99@gmail.com>
---
Hello there,

this is v2 of the fix for ath10k temperature reads that stall for 5 s
on firmware that never answers the request, as on the WCN3990 firmware
of a Motorola Moto G 5G Plus (SM7250).

The only change from v1 is the name of the flag: it is now
ath10k_thermal.broken, as Loic suggested, instead of
temperature_unanswered. The behaviour is the same, so the testing from
v1 still applies: on the phone, the first read after the firmware
starts times out once after 5 s, every later read returns -EOPNOTSUPP
within milliseconds, and a full `sensors` run takes 25 ms instead of
5 s or more. Restarting Wi-Fi makes the driver ask the firmware again.
I have not tested firmware that answers the request.

v2 builds with W=1 for arm64 and is checkpatch --strict clean, on top
of ath-next (cd026e68fdbf).

As with v1, I wrote this with the help of an AI coding assistant
(Claude Code); the testing is on the phone.

Thanks,
Filippo
---
Changes in v2:
- Rename temperature_unanswered to broken, as suggested by Loic Poulain.
- Link to v1: https://patch.msgid.link/20261026-ath10k-temperature-v1-1-e5cd6fde7f1e@gmail.com
---
 drivers/net/wireless/ath/ath10k/core.c    | 1 +
 drivers/net/wireless/ath/ath10k/thermal.c | 9 ++++++++-
 drivers/net/wireless/ath/ath10k/thermal.h | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7c2939cbde5f..a749ae582b0a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2985,6 +2985,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
 	ar->running_fw = fw;
+	ar->thermal.broken = false;
 
 	if (!test_bit(ATH10K_FW_FEATURE_NON_BMI,
 		      ar->running_fw->fw_file.fw_features)) {
diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 9bb486f8e920..9ff7de0abd12 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -75,6 +75,12 @@ static ssize_t ath10k_thermal_show_temp(struct device *dev,
 		goto out;
 	}
 
+	/* Don't stall every read on firmware that never answers */
+	if (ar->thermal.broken) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	reinit_completion(&ar->thermal.wmi_sync);
 	ret = ath10k_wmi_pdev_get_temperature(ar);
 	if (ret) {
@@ -90,7 +96,8 @@ static ssize_t ath10k_thermal_show_temp(struct device *dev,
 	time_left = wait_for_completion_timeout(&ar->thermal.wmi_sync,
 						ATH10K_THERMAL_SYNC_TIMEOUT_HZ);
 	if (!time_left) {
-		ath10k_warn(ar, "failed to synchronize thermal read\n");
+		ath10k_warn(ar, "failed to synchronize thermal read, not asking again until the firmware restarts\n");
+		ar->thermal.broken = true;
 		ret = -ETIMEDOUT;
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index 1f4de9fbf2b3..d1fb5b958c37 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -19,6 +19,8 @@ struct ath10k_thermal {
 	/* protected by conf_mutex */
 	u32 throttle_state;
 	u32 quiet_period;
+	/* the running firmware did not answer a temperature request */
+	bool broken;
 	/* temperature value in Celsius degree
 	 * protected by data_lock
 	 */

---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261022-ath10k-temperature-22b119fd615c

Best regards,
--  
Filippo Falezza <effeffe99@gmail.com>

