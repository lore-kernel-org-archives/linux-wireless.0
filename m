Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECC0274B46;
	Sun, 13 Sep 2026 08:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789288800; cv=none; b=KUahRllCr5c5WZE4TRCwTPsvt5hKRiZ1TkaU5EdTE6dFWZCnsnlel+luHpuEAPI8A6U8n4Meed1szn0ksw9yMpFBLSoB+FWC99isCEkVHvrS6kl6pmaVcuQP8KgH6Q5zk8g7x7cn5BlOJjUBABRBd4R2MLS6grmADE1vr8jLSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789288800; c=relaxed/simple;
	bh=GcDONFtA9uFftvDMqsy1bLwSBJDvs9N9/hF7GORDYAE=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4XYsEWmXo475G9a4SY3pVj59JP41NbVW/TLinlVa0kHHxAvn01nrtcT4E83rFvh+qULua1HvnHzsuKhQlN0q3kQ0yxCTRxnuwfIjXYfLVN7Ab2BmBNoAcmxLjJk8mO5QYk2Ht5l+ib0hV5iH4yFvC/RRRlhc0U0oJwrVlhER8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mAVeEcwr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hDXXIM2H; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J79JnvjN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T3V0T1cT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mAVeEcwr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hDXXIM2H";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="J79JnvjN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T3V0T1cT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8130C21DAC;
	Sun, 13 Sep 2026 08:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789288792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2dAduLDXqL4CBdl1hLYbGkPK83sCAoA6B2hqpb3nhI=;
	b=mAVeEcwrX++rh1hErpjsosXs8s55nWbeWtBrYColQeAjlgFmb+Isg5GjVFeUSYsAf0+for
	qi8fl3Vnv+PRBZcVB4UUhYwThcdI13NiF85vurSEP7ZxOU20rL8UEcACVCSAT1SwPwjpuy
	bqPgj0hdSXA0F+nCIJrC5bCt73rwvIE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789288792;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2dAduLDXqL4CBdl1hLYbGkPK83sCAoA6B2hqpb3nhI=;
	b=hDXXIM2HY9Qq3978IBCvPxede2rufV1DZg2NYCkGx2dIbFlOLLvuUCxT+OCj2tPeSr9icl
	M12FoyyW3OZwADAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789288788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2dAduLDXqL4CBdl1hLYbGkPK83sCAoA6B2hqpb3nhI=;
	b=J79JnvjNdPgjOOrJdeEo8AzxsA2dIbXpfJQFpPXZ8I0UZrfU2skNqvLxInUJp+DgqvPynM
	vJuHpC7xhFjlxZPlLWokALFmTj3Vnb5Ibiu2DmRoxZjnR1RSH5tM04+8deBpfnI9IkKgT/
	SdqELC33kfrOmTdv0+JhRw90Op52jao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789288788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2dAduLDXqL4CBdl1hLYbGkPK83sCAoA6B2hqpb3nhI=;
	b=T3V0T1cT+mD9ZiWkM1iZUViC1qDwCcDLDF/o+9hCIhyQZDI3yk8USv2hTjEHejA+HTWcM3
	k6q7NmtqOh5EuTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F98813675;
	Sun, 13 Sep 2026 08:39:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uoQ9ClRhpmqPEwAAD6G6ig
	(envelope-from <tiwai@suse.de>); Sun, 13 Sep 2026 08:39:48 +0000
Date: Sun, 13 Sep 2026 10:39:47 +0200
Message-ID: <878q55sfxo.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Chris Lew <christopher.lew@oss.qualcomm.com>
Cc: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
	Pranav Mahesh Phansalkar <pranav.phansalkar@oss.qualcomm.com>,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] ath12k suspend/resume breakage on 7.3-rc2
In-Reply-To: <87a4plsg4w.wl-tiwai@suse.de>
References: <87a4plsg4w.wl-tiwai@suse.de>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On Sun, 13 Sep 2026 10:35:27 +0200,
Takashi Iwai wrote:
> 
> Hi,
> 
> on 7.3-rc2, the suspend/resume of ath12k WiFi on Lenovo Thinkpad T14s
> Gen6 AMD model is broken.  Upon suspend, the network isn't recovered,
> and the desktop got eventually frozen.
> 
> The git bisect pointed to the commit
> 544d85de4dc22c01badfd8cefa59829ce35c4858
>     net: qrtr: Send HELLO message on endpoint register
> 
> and reverting this fixed the problem.
> 
> Below is the (stripped) dmesg output after the resume showing the
> problem.
> 
> As far as I understand, the problem seems to be the change of the code
> flow: ath12k uses mhi_power_down_keep_dev() during suspend, so the
> qcom_mhi_qrtr_remove() and *_probe() won't be called.  This makes the
> driver endlessly waiting for the HELLO handshake upon resume with the
> commit above.

... and below is a quick fix I tested.  It seems working so far.


