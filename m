Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4749F3B0AE9
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236521; cv=none; b=HhwqmwRqOr2IXFT/OvhEf+YwlYXCPD+6q2xy3apMa6kzC4+46VZ0C8FqN79b1CnYBmhOVYqcmFgjo9tXLHSULJxIA4Z7m3wUeJcdyzQ2NFiPR8p8XIUXsEF5n/qyGv8pofmmOB6hWx8ZJbZ3F6mi8tpJ6lTpxdc8brnI2gImzxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236521; c=relaxed/simple;
	bh=YCGNqCzZatBNp9mkN8kezIg2lUy/SNtT8kMkmWxd92Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fVpgdQIY93Eu9B2jAGTpK3H/LDwZx/iR5jc1C0wgnzBq+9Nq3sMuy957IzwE536CtKqejGxHo8BGBs7CzRUdXY7ORR57SwXj+2TlEU38ev7sd3E2YwDuGK+AxS+RWzS34LKezFln+P5jE3HDn9VLVRZuc8J+8pRM8dF2ikLHJqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=mH3CYn0P; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="mH3CYn0P"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb76ef19aso10949241cf.2
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 11:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1789236517; x=1789841317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ShtnYNWVoQX+/xNdTOnJtzhcZz7uw5CPa5C82dT5fA4=;
        b=mH3CYn0P5T/B1Bn68/AD7A9iuWGnFuEXirg0qUbm43pDULGacPtYIqnqLcgFl/NJa9
         CqhbRciQGsfMnqYVfEiKjW4lgQl0n776kNiJ4dx4BLhNmwO5iwFFvOf617ylBzXAaojA
         MXCpIGwQk3EiHdM6Kv8mC0DQmXwlWqyLm6R9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789236517; x=1789841317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ShtnYNWVoQX+/xNdTOnJtzhcZz7uw5CPa5C82dT5fA4=;
        b=qfEIHkYthuBDqfzJKsRQtcQ85SdOG0oxHL0EsBT+8AJ6qtTqxYylbZt9D1bHfKRY6f
         KVIZlsXm7KZQ7faZqG+d0h01UQ+kNrkXiYLdUkIZgWgXo3V55AvlZsoVWNVefJYchNqj
         s46/thMcnDYarw4zoq7P4xpkM4GarjfR2roLtVQXddnjJ6D4cQn5kT9SisXEBKjOW9S/
         ODXLBcCiRRbV7MsSqGroZVILcgvBW+6+oRvg1R23PVH9ghFWe2gBGue/BFev1Zx+JRPl
         UUv2D+5GWf2H9ga5eP540A7lv1kW6sD8B8FdN110RqAzdBy50gN7GyycI0b7p4GiRi+y
         pLSQ==
X-Forwarded-Encrypted: i=1; AKwUvBybdaqlmMIvk0D/6J0HbYU40bbj2LnVu9S0ftk2Zm3hoS7fqEF9m2841VhX1JIXWksgxSs2UeWJs+FHl8+mGg==@vger.kernel.org
X-Gm-Message-State: AFuF++ljnKL+z7Jf6WFQUodJau1k4NEaxC2bENR/FBIcfwRYm/AMU/lN
	Ejt+g/BuVtLFe0LJeV1xupAtsAHn7JsO/q1s/ctA3GQ4fu4NcLu2tQpwx/qNT4DlJQ==
X-Gm-Gg: AYBFou37CZBDLI3epZNwnND2axzNyvrTqWIb9oTjEGJll2EwM5igWJ2SVXVx4qCbD4F
	VZyHHj41ROdFC4Jj3663bbStK5tK3HjY52q89/JLNf2rkl3yCjh8Atxu/VnHVr/L0B8hO4LWbR4
	OXLcrbLg7Vwu4OBMVkkAxEZGew/DtHMhGfN3GcG05Cxull2WXgj8AYgoYPFMKsExyyCeVxaEdJ3
	YiIDuJlHGywMH9leX1a/kdi7KhiB5DyDH6/SDVSoyjptuHD5L9EwCHSaZg7cvgFAuD5UcasVSky
	X6+cGzzohfZIgZd1eT3maLzg8JSPa1ujy8m8ZpVQ5Ivopxu5g7y7Xhgc5MOv7pWkP6J5eDKjekt
	4PkuZoXkA7QSqMsCUQuZ9IIVUVCOS81tkkeHTL1L7q0/hm1CglTBU0HZPSwbm9xy1UlurmePTP6
	IEPeXDN5scshuaje8/N8ZuX5sNk+fEV04GsnO7xQw/BsVS602uk2/4zO5VhBMg6k0jA7g+z2+b2
	6rxV7L3PSGD6WrEk+PNSPyVh5oeXnD5T5Vz5ty4rQ9B6YG31EFsIfrqXEbMKMCdEVsJaLAEAVdf
	U9JM4lCJDebS4769NYrkqUU=
X-Received: by 2002:a05:622a:507:b0:527:631:8d6 with SMTP id d75a77b69052e-530c859b38fmr137612511cf.25.1789236516942;
        Sat, 12 Sep 2026 11:08:36 -0700 (PDT)
Received: from majuu.waya (pool-174-112-106-84.cpe.net.cable.rogers.com. [174.112.106.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120ef650a6sm52190296d6.0.2026.09.12.11.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 11:08:36 -0700 (PDT)
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
Subject: [PATCH net repost 1/2] net/sched: codel: bound the dropping loop per dequeue call
Date: Sat, 12 Sep 2026 14:08:30 -0400
Message-Id: <QDISC-1L5H.v1.20260912080102@mojatatu.com>
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

Conditions to recreate the bug:
  - tc qdisc add dev lo root handle 1: tbf rate 1kbit burst 2kb limit 1000000
  - tc qdisc add dev lo parent 1:1 handle 10: codel interval 2us target 1ms noecn limit 1000000 (same for fq_codel)
  - unpatched kernel: tc accepts it; a UDP flood under the 1kbit tbf
    soft-lockups (watchdog: BUG: soft lockup) while one
    codel_dequeue() call drops the backlog under the qdisc lock
  - patched kernel: same setup, at most 256 drops per dequeue call,
    no soft lockup

Testing: claim reproducer and interval 2us/3us variants run clean;
tdc qdisc category passes (see the selftests patch).

Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
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
index 2c1f0ec309e9..8f26132d45b7 100644
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
@@ -154,6 +159,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
 				     codel_skb_dequeue_t dequeue_func)
 {
 	struct sk_buff *skb = dequeue_func(vars, ctx);
+	unsigned int drops = 0;
 	codel_time_t now;
 	bool drop;
 
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

