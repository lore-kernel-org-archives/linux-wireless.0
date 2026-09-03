Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2E550C2B6
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468991; cv=none; b=apzCVqZDU1mOGQXE1k1Ckc0hugxsZCRd2Xkj8q5JGlsjb3RCgAOEWexvZAFHhNTfvEnYWJm+4HDmfmdhy4myjsV+PEeECZyTAzzoXBOcH6P54d0Y6yC7Uwud+vZ9G3GbhiZQDdULf58LQw9lmGv4S4SWdBNimr4qsVaYAGEXr08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468991; c=relaxed/simple;
	bh=asM3u2jh2/97ma/RigKr/jhcfK2a1T/GQYGyli6hKw4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PdMDpKYxfMEnmUoHoVwBrFEFpcAh2kWeFUR/plPVBp03W4mastlhN6MjJ9CYg179hujdkH7l0nWFg1LzuViMQxIjJqSSUVjFTh17hhFmSj9xcEAaIJ/VU1DxyByMTmgkALVpQCo+YzBgQ8T8t57BmP0MKP/Zc9A+rtL3LAEPcCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=oybCd1ev; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="oybCd1ev"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-52d8679c149so3991501cf.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 13:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1788468981; x=1789073781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=omcuQrXyWn92mT7/l5cfyeWdZD8VtU1sSuEMsPrFlZA=;
        b=oybCd1evk4sAK+iGb2ojUB9x+GtRbYMjyKcG5CdCgfMiCGLieM3mKh9/digSW31lyO
         y76otpy2sV37+9OE+fzYDzVB65TDOfzo/CJjdGXgZUDDk2Xuhay1nyN8nt6YD+yAk8qG
         VWeIATpbzMWK5B2O8zbJtj/n7hjY1CJiskFL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788468981; x=1789073781;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=omcuQrXyWn92mT7/l5cfyeWdZD8VtU1sSuEMsPrFlZA=;
        b=V0M33QZgl+1SKSsoz8TdLZkeeaTG4+8Ys+yYT+JcyaJ/lkrgHthQdG8FYyBXXF6Fd2
         vlJQj5rLRZ15XmfjmJFITYkIh4W9Mymvd77AjypruS07PZCwsnu5JLuMj2FOBIrtnVaG
         Xllf9GLZXpRLHZe9rM47d966iM1yQezSD0Zg/dqH0wBZNL081yGQmlLxLq97O6IBy2OX
         h9uisVLVcjqF359c+dWst2V8S41QY5T7YNwP/stV6LupSPOxf2WJejAp7i/1f9/p+WAJ
         lzoESNakFu1/ghBgbcRVcgw/W0BtaEuMHc+OjYaaBLj5Kd8ZKwlgrO1V61Gp39H+JeKa
         oFpA==
X-Forwarded-Encrypted: i=1; AKwUvBzlBCREMDfwwarABtGuvE3alqeJcJNR9ypTER/zpUcxlcaKbTUnfwNwtLqrXNShFFqnh8D3C3I4lPOlX38kEg==@vger.kernel.org
X-Gm-Message-State: AFuF++mdWVneuNJSr9m6ARXVsHkVv8lq/c6tOQnVFZxLt527tTIJ1B52
	e44AUq3S4tN9zvU7sQA6SoRqqhNiHgOMPBV6+iHuT56wH48FPpQtjFLKQwsQLz0+TQ==
X-Gm-Gg: AYBFou1XTQe7Rkaa/5gPfEnjj6sAdS3RoRnA6zqK3fJNO29hf8vJ0LFdjOC3IpDYSMY
	gdmI49PylmZv2K0+TnPmguFzx+4D4UxzNYNr6h3TZvCihoWyKTJv4UjQgE9pydoOP+nNkheflJl
	HAd4AVqjYPID4bz0t2czBh0pmDdhmhLuKNcwpjNx44PyRRQQMaPn/Koqtg6NWfbaInTuBFFV5n+
	vSsnJbyZEQH8GyPALWeJMrEUhKCLdzWIYRYhZJvJgsy0XwQId+vHjJDHw2Im59qnc4kT/K3L+NA
	wx3kE/EqQnTuwb1Yx9CUqRNgBw2DgWGhNfybz55qkbXxSrGUuP/82y8iH1TtUZ6aEVfkr/0dme1
	wUaerN/8aKUzjqQYPGeNF4hUNNh+PHAHTHHbHnYAcCj3ZP/mu2uiprnuRrqlPE42okHnbGwGKke
	U59lYpQ+gwZOHdfJmIWa0kHgXJKsubscieGNTjIP/P525d3DLqUSLBHhzi3ATzK3mmqSatk1f6H
	c8eaHrHK22OtZY9dt1PuqKuPE5W/fO+cnYKqOx4Vf28KjvXhiYJtxwujMXhPpsk7VpF9G73EtwH
	csYc6pjm7pxB
X-Received: by 2002:ac8:7f0f:0:b0:52f:b9ad:9dc1 with SMTP id d75a77b69052e-530548ea102mr18677551cf.20.1788468981102;
        Thu, 03 Sep 2026 13:56:21 -0700 (PDT)
