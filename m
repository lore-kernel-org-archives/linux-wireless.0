Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532119;
	b=u6JjCPgkkw+JnHR9uaDWs1aqnOMZS1f9+9QU1AOvPIuPrMub8KEB572bZUDla/M0ZdVR
	 tvNOfSs8cZFrGsixZPkPiXqUwqVKu7Tyd6vTzAxZoG+JwAcSbinFPMn9e5tb5qfZaqgvc
	 u341Td2uV2BIXu734zKYmsqFQqLP6QNoeaYYaKJqCHchevqEaaOKbejhkzeWho3ZXreOj
	 ZfPU97FoJVhJ+3l9stbzmuvIf+nIOtHnr6gHdWgeTCKZMxbKx2BgyNI2KBTBjmM6CUdGO
	 3AuWtsyp6x4vA1ku/33LRKImoewFccCA/ww4mLhWyfa12tEqbRm72ZcT3A3gYZdMx3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532119;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=JnNQriX6Bbstn8TepnqDJgRRLBsCHc7/Dcoc4OhbyCI=;
	b=dsvmRL6yFRmGjLM0gcTrMXKkrngOFbey2BVrwti7hkUQ0TKIaxOF5/DflHOUXo1Hmyi7
	 8B6aoR8CDw/6MzY9XdqrljhUcYQKLyLh5kpDqmSGKcD4cyy2n6YgBUvSWnXq8MbzrIqwu
	 T1bvQ5SCIB6UE1f/r0BamKgB+YHsd4fyWYyCvmWW84dCjslDsb5VeywfCjS1lwZwIJ1XB
	 /53gJF05zmbuKKOjpFqgiroZFbxwZMyh3pbjS9gGwZai6+kYz79O2omIigpy3s4SSoAyb
	 kYaYQT0EHxvbTGSqx47hYGo/VxaG8vC3vbTiHp04oDb0HveNh2uW74T6COznqbvvZbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=j4cJPCA9;
	arc=none smtp.remote-ip=109.224.244.16
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1C9606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 21:35:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A1C9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=j4cJPCA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1792532116; x=1792791316;
	bh=JnNQriX6Bbstn8TepnqDJgRRLBsCHc7/Dcoc4OhbyCI=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=j4cJPCA9d2Q0bYz+NFNw/w3qEevfZtiXBUd2zYrgh3LGSW/OkGlUG7ig/y4pMrPwm
	 BR6aSw8c+ukHeczXLJXgN0BEpoJ16vGOJWKj8WFpKOTvJQwMZe6pk3YTFXr3eCOuvR
	 2wojWD/YFOldiUZIS9CP+aNVco+oIsmKCAdodnGpmpyiENg4fPWYaOuJ494miBAjSC
	 kFJUMkqE8cgSRezyWm4YIzzLxN81qNSoff6wtms95HA30v8tgraFYl+fzjCztJv6FV
	 TTcgU8BevMfZI+r+Kr5xm/lP+fffwOl9acjiginj7tvtCWwnebD9AXAh3e7jh0/xOS
	 PRXDfLy3U2eDA==
Date: Tue, 20 Oct 2026 21:35:09 +0000
To: Jeff Johnson <jjohnson@kernel.org>
From: Birk Skyum <birk.skyum@pm.me>
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>, linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath12k: don't count a vdev restart as a started vdev
Message-ID: <20261020213505.31624-1-birk.skyum@pm.me>
Feedback-ID: 21326998:user:proton
X-Pm-Message-ID: 0691d706ead9bfd175647fe90f64433c99c5156e
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

ath12k_mac_vdev_start_restart() increments ar->num_started_vdevs for a
restart as well as for a start. A restart is not paired with a stop, so
each one leaves the count one too high until the driver is restarted.
ath12k_mac_update_vif_chan() restarts every vdev that is up when its
channel context changes, for example when the AP changes the bandwidth
of the link.

Since commit 18ae7d0cdd76 ("wifi: ath12k: Avoid CPU busy-wait by
handling VDEV_STAT and BCN_STAT"), ath12k_wmi_fw_stats_process()
completes a WMI_REQUEST_VDEV_STAT request only after as many vdev stats
events as there are started vdevs. With the count too high that never
happens, so from then on every station statistics request waits the
full 3 seconds in ath12k_mac_get_fw_stats(), with the wiphy lock held,
and logs "time out while waiting for fw stats done".

On a Lenovo Yoga Slim 7x connected to an MLO AP, the timeouts start a
few seconds after the AP narrows its 5 GHz link from 160 to 80 MHz and
repeat every 3 seconds until the driver is reloaded. While they last,
channel switches take minutes to complete, transmits fail in bursts and
group rekeys end in a deauthentication.

Count only vdev starts, as ath11k does.

With this change the Yoga went through the AP's next switch of that
link, from channel 128 to channel 36 at 80 MHz, without a single
timeout, and the switch completed in under two seconds.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SIL=
ICONZ_UPSTREAM-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Birk Skyum <birk.skyum@pm.me>
---
 drivers/net/wireless/ath/ath12k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/a=
th/ath12k/mac.c
index 01f8c65..1b46723 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11472,7 +11472,8 @@ ath12k_mac_vdev_start_restart(struct ath12k_link_vi=
f *arvif,
 =09=09=09=09=09=09   &arvif->reg_tpc_info);
 =09}
=20
-=09ar->num_started_vdevs++;
+=09if (!restart)
+=09=09ar->num_started_vdevs++;
 =09ath12k_dbg(ab, ATH12K_DBG_MAC,  "vdev %pM started, vdev_id %d\n",
 =09=09   ahvif->vif->addr, arvif->vdev_id);
=20
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
--=20
2.53.0