Takashi

-- 8< --
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] net: qrtr: Fix suspend/resume regression in HELLO handshake

Commit 544d85de4dc2 ("net: qrtr: Send HELLO message on endpoint register")
broke suspend/resume for ath12k (wcn7850 over MHI/QRTR).

The new protocol from the commit works on first boot: the host sends a
proactive HELLO at endpoint registration, firmware replies, and ath12k
waits for fw_ready.  However, ath12k uses mhi_power_down_keep_dev()
during suspend so that the MHI device (and the QRTR endpoint) remain
registered across the power cycle.  This means qcom_mhi_qrtr_remove()
and qcom_mhi_qrtr_probe() are never called on resume: qrtr_endpoint_
register() never runs, and hello_sent stays true from the initial probe.

On resume, the wcn7850 firmware restarts and sends a HELLO to the host NS,
expecting a reply to re-establish the QRTR connection.  Without that reply,
the firmware's handshake never completes, fw_ready is never sent, and
ath12k_core_resume() times out waiting for restart_completed (-ETIMEDOUT).
mac80211 then emits WARNINGs about hardware unavailability and cfg80211
tries to stop interfaces that were never started.

This patch fixes the regression by restoring say_hello() in
ctrl_cmd_hello() so the NS again replies to an incoming HELLO from a
remote node.  Also the patch removes the proactive HELLO from
qrtr_endpoint_register(); with both the proactive HELLO and the NS
reply active, the firmware receives two HELLOs from the host on first
boot, which confuses its state machine.  Since wcn7850 always
initiates the HELLO itself, the proactive HELLO is redundant.
The retry machinery in qrtr_send_hello() is retained to handle the
case where the HELLO reply fails transiently.

Fixes: 544d85de4dc2 ("net: qrtr: Send HELLO message on endpoint register")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 net/qrtr/af_qrtr.c | 25 +++++++++++--------------
 net/qrtr/ns.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 78347c937af7..88cfc116dbdf 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -598,29 +598,29 @@ static void qrtr_hello_work(struct work_struct *work)
 	struct qrtr_ctrl_pkt *pkt;
 	struct qrtr_node *node;
 	struct qrtr_sock *ctrl;
+	bool reschedule = true;
 	struct sk_buff *skb;
 
 	node = container_of(to_delayed_work(work), struct qrtr_node, say_hello);
 
-	/* NS must be bound before we can send; retry with backoff if not ready */
 	ctrl = qrtr_port_lookup(QRTR_PORT_CTRL);
-	if (!ctrl) {
-		schedule_delayed_work(&node->say_hello, msecs_to_jiffies(100));
-		return;
-	}
+	if (!ctrl)
+		goto out_reschedule;
 
 	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
-	if (!skb) {
-		qrtr_port_put(ctrl);
-		schedule_delayed_work(&node->say_hello, msecs_to_jiffies(100));
-		return;
-	}
+	if (!skb)
+		goto out_put;
 
 	pkt->cmd = cpu_to_le32(QRTR_TYPE_HELLO);
 	from.sq_node = qrtr_local_nid;
 	to.sq_node = node->nid;
-	qrtr_node_enqueue(node, skb, QRTR_TYPE_HELLO, &from, &to);
+	if (!qrtr_node_enqueue(node, skb, QRTR_TYPE_HELLO, &from, &to))
+		reschedule = false;
+out_put:
 	qrtr_port_put(ctrl);
+out_reschedule:
+	if (reschedule)
+		schedule_delayed_work(&node->say_hello, msecs_to_jiffies(100));
 }
 
 /**
@@ -661,9 +661,6 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	mutex_unlock(&qrtr_node_lock);
 	ep->node = node;
 
-	/* Initiate HELLO handshake from the core layer */
-	schedule_delayed_work(&node->say_hello, 0);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qrtr_endpoint_register);
diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index bcb090ee79d4..fe2dfc05e380 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -327,8 +327,37 @@ static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 	return 0;
 }
 
+static int say_hello(struct sockaddr_qrtr *dest)
+{
+	struct qrtr_ctrl_pkt pkt;
+	struct msghdr msg = { };
+	struct kvec iv;
+	int ret;
+
+	iv.iov_base = &pkt;
+	iv.iov_len = sizeof(pkt);
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.cmd = cpu_to_le32(QRTR_TYPE_HELLO);
+
+	msg.msg_name = (struct sockaddr *)dest;
+	msg.msg_namelen = sizeof(*dest);
+
+	ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
+	if (ret < 0)
+		pr_err("failed to send hello msg\n");
+
+	return ret;
+}
+
 static int ctrl_cmd_hello(struct sockaddr_qrtr *sq)
 {
+	int ret;
+
+	ret = say_hello(sq);
+	if (ret < 0)
+		return ret;
+
 	return announce_servers(sq);
 }
 
-- 
2.55.0

