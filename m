Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F046A3DAACF
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 05:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787550380; cv=none; b=FGzHCWTLXDjIXce7QXpOhveM7haPm5Rwb6z2JphmZXoqaFX/Zwt8HR8iBSDo8nHqs1YlMqGmd2y+XLSwGatSmr5oR5KaiCTf/VuIoHFG2i8xlfs063JypHbohnCjztFeucgn5vyGbbrXjaLuqO//5+Q7myem4l2HX+x1v+WRXN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787550380; c=relaxed/simple;
	bh=PPxHDSSjFsIuKTTGP3s9QbTSwWRI3+JJ4iEvZKumLNE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FDG8VHO49YL9/Qcr5msqQKqBoR8jVqq7IMrh6HAvNCQR989I76GRHA9SGNR8FlW9oC/LSvNZO2zvQtqssx7KL5R88VadYqrkjqaVQlZMOQZmFDgVA5F5CaUx1+52I/O0V/ifynJewrkeAyDuCHFy6ehcc9cYwTVlzFHBuGZCe/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QZPyhh2X; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZPyhh2X"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cbedf318752so2240543a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 22:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787550378; x=1788155178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=myhkxek0ujsBOo8JzoYg9RGNzSWyQhfisbzFakrTPYc=;
        b=QZPyhh2XoZ8Kt42RCS9lULz7H4KPlZCNi4mYzNlzDItOf+Np/IZh0Wq0xxc5UJ/SAu
         uWCJQwS4gFBkF2j8Rdlt2a+bJSz+Fk/WPUiNAz+/nJ/hVIS4GevwoU+CWc7NiNJo5c8C
         Y/YIlK4RdvOqS0QyC//KbWG8vh0IgyrqqbomMlcqjIeZdU4KG9uqW3pML5gfW2IK0eFc
         pl//KzyZ1Q6nTpplGOnI8NNrpcRMDzDn6CD1Aw5Q+L3CgL73Zk4kjpYfin85kPdoYNke
         paDf03etqWoUizTqJXH+sLq5fxs0TZiLRlbR8bHTwdqP0KyCZRgYghVrdnaBPVK6ww57
         5QiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787550378; x=1788155178;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=myhkxek0ujsBOo8JzoYg9RGNzSWyQhfisbzFakrTPYc=;
        b=psiyz1zibG30xyBNOGCcEx3agM3wmUA1A+8D7Kyr2cYWrktEoqymalYNBLo1civTkq
         y+p9m36zuOIS3dvxsssJVreLMPA42ep/i8Zxn6HOOOj2WX66LQpz7QMLegoIeYz/ulkE
         Vi5bH3dsraXqGTvtqzcYcAKvaR7T61VNxXuLivGBdDddPYCAFiLqhGzOe1FzbwpYtIyZ
         jzKxMQYhxawvKTTAtzlY2lIZLEAFa2LjDOAfZ3SyoUZt/CtlHdNOerN+zhNunus6loOF
         Ys8ddECh9yoHIEaz1ud3ruzMURvgdJG+UHyprlVqoVHB6uBer7JOHQ8cUuFY5l8cHL+5
         rvrA==
X-Gm-Message-State: AFuF++mxMWWpfxm1japfDZ8fPoCHA22OsUVTjynJBFqmIuET5D41JkEM
	zaorl5HrxrfEeWNC54pUrnH8lLocrDMLw+XoiVAlZHm6yjE44BGb9jqO
X-Gm-Gg: AR+sD12x+dll1LCvq+AI2cD15emzCD35isQsE6Av4LStv34ncQ+ycuBh/ds+JNwFgfa
	1xC2YW60d0iKfVtUL28OG26nfKJZL0rPE+VcgXAfFiWNDSVKtG8F+iJXtkgd5wdlJhYo9RYFRsG
	urJP3zmdR4xv2KLu6LxRI3sdOwQ4UO3+BHu5mHRgMbQyt9lCMpAEIeC95BNclyg6MM/GfA8gsM8
	7nwvpiAOl+jeuW3CPdkIW8O/09azzXDTSoXPk5F3p2Zq/W7Nv9MHEDHyDJVfccmQJ16L81BkAYp
	nec4gK4q6K3U65N7ySRmuFLpp60PghV8eqPQAftQvYkJT+gFCKg9MiopBT8Yv/Z8Tx+vD/FFyGf
	frE3S6VUXrrzkIjvQlV0vOAYWUJkIl525VOxp+F/Sf+iMp7oKwA7DvIfHYvB/E4ILS6B1cYbM7L
	hrb/Qqj0npx+TTg7gsqeXkSnyLIGQ4lAFFWiifHYNTvbSMIeZ5gjg/T2xH9ogZ3ASTDTYxZUvFi
	Cc7NaDDtC9avPz10WOEfDB+aEhoclEoqI0=
X-Received: by 2002:a05:6a21:6f11:b0:3cc:eea9:f757 with SMTP id adf61e73a8af0-3cd300f9e07mr45600722637.16.1787550378226;
        Sun, 23 Aug 2026 22:46:18 -0700 (PDT)
Received: from deepanshu.. ([2405:201:682f:383f:4cf4:9e7a:69d:2900])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f90cb8e3sm31647547eec.12.2026.08.23.22.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 22:46:17 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Subject: [PATCH] wifi: mac80211: mesh: free pending CSA settings on interface stop
Date: Mon, 24 Aug 2026 11:16:11 +0530
Message-Id: <20260824054611.29728-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ifmsh->csa is allocated in ieee80211_mesh_csa_beacon() and normally
freed in ieee80211_mesh_finish_csa() once the channel switch
completes. If the mesh interface is stopped while a channel switch
is still in progress, ifmsh->csa is never freed, leaking the
mesh_csa_settings object.

Free it in ieee80211_stop_mesh(), the same way ifmsh->beacon is
already handled there.

Reported-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f5752cd6b94fe38be666
Tested-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 net/mac80211/mesh.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d4507e4e6ec1..d3fb4478a366 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1201,7 +1201,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct beacon_data *bcn;
-
+	struct mesh_csa_settings *csa;
+
 	netif_carrier_off(sdata->dev);
 
 	/* flush STAs and mpaths on this iface */
@@ -1222,6 +1223,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	RCU_INIT_POINTER(ifmsh->beacon, NULL);
 	kfree_rcu(bcn, rcu_head);
 
+	/* free any pending, unfinished channel switch */
+	csa = sdata_dereference(ifmsh->csa, sdata);
+	if (csa) {
+		RCU_INIT_POINTER(ifmsh->csa, NULL);
+		kfree_rcu(csa, rcu_head);
+	}
+
 	/* free all potentially still buffered group-addressed frames */
 	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
 	skb_queue_purge(&ifmsh->ps.bc_buf);
-- 
2.34.1