Received: from majuu.waya (pool-174-112-106-84.cpe.net.cable.rogers.com. [174.112.106.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305422fc07sm5509881cf.31.2026.09.03.13.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 13:56:20 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
	stable@vger.kernel.org,
	Jiri Pirko <jiri@resnulli.us>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Vega <vega@nebusec.ai>
Subject: [PATCH net 1/2] net/sched: codel: bound the dropping loop per dequeue call
Date: Thu,  3 Sep 2026 16:56:15 -0400
Message-Id: <QDISC-1L5H.v1.20260903184552@mojatatu.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CoDel control law schedules the next drop one interval/sqrt(count)
after the previous drop, using the configured interval
(codel_params.interval). For very small intervals the scheduled step
rounds down to zero, so the dropping loop in codel_dequeue() never
advances and drains the entire backlog under the qdisc lock in one
call - an unprivileged user can trigger a soft lockup this way.

Fix in the shared codel code used by both codel and fq_codel:

1. Make the control-law step at least 1 tick so the dropping loop
   always moves forward.

2. Cap the dropping loop at CODEL_MAX_DROPS_PER_DEQUEUE (256) drops
   per codel_dequeue() call, resyncing drop_next to now when the cap
   is hit: the catch-up owed to the loop grows with the idle gap and
   the backlog, which no interval threshold can bound. This is a
   deliberate behaviour change after long idle gaps.

The cap applies to fq_codel (4b549a2ef4be) and the mac80211 TXQ path
(fixed interval, cap only).

The target sojourn delay (codel_params.target) is not validated: it
does not feed the control law, so a sub-tick value is aggressive
rather than deadlock-prone.

Conditions to recreate the bug (repro from vega@nebusec.ai):
  - tc qdisc add dev lo root handle 1: tbf rate 1kbit burst 2kb limit 1000000
  - tc qdisc add dev lo parent 1:1 handle 10: codel interval 2us target 1ms noecn limit 1000000 (same for fq_codel)
  - unpatched kernel: tc accepts it; a UDP flood under the 1kbit tbf
    soft-lockups (watchdog: BUG: soft lockup) while one
    codel_dequeue() call drops the backlog under the qdisc lock
  - patched kernel: same setup, at most 256 drops per dequeue call,
    no soft lockup

Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Reported-by: Vega <vega@nebusec.ai>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/codel.h      |  5 +++++
 include/net/codel_impl.h | 16 +++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/net/codel.h b/include/net/codel.h
index aa80f744826c..183d43c2bd43 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -140,6 +140,11 @@ struct codel_vars {
 /* needed shift to get a Q0.32 number from rec_inv_sqrt */
 #define REC_INV_SQRT_SHIFT (32 - REC_INV_SQRT_BITS)
 
+/* Cap on drops per codel_dequeue() call: the loop's work depends on the
+ * idle gap and backlog, both outside our control; resync when exceeded.
+ */
+#define CODEL_MAX_DROPS_PER_DEQUEUE 256
+
 /**
  * struct codel_stats - contains codel shared variables and stats
  * @maxpacket:	largest packet we've seen so far
diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
index 2c1f0ec309e9..9e779cd4d6de 100644
--- a/include/net/codel_impl.h
+++ b/include/net/codel_impl.h
@@ -93,12 +93,17 @@ static void codel_Newton_step(struct codel_vars *vars)
  * CoDel control_law is t + interval/sqrt(count)
  * We maintain in rec_inv_sqrt the reciprocal value of sqrt(count) to avoid
  * both sqrt() and divide operation.
+ *
+ * Clamp the increment to at least 1 tick: a very small interval (or a
+ * large count) can truncate it to zero, stalling the dropping loop.
  */
 static codel_time_t codel_control_law(codel_time_t t,
 				      codel_time_t interval,
 				      u32 rec_inv_sqrt)
 {
-	return t + reciprocal_scale(interval, rec_inv_sqrt << REC_INV_SQRT_SHIFT);
+	return t + max_t(u32, 1,
+			 reciprocal_scale(interval,
+					  rec_inv_sqrt << REC_INV_SQRT_SHIFT));
 }
 
 static bool codel_should_drop(const struct sk_buff *skb,
@@ -156,6 +161,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
 	struct sk_buff *skb = dequeue_func(vars, ctx);
 	codel_time_t now;
 	bool drop;
+	unsigned int drops = 0;
 
 	if (!skb) {
 		vars->first_above_time = 0;
@@ -180,6 +186,14 @@ static struct sk_buff *codel_dequeue(void *ctx,
 			 */
 			while (vars->dropping &&
 			       codel_time_after_eq(now, vars->drop_next)) {
+				if (++drops > CODEL_MAX_DROPS_PER_DEQUEUE) {
+					/* fell far behind the schedule */
+					WRITE_ONCE(vars->drop_next,
+						   codel_control_law(now,
+								     params->interval,
+								     vars->rec_inv_sqrt));
+					break;
+				}
 				/* dont care of possible wrap
 				 * since there is no more divide.
 				 */
-- 
2.43.0

