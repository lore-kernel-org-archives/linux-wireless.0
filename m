Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069EA3A641E
	for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2026 22:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811558; cv=none; b=o6A6x/v4TVS5i6yLMHnGdyk0WxW8RhXFPYs+Cxe8DBfMwYovA/yu5OsU7DTWZZ0aR0aSfxSh7CeVfKPBQQ1NXTRZ/bEE2vSiY3NnRybTaO4j4ud+BeGrMkMnX5x0U6dulyP+b56cZb88crcHvbaZqQdQXhnZ/mnLQ/XqoEy0BoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811558; c=relaxed/simple;
	bh=B2/Ez1izkInqG37lggXZuxiIY/sMrJx1Ctg3Ihhqogw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FhwfuVB9INkxZCHydAAS+7hhn4b/whOMmM3igcFULQEZtOJAKZrGgmqLpFW0htK+1wXe6O6Y4yoc24udngAgbPYevV444jYUk3Oe/D1hV+fH0V3W1+gDO2AdMBh95ALw9mfkSDhexyPJ9fJYRJvGXLaRpbiQSGy0xiFBKrDaJ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K//XKi2m; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K//XKi2m"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a3970f1a0eso56104636d6.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2026 15:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776811556; x=1777416356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qONHLEV3GkdjuXjKWyFx4xK6vZA47+HY6O2Lx2BENmI=;
        b=K//XKi2mTefdZFmnoYzL2Vrkl5JWDRrHCik7a7RGAQLvexABNM9JC5ftKB3qCJXJFE
         7K8YT+SU14Sk8JrMYpGVh5QvlpvCac93Wo9LWGH2CCtik9fgZPXkXXD2fPGbywADWFaX
         lxMRjI0hW639InuUByy3j7DEVg5sllDnpijvq1Rs29TUjRoPygblmui9L8g/4o7kN7GW
         bEXiH2KeEHsgDN3JSPl1VOg4FClrOKbipoZVxmUPB53KZPFds7/e83D78BxcU2yaFgcq
         SGprqXX1dK3S8dHoMDZS54Kre9KZdi1twFkhulzaWlox49aScrzdvJjHFJx3/FB0SJQz
         Vnjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811556; x=1777416356;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qONHLEV3GkdjuXjKWyFx4xK6vZA47+HY6O2Lx2BENmI=;
        b=JnyZkIYUqe7Nt7rJW3HPxtJ/6T8qiXb8ChOCATviqUch3XSEeZ1orr9+g5ypnymfhy
         lX3B2v1IKRg6fZ8ngRyFeLdJvALJ2Xem5QEgnRZYHAXZP23WlXGNbAeMbUba31on8rxI
         zVI+1NE9zilNZ8IYIUGG5DUEL+8CM9ix3SzO6lBiLXwq0diobfYBPmAynotsYIxn0Hhg
         emR9CumjqbPeYCL7cR4gqcMvD6FnnWFtANbUW6Reud9w6rFFclZUeyzcxapAgMz+GaQi
         e0YdvGY+wLDHnokiSafz/ZTggpGAU8Ecf41w5pWnApKkQHYMJM1+u0RtaIe+6+91D+Zk
         bZeg==
X-Gm-Message-State: AOJu0YzGFJE64X4ymNNmxM29r6SlGPcVV4qIdfr70cn0MilStVyp0Vg6
	a5+o4WmcCj1tiyfJTnbk71tj57a1gt4OJ6nGiqtwIWmpzL+gYc/6hhpOVzfnRw==
