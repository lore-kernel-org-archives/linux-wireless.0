Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B791D3F12F0
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303480; cv=none; b=MWl8FQ5wj7Ni8P+gsYg5kek89l8yzM+130ixQS5T36KfiUxMZmLTGkwHvnYA9+adFJ5uEhw+MCn1NKqVD20QBqLqGBN1F34HiIhPyiMuQyFDu09Rv2g6D8EOvlbcQ3Z858f20fCcU64MRrNyaGHimqeI5u810mUgiohv7WX/ovk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303480; c=relaxed/simple;
	bh=B1Mdpk03iIpWeMkqOfV1qprInLhjCazDZYQpMs3zUx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RTEbsVqNX/sNnKrcq3JTXAoSY76UKMcwh84/IBE8+B1/VsMmKhUhU6XyolawK7qhwxefAamAAzuijrU6o+cKeSSIkFjEWy9/apKVWbVJ1GvOnXGWqVZDGDacxnqzj/JdK8oXwtzfTBu4M4SA0dgx9nNGTKNWgR/PTbwlXwDxM+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UptOmR/L; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UptOmR/L"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a061a13884so8367885e9.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 09:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791303477; x=1791908277; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rj+ANBVjGQUDryG59riqH/2PuEnYDgs9HpOk5Pb5AgQ=;
        b=UptOmR/Ljm5GHsdlffR+mAJFcjMDJn1UPlZf7I1qGo1jIPTaR5ybO7SoJ3PU4DrcIP
         Zy2ksJ0OfXgvWgE+C9GlZre4Aehyr1j8WOqMuntb1lPCtXxsb8XO+kVty9BsdqGpxhrA
         B+dqyhyeHx68h9tvWwqurwEYoRT4C/0ZVYIuj9+FGPg4qhi93jfwttvdfqntEsNUDvs0
         BpbYgKByYmastLGeLAep3zrq55KDeO8xbiGZX3HLGZcxEengHRYM7vK9RnDJIknY3BZB
         qv8+zE770M3aJuHUmn3lURwi8wES5AkRzlpI9lmdpUwWh0X3AucglsDQaP2EN+4uuuIN
         3swA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791303477; x=1791908277;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rj+ANBVjGQUDryG59riqH/2PuEnYDgs9HpOk5Pb5AgQ=;
        b=Nq+ZfVUXYlJk9mmzWSzRtKg4erhUVm1p4Srb40WmihFWZEmclds8u3Soulfm6MRK0b
         /JRE0+WMVIXIkAsJ2lTTjwUSXd1xryQxN+aSv6ML652v1IYA2cjrRATGrJ9kgBcwR7ab
         zqn0lEtfiDMZxK5B0n29xQglQJQaq5gmr52QjIxe18VeWvwRaEdM82GhqODHF4ZsCKPg
         NJ1Z02/UM3tdsFK8krVVNnNGsAQgIz6VfeyJGwVReLNg9IUMMWUijH9kjiRimpypIStC
         IF5eqFrm/4ewb90TtB8Gn5iCSLH9tgL9xCKq/8vFat1o2cvTVRMWfDpY4w8Cf5xWG+aP
         yLPA==
X-Forwarded-Encrypted: i=1; AKwUvBxMP8sTvd3au1g2Kt12CPH5/85dTMvp1n2XDw9t1N05uQnsEdUBvnt9CKKoOF5yjRvQ52JFhkOlbRN6wgQWWg==@vger.kernel.org
X-Gm-Message-State: AFuF++nstTl1hCU+OuQMo88K+s3n+uYndSKr9XooXmAwi6Qol2M34Wlw
	PU4Yf+otgFhs2YZKp2qFlSj3LBCpIbMOO2DU2fU3lHxQePQkwdPurtLm
