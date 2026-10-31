Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793460624;
	b=EhY5ZgWzoRsIKQ+743R2N+GLEWVO7QrixLdHMU1Ld22bQSC1tCw1FWsrWjCsQpGZVEDd
	 GXBKb933QZMGc6+1kGYJ3d6yEwUo9IzxA5NNkaFgEWSw2UglRWwkP+FIFWq298LOxFIqL
	 JeJoVtCa9aNa9I6aez6hoz412HtkQ/GUMQmemzeWhw5baB6rgAzxkd0zzIorG5Q+uenUd
	 pKv9uwvbVmBhSM709Ap7KpfwrOeY5jzI4xwFleyjK83u3AmMNPN3YF1N4850Yjj7XhFxG
	 /DZNEGU4YTGDWnww3mQpUwXG9COYdG7lTIK/Q9B/EenRjQUUX+NH+/Bh0PpGx2Rhdyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793460624;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=twuHxH3IJ0EtCfthO+PL1m7RoIvVEDXKnV8gPEsFenw=;
	b=x+uusOZnEkR3NVfDKlSOp94IN6BHvtxn9kiYw1uToyclWFLaltuBwgMYQ6485KhJciHR
	 NMdDMIRFB82yI9r/VLnanlWBVWHadR563xtRlzRygygPw46zbzi2MrUkNbaER5PfWuujz
	 /lgc8EZoZSVm1oroytliikmWt3l1XaR0WQ3IHiymillD8RDjNfbOFG/XtVaLbnZhUG9GS
	 a7VFpVr/+cnXbNa1/mWOoUeE1xcRZvj3Yir6PTxZMfcuoAfEGHoWLOuuCGzvRDRdnR/oz
	 CivPdGx4tVPqVc/TUOaDyZsg1oOf4wrFbZeqGp+nMvDqjHCPd5s9dQoyGlq5FbW5cqg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bDc7iAfQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D72C606A31A;
	Sat, 31 Oct 2026 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bDc7iAfQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793460623;
	b=Zv7jbUrRFFrq5hBTaQk6BdShpib4uziiJCi4MvdjX+RmP/dpj7hjHA/tTcN7xCTL0sRk
	 tGaeLHoZcSdrOEW2oK0O9PqWmrYsnp2R8LxYBYgZ3ICZLrVWV+oJSytllUuABHqRqqvpA
	 mVTPdiXUWVuEobysrrV/Zj6fWHdluHG7rpS1NxV5NUT8ibOv5TRaAJ2RRXKK5kT4eKsLH
	 5Iqn7BXs2aLCjar3mbxe7IbNees0/3bLlgcnvvcjRD2e0bSrlN5aX2RcAjlGMOiAh/Pgj
	 ebdTtiaiqbFlRfP9cfDWYvru6EPgS7Bss3PCRNJs2iaXikw/Wii+DEa4xdU1t5clsCQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793460623;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=twuHxH3IJ0EtCfthO+PL1m7RoIvVEDXKnV8gPEsFenw=;
	b=ivn8gyATopYCvFtmoXLZpKbu9rTV8hG36Iis2hXmMt6f04N8JD6A8LEWyhKEIUx5cMMF
	 yz7FEqNJGRGLLu7CYZ6F4ivrBFt+hVL9v0ZLocE16gC/v3w3kLYmlS4/x6S1t6Qz/HGvf
	 LTtxPyDoIJeXPYwaaelHbi55ij1ufLD2S2DppbKEgNwcBAV+jPpX5eXttYjw+tOp4EV0M
	 safJdOm4oo7y8VKpJ9TRO+cZMvcSUvWgLlXqw6UT2UpWmBwtY7EmT9X2/QpUzWTjhOrGl
	 UPKNWe8IuDrrUAZ0Ag1C8t8Qcsz6mrtpt/mnfkmpuuluD5E0O/UAlAlXOM7bsyKLVlw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2A2A11F000C1;
	Sat, 31 Oct 2026 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793460623;
	bh=twuHxH3IJ0EtCfthO+PL1m7RoIvVEDXKnV8gPEsFenw=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=bDc7iAfQ6CXww1ms3b6lWBa82Q8nDemdBElEpYhlfanos/StT69dKvtg+msn2fEvz
	 Nsnc5wPmd7qUYPkcF1Z56dSzHj9SrQkM+Ijf9aiF8chNJ6ylq2oC3gUiUAHp3CTnyx
	 Db74eaRX+pTBeO+01umAbrC2VRKS7SOsXiV3X/KXPzOEjxUmYY3HBb254lK0tB+kuZ
	 40QKi85G2A3Sxp6tKH/UaatTFGvkufoUcehz8hQI2VyvDFVuqpAq+9JyschD3v5Gpr
	 Da+cabGicWjaoPnErlbDJDTCpfUqodZOcyTKsOZ7gNHnrsZLi0oqOJzaoFr43xxeMQ
	 LLqLrjhKoVq8w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7FC8245F1F;
	Sat, 31 Oct 2026 15:30:22 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Sat, 31 Oct 2026 10:30:22 -0500
