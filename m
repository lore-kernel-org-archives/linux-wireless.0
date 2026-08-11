Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E29847A867
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 21:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786482762; cv=none; b=LRxodeYzrrpBFaqOMFTLk/z1/Sw0ejqSSoPdjQmexcW2pRq1+/hkFR9+2lpVuAYZsZkQYSlN4w6oRm6WcsjSZpzoR2BOYQ7WZ4Fq/B3k0FDcIU+4oXXTSFkVs/zLsMfJAfF1cRDM5+P3n5SobLWHNj0yLTMRhCuwY1cEDSj8ezs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786482762; c=relaxed/simple;
	bh=5X0Fq06kgVt3Zfxy9oWgweoQ7Qb3HoyJt8LOKfYjkkk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PuOUm3FwQ8ibjh/gNVrHouywU0thj0RS7te44jxMED6JPeSzJl5ERI0P/TCxhxybvoeeVknsJK7LA5PT7XoZo02zzQ8TWWAD2s2hZrh8W5DqU1YgqWp89cwtebXIwvGMMSZXioxGJvcb1ZQPSTDuWsGeYRjoL+DaOgZVBW/kv3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRQDZYk0; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRQDZYk0"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8486ac3f347so1464379b3a.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 14:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786482761; x=1787087561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bfCgYj603awFHVan+OL9MOSp/Yr+4rdiabbgO1A0ubw=;
        b=BRQDZYk0yOLTr3GeHwcBU52Xarb6aGKrxcc4Z3h5XG/jhqKC5r4i4gyGBcBqPTanBm
         efeqmIeY2aylR/fdcbNE+qTKoO8SFjQkbMdENvZYDhbWALK7RlxCJOF7VgWWnGHCB9Dt
         hUWxyol/16xrWKvsr3iR37LwHaI1Q4Fb6FVnT2+IoDRHuoia25kjMQtoEsE1VhLPziAQ
         fB6D3KuRbRExXkxNK7XktKxYHoPIUvLl7z60ynHZWf22iB7ZI+cbgD7PIYKFReN2FDzG
         06CGzYmsCsU8ooMqSiQYLM7N7zCPwiw6kbuwAMNKr3yMD61S38hSnwjvEAAfJXBMV77v
         M2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786482761; x=1787087561;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bfCgYj603awFHVan+OL9MOSp/Yr+4rdiabbgO1A0ubw=;
        b=izAjNKqzkFuNNmtn7+f4zDxKIAm3XyP75w0G1PDi1NUBw54ObFacZUgc7JiXM4dPOF
         QeSTsucjeQr+iQglFu9BbZMLfF7/j1psY2+FoTcwDJ+geBfPPKiEkSgmrcEDkyXw1hAj
         X91Pujiyr9jG/CuNdZNMm+CuPpjn9cBAl5zHEZmCjS1tO90/ogtJyQ5pvBktYK902UWh
         5o9osr/3ioIQ16MgUJm1o13TZkg0V0Dn3KIOY/EOHDese9UmUJh6zaAUrKvBz7VtFeeY
         +ffro2nPNIOy0efj/yGukjwCmcnvxceedryKlu3bWyN8FpKG9qXDL87UPPqIlGxQx/Lg
         HIXQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq1OIN7TDQaQj6D0ZqLX1+ZdjsyuxyBj0vhDNaMXykSv8rJpee7fDWRPrZxL//ay+vNpe/eb8/t7Q5Ab2dOVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7uUNeK+U054FGAee8avoDC1aN0PFEABN89h+0kZgHIbzHFcCC
	PopCWs6qlQOShCGu8oM6yPTmaqOeRkC64fQOPai1Ipj65k6jg1CVJ5H1
