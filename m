Received: from mail-05.mail-europe.com (mail-05.mail-europe.com [85.9.206.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CA5372EE2
	for <linux-wireless@vger.kernel.org>; Mon,  2 Mar 2026 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.206.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485657; cv=none; b=FwuoOSi5Ia+v3ZnaigTU2zkMjnfLU3N18VyZ8f3At+RbNL+6fmbnWcR3PSyFJ+9RTK/mFNdV3DLQDXnAdS5S2eWn9XH0exOF8AOZpiFRjjGL6s2keHCn7c6Qm61kP8D+aKbZVKAr2VbQlTc1yAS+ppHYTMwu+6+O0KCCO0Dpj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485657; c=relaxed/simple;
	bh=EekSGy/JPL3wGnaM2v/rWl0wKxVmIaBoQvyBvSln5rs=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=F9qZn1ym1dWnOslUM2Sa9ThtGpAwWNmSLcSZ0zpKVVPVqGYVzVHGOaWvBvP6aw+d36xBZDHT2psgebyQo2DPhBKyzt3rw4eG1Dy6j7HYiK8sESqQRN0idGqqvK2D62WnTxyEFfwIukWfrtdpB5V51EGI5ok20klKA1jshqCUh1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=clowdydev.com; spf=pass smtp.mailfrom=clowdydev.com; dkim=pass (2048-bit key) header.d=clowdydev.com header.i=@clowdydev.com header.b=ic0IBacu; arc=none smtp.client-ip=85.9.206.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=clowdydev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=clowdydev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=clowdydev.com header.i=@clowdydev.com header.b="ic0IBacu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=clowdydev.com;
	s=protonmail; t=1772485644; x=1772744844;
	bh=EekSGy/JPL3wGnaM2v/rWl0wKxVmIaBoQvyBvSln5rs=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ic0IBacua3HUtsppQPm5NtjFbxXQ4onifXOZrIvyLzxu2dOGAyqwbQtmWmm0O+J1w
	 g9ph10vF0yqu7GRF/NhbZdskkorEj2QlkwyMTZtBhcLDtvg7K06oAQWCgCt7WrX8Je
	 pRMxan/Lhw1XubxH3Z+UWO4y//US/SGq+/2UyFr89M1aKnO6tEo8mEWrMMbRtTkn/l
	 UW12b9zY70D0tV/3/jGtmRZica5+7O12bD7pIuKggEr8g6tdNBSw4Hj8bzjDl3J+PT
	 rLh0nfKvnNeTezairksN78+T+7yXtHzwFjdtX2GQo2rYLRGClW9e5PByvwWPM5hcOP
	 EAAzNZDWnJ/lA==
Date: Mon, 02 Mar 2026 21:07:19 +0000
To: jjohnson@kernel.org
From: Alex <alex@clowdydev.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org, clowdyffs <alex@clowdydev.com>
Subject: [PATCH] wifi: ath12k: fix tx_status memory leak on allocation failure
Message-ID: <20260302210703.1789448-1-alex@clowdydev.com>
Feedback-ID: 184521167:user:proton
X-Pm-Message-ID: 76f5c4564ce8dac150bb81aa24e45ab4cf6a573b
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: clowdyffs <alex@clowdydev.com>

When kmalloc() for tx_status fails partway through the TX ring
allocation loop in ath12k_dp_setup(), the previously allocated
tx_status buffers from earlier iterations are not freed on the
error path.

Add a cleanup loop to the existing failure path that frees all
allocated tx_status buffers. The cleanup loop mirrors the existing
pattern in ath12k_dp_device_deinit() (the normal teardown path)
rather than extracting a shared helper, to avoid adding call
overhead to the common deinit path. Happy to refactor into a helper
if preferred.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")

Signed-off-by: clowdyffs <alex@clowdydev.com>
---
 drivers/net/wireless/ath/ath12k/dp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/at=
h/ath12k/dp.c
index 1c82d927d27b..8ea0d41f9829 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1548,9 +1548,6 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 =09=09dp->tx_ring[i].tx_status =3D kmalloc(size, GFP_KERNEL);
 =09=09if (!dp->tx_ring[i].tx_status) {
 =09=09=09ret =3D -ENOMEM;
-=09=09=09/* FIXME: The allocated tx status is not freed
-=09=09=09 * properly here
-=09=09=09 */
 =09=09=09goto fail_cmn_reoq_cleanup;
 =09=09}
 =09}
@@ -1570,6 +1567,10 @@ static int ath12k_dp_setup(struct ath12k_base *ab)
 =09ath12k_dp_rx_free(ab);
=20
 fail_cmn_reoq_cleanup:
+=09for (i =3D 0; i < ab->hw_params->max_tx_ring; i++) {
+=09=09kfree(dp->tx_ring[i].tx_status);
+=09=09dp->tx_ring[i].tx_status =3D NULL;
+=09}
 =09ath12k_dp_reoq_lut_cleanup(ab);
=20
 fail_cmn_srng_cleanup:
--=20
2.53.0