Subject: [PATCH ath-next] wifi: ath11k: don't warn when a country leaves a
 pdev without channels
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
Message-Id: <20261031-b107-reg-no-channels-v1-1-896bd89a155f@gmail.com>
X-B4-Tracking: v=1; b=H4sIAI0J5moC/yWMywrCQAxFf6VkbSAZcXz8irjotLGNSCqTUQql/
 +5Ul4d7z1nAJas4XJoFsnzUdbIKvGugG1sbBLWvDIFCZNozJqYjZhnQJtweJk/HGBMfTkz9ORB
 U9ZXlrvMve4W2jGgyF7j9F3+nh3Rlq8K6fgHgOQerggAAAA==
X-Change-ID: 20261031-b107-reg-no-channels-66b15810d920
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793460621; l=2502;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=V7tNvA1MU393lNVR72C3Nhj4MRed2O220sx8YBWuIt0=;
 b=rhSgNEuN7hOdyzIQK5Uv75XU2JeLj0Ext5ZfY96nK2I0TvVhCLNJ+DXDwBMnFgF2tw+YdgOwh
 mTvlLvJizFXAVVk3m1iwIrWio5ZTeE0YUaDjz/iwiyP4cFMvJQiOaN2
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k_reg_update_chan_list() hits a WARN_ON() and returns -EINVAL when
none of the pdev's channels is enabled. Userspace can reach that by
setting a country. On an Arista C-360, whose QCN9074 is a 6 GHz-only
pdev, "iw reg set CA" left that wiphy with no enabled channel, and the
driver-initiated regulatory notifier then warned:

  WARNING: ... at drivers/net/wireless/ath/ath11k/reg.c:146 ath11k_reg_update_chan_list+0x368/0x3c0
  ath11k_pci 0000:01:00.0: failed to update channel list: -22

A domain with no channel for a pdev is not a driver fault. There is no
list to send (ath11k_wmi_send_scan_chan_list_cmd() sends nothing for
zero channels anyway), no vdev can start on the pdev meanwhile, and the
next domain that enables a channel sends the whole list again. ath12k
already treats this case as a debug message.

Log it at debug level and return 0. That also covers
ath11k_mac_op_start(), which ignores the return value but hits the same
WARN_ON() when the radio is started in such a domain.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.r4-00683-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
Seen on an Arista C-360, whose QCN9074 is a 6 GHz-only pdev.
---
 drivers/net/wireless/ath/ath11k/reg.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index 1030e119fd903..d6457ff3f591a 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -145,8 +145,16 @@ int ath11k_reg_update_chan_list(struct ath11k *ar, bool wait)
 		}
 	}
 
-	if (WARN_ON(!num_channels))
-		return -EINVAL;
+	/* A regulatory domain can leave a pdev with no usable channel, as
+	 * one without 6 GHz rules leaves a 6 GHz-only radio. There is no
+	 * list to send then; the domain that enables a channel again sends it.
+	 */
+	if (!num_channels) {
+		ath11k_dbg(ar->ab, ATH11K_DBG_REG,
+			   "no enabled channel on pdev %u, channel list not sent\n",
+			   ar->pdev->pdev_id);
+		return 0;
+	}
 
 	params = kzalloc_flex(*params, ch_param, num_channels);
 	if (!params)

---
base-commit: a3ddbb45768717b5c9f923489387cf55c838d1ad
change-id: 20261031-b107-reg-no-channels-66b15810d920

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