X-Gm-Gg: AR+sD12Gu9WT80mnI8/8MtreM2Dekr/VaQL6/maj6iJxYylLMWONfHxdhjRNPUC2n16
	01sVaIFtIN/XIaaZJlsVr6O49sukacLFYxJLB08vZY8QylVuRj+3M4Q/1phzNjiFgvvqrholyeG
	YAy5m7me3wo93bLXTju40W2AZ+W+faHrrabFYxYMvfuaN7CAYMAZqgFYppMzgGfuTtvr+Ino5NU
	GcS+W5/c4JMpyrBi+1I1NsBAC1oY6rOi4Q9O9vddtODLx1G6Le6gcJ7hKEeRb95mK3UeYzhIhMV
	ei85wiaPJS/CrteD1esT9OLNVHxv8TfFY8iCWruaQw8eMThx7DhA6EfUDCLH0PVAhoA7jIQNQza
	QjtFR4q124nZcNWOVhzhvIOTXymCYbKxJt36X4qZhiw8dZk/MR8GGBqNijiQwnLgGii5pi5v0J4
	vgwxQbqE7JT5jtTyNnnq+RrdC0OiaoWkSwt2sP6LDNB4Uql9mVPbSzt3gRsoCiq6CEOPGgohgQk
	mv6gVUk/xn0GD8pCiNpTHcRR0N9yW8ZZn3p5GOwXVSiVTaWh7trjAFFav/DvrOuktw4VnCY7yMu
	Hm44
X-Received: by 2002:a05:6a20:72a8:b0:3bf:8a0e:dd99 with SMTP id adf61e73a8af0-3cc37a386d2mr2886514637.17.1786482760462;
        Tue, 11 Aug 2026 14:12:40 -0700 (PDT)
Received: from nixos ([2405:201:c40d:9039:4f8b:4d:f8c2:8f50])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf3624c6dsm4004869eec.4.2026.08.11.14.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:12:39 -0700 (PDT)
From: Ayushman Rout <ayushmanrout27@gmail.com>
To: johannes@sipsolutions.net
Cc: nbd@nbd.name,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ayushman Rout <ayushmanrout27@gmail.com>,
	syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com
Subject: [PATCH] wifi: mac80211: guard drv_net_setup_tc() against unbound AP_VLAN sdata
Date: Wed, 12 Aug 2026 02:39:26 +0530
Message-ID: <20260811210926.11422-1-ayushmanrout27@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reports a NULL/invalid pointer dereference in
trace_event_raw_event_drv_net_setup_tc(), reached via
ieee80211_netdev_setup_tc() -> drv_net_setup_tc().

drv_net_setup_tc() calls get_bss_sdata(sdata) unconditionally. For an
NL80211_IFTYPE_AP_VLAN interface this does
container_of(sdata->bss, ...), but sdata->bss is only linked
opportunistically at interface-add time when a matching same-address
AP interface exists - it is not enforced, so an AP_VLAN interface can
be fully created and registered with sdata->bss left NULL.
container_of() on NULL yields a small invalid pointer rather than
NULL, which the trace_drv_net_setup_tc tracepoint then dereferences
to read the interface name.

Guard against an unbound AP_VLAN sdata before calling
get_bss_sdata(), matching the WARN_ON_ONCE(!bss) precondition already
used for this same relationship in sta_info.c. Also add
check_sdata_in_driver(), used by the neighboring
drv_net_fill_forward_path() but missing here.

The underlying gap in ieee80211_if_add() - AP_VLAN creation not
requiring a bound bss - is not fixed here; other get_bss_sdata()
callers may share the exposure.

Fixes: 61587f1556fe ("wifi: mac80211: add support for letting drivers register tc offload support")
Reported-by: syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f1ba58d6b55abd13239e
Signed-off-by: Ayushman Rout <ayushmanrout27@gmail.com>
---
 net/mac80211/driver-ops.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f1c0b87fddd5..ecfdb51152f4 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1702,7 +1702,23 @@ static inline int drv_net_setup_tc(struct ieee80211_local *local,
 
 	might_sleep();
 
+	/*
+	 * An AP_VLAN interface created without a matching, same-address
+	 * AP interface present never gets sdata->bss populated (see the
+	 * interface-add validation in iface.c, which links bss only
+	 * opportunistically and does not require it). Such an sdata is
+	 * not safe to pass through get_bss_sdata(): container_of() on a
+	 * NULL sdata->bss yields a small invalid pointer, which the
+	 * tracepoint below then dereferences to read the interface name,
+	 * causing a crash.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->bss)
+		return -EIO;
+
 	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
 	trace_drv_net_setup_tc(local, sdata, type);
 	if (local->ops->net_setup_tc)
 		ret = local->ops->net_setup_tc(&local->hw, &sdata->vif, dev,
-- 
2.54.0

