Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC283F484D
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501323; cv=none; b=EaIw+NPOTWPXEr2qbupxBmYbRUga9IU6WRWJCJ5KwDxIfAEBoAChKB5l6O9QhUyBN8lbl9afVIdMXEfRD1mXD8KnADg5+dJezuYA1Vva2bEEBcqDdllZRwFxQH6nlNWjLE/+tgtk4mC8sxJdMioG28sjjmb20I6a+W1b99pLR8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501323; c=relaxed/simple;
	bh=t0GOcSpOKK5PF2d3HnSWfOsE+JhsDURH7dwAoBjRGo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+O52fMgBc1avIrbTL8Y93C9Ajunmd4Eu1m4xO3+QP4IqzGUbPq3GLddvaVgsg/XcCxv9A/+WVn52IWAP+YW9XNeR3M+jU0NJjivmcxYFC5LvfWpxHbTNNRTAKAhlPe50QUSxLAKr7modHzV5K++6nB2Uaps9esYyJxLW1dpYKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dQGAVXmV; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dQGAVXmV"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-38deea72eebso952869a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501322; x=1786106122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RRTJwYjyE04tEhTSWhtviVKYhZVKRSNRAJNKm0CZOVA=;
        b=gc1WyYUqFoUbXO4Q/g6N6B2uKZBsJmq9eLsSkw7s2o/wt+Jptj2sEk8XP4BzraLX9O
         cdopEKQ0+8C5hgsWd0rxQgF1Hkdzp9cu2zEX1TtA+Rm5ljHIUq0c5Qi3r0iwACbNoJlz
         Zct3BluXSr4Hs6cVEoDx7oY7KdGLuiNBTrrVCB8ERaM9s5yXVx6Pq7Ssrebmod0JmKZb
         AsLtNl0OG/b4ogUHbs0tTY4IjXcOeS1sxNfyJcbn6fMDWJPufFdXy+kd5q5bj3fofnIF
         1NFAdXZSD/HsoD2TK6cR/rkEXxnpUPastuNRcsAaEIYHFrpWZX0oegI05DzQyzrQWstj
         fiow==
X-Gm-Message-State: AOJu0YwmCi9kz94vjV6BMegM+f9C5u03FI2rBcLVwUOtmDPWu31U7t4a
	Z39fw/bfIdc9clNxqqGsXpaZkQdNENWanjHt3IHeF02Wy31zjKndQSdeKFEPR8mBj4AVdX1+avo
	Z+K1vxqYHwIe+42ILnA3yZewTx0NKLL9hmhFVxe84qLVc6LArC4BdPZgXZsPLtNN0fRuKDBu9+I
	WP4QfteoGKQGgNM0KqgrdTYxFpcwgTY2RuJ1+Zvu9KMGFD5OJOwKMCzg4j5y+HxaSVtI6dGCsAX
	Xx3yzHRWf85A5EmMbuTO1uC+A==
X-Gm-Gg: AR+sD10d8LAIgN0l0bse3Hr943X1OhiIJnGiyRs5tarH9yXUWP/PUznhoWNC3umpmkI
	1xqVyHANfEUTsPy1q/dcb9miUQQShfhPqdSmlpOx5NsirV1MFEgOtVEqImcEKI6aWb9wrMn+TAj
	w/WBDGVb07GRoUlRKEPhQI10+IAcL3MG0qZuTIqAZmIWPgJPo5Z5zvgUj3maTiuZsvaozZNX2Bs
	2dD1EXsL6Te5QyNFwLowSx0Ad8q8F6In6/oFMziGbzMUNOqMORMr8lzzlLItX67vW04A3LFJSzG
	hlXzLZsJM+oVMGG5KA7/vArN77Cs2c8auhx52/XddCQWsW7KkBfBf3ve2GpqfBshUH0OCTurUbA
	YT1tuHO271tC9riZM2txUr0Gwm3P6WfM3Pl10eY455QpJlKQyCEHkFkUFUpYkCLKdLH0f/Teq+8
	MRJ13kMhboDVaCh1Fxc0dPUPxmnp+DvWUDBhKoi28=
