Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792888363;
	b=CsvVKt5m2XsyXbt1ZjEEh/yHeE9ibrs5i2pBeLECJdlA9bKW/kqYI/12vfFfIub/pISc
	 qQ8CTNNMwSOD/u1KhDnDI0LnQ3a2W8EVrbHZzAEfoOqzZNW87Qe7ZvanJhy57KTxLnuk+
	 HwqG4aIdGWt+DIFDEllG4CblsoImnSk8lP564au4iXaFd+bIlYRLstNRI/LScFn6Cyc17
	 cG6xiqM11JyOECMi1hilr8Xlcrew2CHSVhbbUrI6DRHahojAxjftJBl7xj0CDZ87EEnXR
	 ER3gtk3MWlYb7zuCh+KK5eT6k/CA/S9G/ILdutuc4cPnIhPZ5VKNcR1Fgqx9qVYwWOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792888363;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=elNTPs/3352rT0kuJBRGH5/8R2WUV3wPm0u63wq+33k=;
	b=J5G4GkTpdZ27EKy9NQDJ1wi6lPs2jx6fYvVez7tI2oQ97wNyINOM0yQW5ATePhzGYW4X
	 epMXu+q9TSZlcu5E+Po7lRNC9WzVVHwDrMsdBuPe4vL+ELU79eMUoCz5mqLr5TBbEw3wr
	 EPR739tg5XLfkENjbvOiXlbsb+QIy5ADFpe1jkN7aONvX902woVuIDgKWEsFWsmwTNyb8
	 00SVNWZEWUACfLRBYtm0JKboRvvvDFfDmzZqJb3IFNTfz4wJpO5Sw1sKG0vaXChJPLmgs
	 F+J9o1eaOMDXbGfmN/WWauaTPk2OnofngaZZamn6aLBvbRoXw5UnmsMZhZ7eUqbPiwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZ5E7npX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97332606A323;
	Sun, 25 Oct 2026 00:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TZ5E7npX
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792888363;
	b=NxCZLDgneF97B/bnBdkRAG7u/MjGmNxcG9SDls8HhUKsLg4CiO5aT52B14vRbLgdLoBg
	 hs3DzJiZmZSkMGyDTgUMqugS30tX0Z7Kg29tXpaYAbKc2aHioYUF2jpRxTzZ8kSe9yynY
	 lw2lfsANhj0yhfjDGGa/s83chH536/xBOxS0rWiW/nqnCxYw4EjExmkNA9mNaWpE+AKzO
	 cIUjct5MtByBMhnCnSB6s8m5u9ESL3K8ndF8mEhrIQLE4hArdTyFoXj4lQIlRyVxISrjz
	 IxS+a7S4+6R51rMnso01jr0MwfIN+aS1+quKLC/g0NqIke8c1X3mLYFvhBXeF46cJvA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792888363;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=elNTPs/3352rT0kuJBRGH5/8R2WUV3wPm0u63wq+33k=;
	b=Qu3aF5+k6ssgtyJqsfXpFDvL2KFvCnyKIVLi0TeXHMuuewI9g4fcfPqeJQquGTn0X365
	 WT4cuRo4J+oIeB0G6kHvdYVd7v6mzSrksFEzjeVKPf0gpfnsYkyBLRTmdSrNcTIzfPW90
	 YubZ5rs+kySYHHugr+ao3pJSJyesQ8H5AmGBNBNK6zDvTBF8xYmGwvQOdw0l+93lmdAUQ
	 pPb3IuNxjWGlyh2IolPdm8tBd8iTWhY5WUW/ExL9AjFNBv3/W3vY3L/3TN6DQYA+RgaBw
	 OVJI0c8fWlJVV1u5oHFGBPdGlP5fqrKP4b7DoG6gKeWOqyIjdIBHC99XWul+DnFzQqw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E968E1F01828;
	Sun, 25 Oct 2026 00:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792888363;
	bh=elNTPs/3352rT0kuJBRGH5/8R2WUV3wPm0u63wq+33k=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=TZ5E7npXlueVtVaJX4G4RqfrsSbpZiUCp3w5qG53iD6qyMdF8zDBgNkAzWeEweJt0
	 u/dXg6MiQvXDqKjXfJJHkoER4I7ma1vp5c4A1dfhs2iA3cVFEojmUpVaEcvO6XP1MZ
	 YJFoY5mv7Lakl94f2XyLPnt9jPsULAxy8E/XJqh3DFdSfcH71+uq27Bvrm1Kc9oLbh
	 MGV72TVuRLNqOqQFSVz06l0s6q2iKrcwKeep9BpXF6HHnV/4AAahCWrgMHGmdlP4OA
	 fdwQWfRDbv9DU+536mn7AfUFqNTAhxnseJGdvYPgZ2TZZ7easyY/soHdQZ7Tcre9Ip
	 SzUiqMVSTmFNQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7BD29448FE;
	Sun, 25 Oct 2026 00:32:42 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Sat, 24 Oct 2026 19:32:42 -0500
