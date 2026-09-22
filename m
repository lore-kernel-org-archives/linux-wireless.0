Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097FC560AC4
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091579; cv=none; b=lYBX4ebbpDWqtX5k6q+CC4EDLnOVNbakiedeaO1hdtiqFE9dd1MCAmm43LNSmO+bspSMAaFTGD6e6UhCFA3XnLO1qdcf30GkGJWs5XSJsLejBFnObDvC28WnAGD0PmtHdLtuMasxUB8RVXJ2mtlSilDNYUUDDK5lDHBtto4VPqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091579; c=relaxed/simple;
	bh=q87e8qGLpc+a2y1nm6cdAbH69LEmxbYHN84AQSP+ECk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seB36Ns8WS1Li7g60Db83TP98mqMU5Se/KYnwIaaMSBpghQsE0TAQ1WdaozFm1CHLBIoVG1QIV4zUmdH5yoBDH8JLm9fG9TMFnMjo3v9t0VMUMzWZ7EZt6WrpPAni3biQSORzZLFknqI70jBcjdGLUrSj3q9YRFOrQ+nvvy91f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=iimSPo7t; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="iimSPo7t"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b31b4281eso24116a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 08:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790091577; x=1790696377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UWb0eq/OhedEnoNdfqrKl/bTm+EJJ489/BBNtEi1NUw=;
        b=iimSPo7tJVZ7Z9jfJY87KhHkxelI2oS6aUreB0KkDGEJem3AN0BZ4z7Ta6nhewhqu1
         pmIqmq8R7mMb6wm7ZZEBpvctvbN9QY4Gcb1H2IJCvtM7UFM/b03k3j10zjvlp7btmw5P
         JjCHT29NOkXme20p7pihdvpci5hB3d+L/OigVyO3XGup3p4iTNkQtbDJdehvoE1L8YmY
         rfDzdP41bEIqebIkx+MWy75jNaUWcjNTG1HiwFMbxYJqzXVzOJaBCxNL2un1J+yoxCJ7
         0xnKoZ2VebDGLBVFz4BccQGP6Yu0Bs5Am0SQ3G4yBYnG85gBX9eZ6+7cw0tX+sss3neV
         Z1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790091577; x=1790696377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UWb0eq/OhedEnoNdfqrKl/bTm+EJJ489/BBNtEi1NUw=;
        b=2vemQMPgSkDe3hVOtfRdf+Kjw3c48CtRF5l3FegOJIeuavt4x5DTXIHE9BlXVJvjn7
         cVXX6I/ej28BiuLT2pr4YfDbcy4wjlv9tlcak5Kr1Pony27g3sT4FIjBEm3fIgOMsHDX
         CDmAGU/gNky3cjV5DrOfgAsftJcz+WC8b7nyGxzJvhBOLUo1OQ5L1SfO6Tw5nugG547O
         J9WsdEx1WTkzXGHsOBvuvk267u94aP1Y6wNryVta93gsEj4Bb6tPCOeWmTdsIORVTQYS
         c6XoTrsQkG3b5t+YdHAlS80RJnyuGvZsUiEfonVdhYxlRIcmYyB+1yK88xXb9tr9rDsS
         4eEA==
X-Gm-Message-State: AFuF++nhv2XHSP3kSj7xUmnUiPnJvw64J2/ri5yHkDTSVJC87PZgRJlz
	JHOe1KyL76orWiYsJY/QWWebOs+vh9UuPdJE2Hh3wgI+YQw36wEc4vVg8Z2JH/w0wTFzGIXy6RK
	FqU40IpH7
X-Gm-Gg: AYBFou2G7eiVLjBYO956DUH+oMtzVzrnaLJ6pbjywICuZ62y0C8dLt6c7c17v3Bnm6X
	suvXgMTHIQpdfl62TTPMQcn5NoQ0UxuffuRvOuUd73kNp62kEdBPvgpvUOvoAjfKsIg9jMZpFog
	iZxdXaoHWvqEqktjA00Stc4Fcrml9MAbBo+4aO9q+W6uirHpceX2my3a3KprYGB1FrrJkWdyZDT
	dEZSreS08I7iTjyEB9SnH373X9Y7gIsPdp6LU15ST0Iohh+j0+2PMTI4/Ga7rwsByhulnB5SITo
	djm2nVIbk+G49l5T03V6HR9U4Et3Qj4ayGVGmv5XSaFfBbUMEGu/EZofJo1Uw5A64fAKrR5nZjp
	BpauFipB5O2Wrf1Zg+54SizptklFxLQq+NztyyxmaQUq3fY16z+RuNTmbIsUC2Y6F5Qrp7YOn09
	YNPdtC2COkqB6Fw7B8gxnWBHJQ70W5Ol5azLJ1NvbzJAcpxmnkmKXnUxkVHr0L/YjDxL0kbhjZX
	8IoiQkiTHQaRyZ4kM8=
X-Received: by 2002:a17:90b:3fc3:b0:392:ca3b:370a with SMTP id 98e67ed59e1d1-3a07309f2f4mr1598508a91.2.1790091577197;
        Tue, 22 Sep 2026 08:39:37 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dc7c7b0sm10180a91.2.2026.09.22.08.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:39:36 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	linville@tuxdriver.com,
	vega@nebusec.ai,
	caoruide123@gmail.com,
	weir@nebusec.ai
Subject: [PATCH 1/1] mac80211: start next ROC after purging an interface
Date: Tue, 22 Sep 2026 23:38:54 +0800
Message-ID: <6975ce9d8e9a153e8319d10e6e7c7be004d6df88.1787220252.git.vega.cover-letter@nebusec.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787220252.git.vega.cover-letter@nebusec.ai>
References: <cover.1787220252.git.vega.cover-letter@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ruide Cao <caoruide123@gmail.com>

When an interface owning the active hardware ROC is purged, a ROC
queued for another interface can become the head of roc_list without
being started. Subsequent requests only append to the non-empty list,
so no driver work is scheduled and the entries are never freed.

Flush pending ROC start work and cancel pending completion work before
handing the remaining queue to the normal next-ROC path. This preserves
the existing software ROC handling and avoids stale workers operating
on the newly started ROC.

Fixes: 6bdd253f635f ("mac80211: fix remain-on-channel (non-)cancelling")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
 net/mac80211/offchannel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 2bceb73717c6..c64e2230600b 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -1072,10 +1072,14 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 			 struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_roc_work *roc, *tmp;
+	bool start_next_roc = false;
 	bool work_to_do = false;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	if (local->ops->remain_on_channel)
+		wiphy_work_flush(local->hw.wiphy, &local->hw_roc_start);
+
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
 		if (sdata && roc->sdata != sdata)
 			continue;
@@ -1085,6 +1089,7 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 				/* can race, so ignore return value */
 				drv_cancel_remain_on_channel(local, roc->sdata);
 				ieee80211_roc_notify_destroy(roc);
+				start_next_roc = true;
 			} else {
 				roc->abort = true;
 				work_to_do = true;
@@ -1095,4 +1100,9 @@ void ieee80211_roc_purge(struct ieee80211_local *local,
 	}
 	if (work_to_do)
 		__ieee80211_roc_work(local);
+	else if (start_next_roc) {
+		wiphy_work_cancel(local->hw.wiphy, &local->hw_roc_done);
+		if (!list_empty(&local->roc_list))
+			ieee80211_start_next_roc(local);
+	}
 }
-- 
2.47.3