X-Received: by 2002:a17:90b:1c81:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-38fb114f74bmr1686262a91.9.1785501321603;
        Fri, 31 Jul 2026 05:35:21 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-3153e07dbf5sm83170eec.16.2026.07.31.05.35.20
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:21 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso1876105a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501319; x=1786106119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRTJwYjyE04tEhTSWhtviVKYhZVKRSNRAJNKm0CZOVA=;
        b=dQGAVXmVpHVuIot8fdctUVI2f9R0HdP/kI00Dnr4Lg+sk7UNkBYRbuBzwKRIolWxnt
         QXLRgxfpzsRXghR4ixFsvfKh/HmJkweMn8cudHvFNdKKA1RqK2LmxkwVT0d/3sWI3d7Y
         u5bgQxCMvpZZ0eX+bWE8ZYkKWxavTMPFgf2Rk=
X-Received: by 2002:a17:90b:5148:b0:38e:bfe:81e9 with SMTP id 98e67ed59e1d1-38fb114f7cbmr1743387a91.1.1785501319185;
        Fri, 31 Jul 2026 05:35:19 -0700 (PDT)
X-Received: by 2002:a17:90b:5148:b0:38e:bfe:81e9 with SMTP id 98e67ed59e1d1-38fb114f7cbmr1743365a91.1.1785501318697;
        Fri, 31 Jul 2026 05:35:18 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:18 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 01/13] wifi: cfg80211: pre-assign cookie for driver callbacks
Date: Fri, 31 Jul 2026 14:34:57 +0200
Message-ID: <20260731123509.1975281-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Having a single place for cookie assignment and keeping that
responsibility in the cfg80211 subsystem is a logical choice as it
handles the userspace nl80211 API. add_nan_func already does this:
cfg80211 calls cfg80211_assign_cookie() before invoking the driver.
Apply the same pattern to remain_on_channel, mgmt_tx, probe_peer and
tx_control_port by pre-assigning the cookie in the nl80211 command
handlers before the rdev_* call. For tx_control_port the cookie is
only pre-assigned when the caller requests an ack (cookie pointer
non-NULL).

Drivers may still overwrite the value for now; subsequent patches will
remove per-driver cookie generation.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h | 6 ++++--
 net/wireless/nl80211.c | 5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dcbb0e55c32e..ee395e3a021a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5108,7 +5108,8 @@ struct mgmt_frame_regs {
  * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
  *
  * @probe_peer: probe a connected peer (AP: STA MAC required; STA: no MAC),
- *	must return a cookie that is later passed to cfg80211_probe_status().
+ *	must use the @cookie as provided which is later passed to
+ *	cfg80211_probe_status().
  *
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
@@ -5219,7 +5220,8 @@ struct mgmt_frame_regs {
  *     user space
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
- *	tells the driver that the frame should not be encrypted.
+ *	tells the driver that the frame should not be encrypted. When @cookie
+ *	is non-NULL it is pre-assigned by cfg80211; drivers must not modify it.
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8adbef5f0442..6ad1f9cf2dda 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14642,6 +14642,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		goto free_msg;
 	}
 
+	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_remain_on_channel(rdev, wdev, chandef.chan,
 				     duration, &cookie, rx_addr);
 
@@ -14883,6 +14884,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	params.chan = chandef.chan;
+	cookie = cfg80211_assign_cookie(rdev);
 	err = cfg80211_mlme_mgmt_tx(rdev, wdev, &params, &cookie);
 	if (err)
 		goto free_msg;
@@ -16371,6 +16373,7 @@ static int nl80211_probe_peer(struct sk_buff *skb, struct genl_info *info)
 		goto free_msg;
 	}
 
+	cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_probe_peer(rdev, dev, addr, &cookie);
 	if (err)
 		goto free_msg;
@@ -18586,6 +18589,8 @@ static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
 
 	link_id = nl80211_link_id_or_invalid(info->attrs);
 
+	if (!dont_wait_for_ack)
+		cookie = cfg80211_assign_cookie(rdev);
 	err = rdev_tx_control_port(rdev, dev, buf, len,
 				   dest, cpu_to_be16(proto), noencrypt, link_id,
 				   dont_wait_for_ack ? NULL : &cookie);
-- 
2.54.0