X-Gm-Gg: AeBDieuXMLQYjs8DFK/rjcrlNos2r9TX3kYc8tutaxx71vpRdJPqX1iiCdnZN6W3YbO
	vhV9KJb1M1kc9rm5nJ1X5BXikXgpzOenoPhym9fRmpcUaPf5qm4qDcwbREL+7NvuDPrldaB3qX7
	wO+Sm6oYNpjo125J0EGPz1Fne1Wf/Ttj+xKFU08d4ptbYzv+YIk8GgWeyG9DwM2SjXSrDfN2V4q
	vaYgKYzRcu3oDG8yx6zqfq0JSyPxZtmW/SVAO+Ox51pAaDvKtOU9IpQ8E3IFnoWMrqWJfX8LFi6
	NV1BPCUQRDKVVAz5hMP2lpJmQeThWMlAwjMBH17w3ptqR4znkraYQSjHgMGYh5ndnQ92wJQ1OLh
	Qm/AeNLDnW2Zjn4P/S6kpQmBaz+ZY63zSd4FOsg65mPTSLqFvb70i+MDvGrdMoLsphdPV/RDLqG
	XDl30aWc8J35/jKbtHA/8t8+XDxOebseBwkjCtEI2gUcy7ftirgpsxg+wgXxpVejKOlKFZh5zLy
	Jilp5/bceDmWiF2li+onuoKhuF2cfY=
X-Received: by 2002:a05:6214:5295:b0:8a1:478a:e58a with SMTP id 6a1803df08f44-8b0280fc448mr326122326d6.36.1776811555709;
        Tue, 21 Apr 2026 15:45:55 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac42b3bsm111120146d6.5.2026.04.21.15.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:45:55 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Avraham Stern <avraham.stern@intel.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-kernel@vger.kernel.org,
	Michael Bommarito <michael.bommarito@gmail.com>
Subject: [PATCH] wifi: nl80211: require admin perm on SET_PMK / DEL_PMK
Date: Tue, 21 Apr 2026 18:45:52 -0400
Message-ID: <20260421224552.4044147-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NL80211_CMD_SET_PMK and NL80211_CMD_DEL_PMK manage the offloaded
4-way-handshake PMK state used by drivers advertising
NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X.  The only in-tree
driver that wires up both ->set_pmk / ->del_pmk and advertises
the feature today is brcmfmac, so the practical reach of this
patch is narrow.

Both ops were introduced without a .flags gate, so the generic
netlink layer dispatches them to an unprivileged caller instead
of rejecting with -EPERM at the permission check.  Every other
connection-state op in the adjacent block (CONNECT, ASSOCIATE,
AUTHENTICATE, SET_KEY, ...) carries GENL_UNS_ADMIN_PERM; SET_PMK
/ DEL_PMK were introduced without the flag in 2017 and left
unchanged by later refactors.  Johannes checked the original
Intel submission history and confirmed there is no admin check
in any prior revision either, so this seems likely to be a
simple oversight rather than an intentional carve-out.

Require GENL_UNS_ADMIN_PERM so the genl layer performs the same
capable(CAP_NET_ADMIN) check as its siblings.  wpa_supplicant
already needs CAP_NET_ADMIN for every other nl80211 op it issues,
so supplicant operation is unaffected.  The worst case the missing
gate enables today is an unprivileged local process on a
multi-user system invalidating the offloaded PMK state of another
user's 4-way-handshake session, forcing a full EAP re-auth on the
next reconnect.

Verified in UML: an unprivileged probe (uid=1000) sees
SET_MULTICAST_TO_UNICAST (sibling op with GENL_UNS_ADMIN_PERM)
return -EPERM on both pre- and post-fix kernels, while SET_PMK /
DEL_PMK return -ENODEV from nl80211_pre_doit()'s wdev lookup pre-
fix (proving dispatch crossed the genl permission check) and
-EPERM post-fix (rejected at the genl layer as intended).

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Fixes: 3a00df5707b6 ("cfg80211: support 4-way handshake offloading for 802.1X")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b94231c8441c..1f5124cb284d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19016,6 +19016,7 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.cmd = NL80211_CMD_SET_PMK,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_pmk,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_CLEAR_SKB),
 	},
@@ -19023,6 +19024,7 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.cmd = NL80211_CMD_DEL_PMK,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_del_pmk,
+		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
 	},
 	{
-- 
2.53.0

