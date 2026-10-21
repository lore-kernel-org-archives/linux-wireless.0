Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584173;
	b=RplaJ5AG3kaWLAssLA8ylQEQgObn/2xNu6ay9PvoYacWkQhhRWOvtM4wMS2fTNnfOcoK
	 gS8E4ulXogovcIQvBBxr3lA6zEgYraH2PAXX/jOtikIOO6w2nYZ2ZXSZdTXZ6a9qWx/Jz
	 pcqxXUKV6PYuWZbiKeaPaCPkFjwDEy0jur9TNAuErEBaU/lszCpocLB5V5UtsJqcJZfGT
	 W/sR316AWku/IM7/jTt0BT1DbE2iibTxZ+AJ0gppDcdY10O0SUPnsg9kByEUWSWcSVMU8
	 Mmxib1maOyGMEFOeZY4+iOT8unf649R/4hU3flaYww3cUH7MUaepGbC+IcsBfUFJ0PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584173;
	h=DMARC-Filter:From:To:Cc:Subject:Date:X-Clacks-Overhead:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nJllOD0zFeNcYQhuoAgOmoW76rgc+MKuR6Dz5H82rL4=;
	b=NWwfPdJ1UgsFM9uaSzHJ6FWy+ZbIsdXu73rpmVGGXEQJa1f/gQUdplqhYTStG4WW2KVC
	 OSr4KIJkI83LPz+WcoXM11DPQQgY3waREWtBlS2GG1TGBjS/nC3sfKJjf3qryzOb9/4mL
	 Mt71FwWhU3D+Q0NlKbUZtv4obrX4QX8q63CIAVtAhwuhITNVTxxKZCELn/IuBVE3ezxVh
	 iG0FFcfJ7oJjfICmA7+VZaY9FLYns8Vokd0iizYNTfc02N30W/NbUzzQB2pG5AzNlPg8k
	 BxLX8kR+HU44nhwWNtH7k/ItB+S/IKCYNuvGYTyDu3ASvqiIBpanQLJqGDgwCx5yAvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23CA606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 12:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C23CA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Subject: [PATCH] wifi: ath9k: make sure we stop the wmi tasklet on init fail
Date: Wed, 21 Oct 2026 14:02:36 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <20261021120237.481898-1-toke@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The ath9k_wmi_event_tasklet() reschedules itself until device
initialisation is complete, but if the initialisation fails it is never
interrupted. Syzbot triggered a use-after-free in tasklet_action_common
because of this.

Add a guard to the reschedule logic so it aborts if wmi->stopped is set,
and add a call to ath9k_wmi_event_drain() in ath9k_stop_wmi(), so we are
sure that the queue is drained and the tasklet is stopped on teardown.

Fixes: 1af8dc9ca726 ("wifi: ath9k: Clean up device initialisation guards")
Reported-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e91dc13b1b37759b3d9f
Tested-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 4a08babb6d9d..c60c8b63623d 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -118,6 +118,8 @@ void ath9k_stop_wmi(struct ath9k_htc_priv *priv)
 	mutex_lock(&wmi->op_mutex);
 	wmi->stopped = true;
 	mutex_unlock(&wmi->op_mutex);
+
+	ath9k_wmi_event_drain(priv);
 }
 
 void ath9k_destroy_wmi(struct ath9k_htc_priv *priv)
@@ -148,7 +150,8 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 
 	/* Check if ath9k_init_device() completed. */
 	if (!smp_load_acquire(&priv->initialized)) {
-		tasklet_schedule(t);
+		if (!READ_ONCE(wmi->stopped))
+			tasklet_schedule(t);
 		return;
 	}
 
-- 
2.56.0