X-Gm-Gg: AYBFou2LsAZ9F0t62OtKZTexp3qGMXSwzIGFUoPaFKLifbZK/Mg9npavY9bVYp+8mJa
	2eSTTzwSqC7i5lwA2hSmlLHSwEVNyqA0oVSuA+dtWH7ddQLhhJKpCeCrxYPT510hmykklewa1K+
	dNM4Fz0NQCZ8TTlB5vyABKlbE5088hwOBLL2se/Qq8eL8lFQ5hH/61ODHA9lfsPANvwV0baJcyy
	jzzegg2w45VC7AAjfPIBj7xiiyAJaaBaLTqo9216l0Q4FfQ6YbCVdzMHpe/jDk9aEmOlioikzmW
	IpAYbfcd6od/eyPSoMeKaARMcbj7Z1SKOWI7YawDBRotlmD5ntRA6VbGeEpiuZjZ+L9WugZFZ/N
	u0XqzbwgksfJjEW5Fx+I9FzoYWRMYB8DZIx47qVd0zhIkiphQX4cvaFSc7Tkq+qrZ1gvhqaoh/0
	PpR8HHXyZhYCwMpjT1xiZWA3DRD11flbiD3EbPvJgGIZ1zTjIkV4NKGltIX7aeIV0+d/QHFaNs8
	vYkuY0Xg5mupedIwdxcGQ==
X-Received: by 2002:a05:600c:8b09:b0:4a0:1b14:e283 with SMTP id 5b1f17b1804b1-4a17b4f4276mr32986425e9.1.1791303476638;
        Tue, 06 Oct 2026 09:17:56 -0700 (PDT)
Received: from FranzSP11.tail2d6612.ts.net ([31.31.60.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a03ff20831sm275692765e9.4.2026.10.06.09.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 09:17:54 -0700 (PDT)
From: =?UTF-8?q?Fran=C3=A7ois=20Roux?= <franzelfranzel@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: nl80211: don't WARN on a missing self-managed regdom
Date: Tue,  6 Oct 2026 18:17:44 +0200
Message-ID: <20261006161744.3804-1-franzelfranzel@gmail.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

nl80211_get_reg_do() has a WARN_ON() for a self-managed wiphy without a
private regdomain. Userspace can trigger it with a plain
NL80211_CMD_GET_REG request.

Drivers can register such a wiphy first and set its regdomain later.
ath12k, for example, calls ieee80211_register_hw() and only then applies
the regdomain with ath12k_regd_update(). iwd queries the regdomain of a
new wiphy as soon as it shows up, so it can hit that window at boot:

  WARNING: net/wireless/nl80211.c:10828 at nl80211_get_reg_do+0x1d0/0x1fc [cfg80211], CPU#5: iwd/721
  Call trace:
   nl80211_get_reg_do+0x1d0/0x1fc [cfg80211] (P)
   genl_family_rcv_msg_doit+0xd0/0x138
   genl_rcv_msg+0x58/0xd4
   netlink_rcv_skb+0x5c/0x140
   genl_rcv+0x34/0x4c
   netlink_unicast+0x31c/0x39c
   netlink_sendmsg+0x188/0x400

The same trace has been reported with an Intel BE200 (iwlwifi). The dump
variant, nl80211_get_reg_dump(), already skips a wiphy without a
regdomain without warning.

Keep returning -EINVAL, but drop the WARN_ON(). The same change was
posted in 2021 but was never applied.

Seen on a Microsoft Surface Pro 11 (WCN7850, ath12k) in 3 of 4 boots
with next-20260929.

Fixes: 1bdd716cbcca ("cfg80211: return private regdom for self-managed devices")
Reported-by: Diederik de Haas <diederik@cknow-tech.com>
Closes: https://lore.kernel.org/all/DL5P72WYQVOQ.23G9D01OY3BAA@cknow-tech.com/
Link: https://lore.kernel.org/all/iwlwifi.20210409123755.ba2ea961f4ae.I8fde32d3196e860efa3b4ec464c42194195b42ec@changeid/
Assisted-by: LLM
Signed-off-by: François Roux <franzelfranzel@gmail.com>
---
 net/wireless/nl80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a18240455..2589491af 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10824,8 +10824,12 @@ static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
 
 		regdom = get_wiphy_regdom(wiphy);
 
-		/* a self-managed-reg device must have a private regdom */
-		if (WARN_ON(!regdom && self_managed)) {
+		/*
+		 * A self-managed-reg device gets its private regdom from the
+		 * driver, which may happen only after the wiphy is registered.
+		 * Userspace can ask before that, so don't WARN.
+		 */
+		if (!regdom && self_managed) {
 			err = -EINVAL;
 			goto nla_put_failure_rcu;
 		}

base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
-- 
2.56.0