Subject: [PATCH ath-next] wifi: ath11k: report the measured noise floor of
 the channel in use
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
Message-Id: <20261024-ath11k-survey-noise-floor-v1-1-8eb03002aab8@gmail.com>
X-B4-Tracking: v=1; b=H4sIAClO3WoC/yWMQQrCMBAAv1L27EITaol+RTyk68auSiLZtFRK/
 26sx2GYWUE5CyucmxUyz6KSYgVzaIBGH++McqsMtrW9aW2HvozGPFGnPPMHYxJlDK+UMpLzxxM
 5ci50UPt35iDL/r5AzTDyUuD6NzoND6byW8O2fQFrcLFyhwAAAA==
X-Change-ID: 20261024-ath11k-survey-noise-floor-c8a59c8c88f4
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792888361; l=4101;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=qzZpKyEkcevX8rqLtU57o7fduxhGno+SZWFUzasBvOE=;
 b=R0N9mUzH4SMm1KlvBjfjsJOkVQZRGfvnfOe/ESbC1iLVtxPLZF0dGGkLLf1uHQTi5xKJnLavu
 Afy7b6eaiiUB4G/Xv0Btmfz0qx2VpOwylsc7HbeXlr9lh+9PdZ+1Fnk
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

For the channel in use, ath11k fills the survey's noise from the
firmware's pdev bss channel info event. That value is not the channel's
measured noise floor: on IPQ8074 it reads -108 to -109 dBm on 5 GHz and
-101 to -102 dBm on 2.4 GHz and barely moves, while the firmware's pdev
stats report the channel's noise floor as -94 and -96 dBm at the same
moment, and the channel info events of a scan give -93 to -96 dBm for the
other channels. A noise floor near -109 dBm is not physical for an
80 MHz channel, so `iw survey dump` and anything built on it show the
channel in use 10 to 15 dB quieter than it is.

Request the pdev stats when the survey of the channel in use is read,
and report their channel noise floor, when it is plausible, in place of
the bss channel info one. Keep it in the channel's survey entry as well,
so the channel shows its last measured value once the radio has left it.

With this, on an IPQ8074 AP the in-use survey reads -95 dBm (5 GHz) and
-96 dBm (2.4 GHz), equal to the pdev stats, instead of -106 and -102;
after a channel switch the new channel reads -92 dBm, as the pdev stats
do, and the old one keeps its last measured value.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
Pairs with "wifi: ath11k: update rx_channel on a channel switch", sent
separately. Without it, after a channel switch the survey flags the old
channel as in use, and this patch would report its noise floor there.
---
 drivers/net/wireless/ath/ath11k/mac.c | 44 ++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa..570321f76 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -9338,6 +9338,46 @@ ath11k_mac_update_bss_chan_survey(struct ath11k *ar,
 		ath11k_warn(ar->ab, "bss channel survey timed out\n");
 }
 
+/* The noise floor in the firmware's bss channel info event is not the
+ * channel's measured noise floor: on IPQ8074 it reads about -109 dBm on
+ * 5 GHz and -102 dBm on 2.4 GHz, and barely moves, while the measured value
+ * the firmware reports in its pdev stats is -94 and -96. Report the measured
+ * one for the channel in use, as the channel info events of a scan do for
+ * the other channels.
+ */
+static void ath11k_mac_get_chan_noise_floor(struct ath11k *ar,
+					    struct survey_info *ar_survey,
+					    struct survey_info *survey)
+{
+	struct ath11k_fw_stats_pdev *pdev;
+	s32 nf;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (ar->scan.state != ATH11K_SCAN_IDLE)
+		return;
+
+	if (ath11k_mac_get_fw_stats(ar, ar->pdev->pdev_id, 0,
+				    WMI_REQUEST_PDEV_STAT))
+		return;
+
+	spin_lock_bh(&ar->data_lock);
+	pdev = list_first_entry_or_null(&ar->fw_stats.pdevs,
+					struct ath11k_fw_stats_pdev, list);
+	nf = pdev ? pdev->ch_noise_floor : 0;
+	/* keep it for the channel too, so its survey shows the last measured
+	 * value once the radio has left it
+	 */
+	if (nf < 0 && nf > -127)
+		ar_survey->noise = nf;
+	spin_unlock_bh(&ar->data_lock);
+
+	if (nf < 0 && nf > -127) {
+		survey->noise = nf;
+		survey->filled |= SURVEY_INFO_NOISE_DBM;
+	}
+}
+
 static int ath11k_mac_op_get_survey(struct ieee80211_hw *hw, int idx,
 				    struct survey_info *survey)
 {
@@ -9381,8 +9421,10 @@ static int ath11k_mac_op_get_survey(struct ieee80211_hw *hw, int idx,
 
 	survey->channel = &sband->channels[idx];
 
-	if (ar->rx_channel == survey->channel)
+	if (ar->rx_channel == survey->channel) {
 		survey->filled |= SURVEY_INFO_IN_USE;
+		ath11k_mac_get_chan_noise_floor(ar, ar_survey, survey);
+	}
 
 exit:
 	mutex_unlock(&ar->conf_mutex);

---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261024-ath11k-survey-noise-floor-c8a59c8c88f4

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


