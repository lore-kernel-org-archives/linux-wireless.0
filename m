Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7349B45562D
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774840; cv=none; b=NPavOx+V7xmYz1m9enWF5Lzzz2Qk83aQW14SjV+egqVspxYGMJDAVEmgsXrenxMCSMmnHdNgkB71pcwQpyAVqJrZDtvSuXxhqlXnOjNbi+YByTKa6Bu1QVYo5taxfzBpnbqpz6zCqPs3+SpbIZ+V74YCoLIF/AZIVAn3YRRwdDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774840; c=relaxed/simple;
	bh=eeIpykqHn3v97v6Vn5NBMhwy/4B4kc+s5oigMCXgBFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2fJyNKunFy5xxPO/G5QxBps14qDHdQ/z00OzxzxlY/w8VPNddgk2n58gzw6CiKaiIWpHtrzOdHHyveZ5DZSGHo+7blaUryoD0aSo8sJf7JRtvTRKUcoT+6kxQIFgMEST6xy7s1rbFIjmk6QqWRbMf0AWogjVCpvVzn8hPz6DXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H0RuOw1Z; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H0RuOw1Z"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1c8d4a959so2179212a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788774839; x=1789379639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NvhoiELaoR7kd2vY205ko6ySCRXz4bZekivzye23j6I=;
        b=H0RuOw1ZFHgxbb/w9fEZBiBOdB4eOcpf1z/HCrUJ19j2GoD03iUa4gqY4y5Bbo4HwQ
         SlwLELBXKoJZR7/npOoI0dhhdkNRv0oLeWj/Sk9Ipnp4tTce+WESUR6wCFHNbrAAURDT
         9L4eXF9HAw+KZ+qZs3TlTaHkszeMec0BujEeNco9arYoLOZAhkML+ijN7tfwUsO8Rf9x
         DkuQ+x5OY40slfKnJjKpfSg+XBeK/9fIviwoitJ9RJg1D58UAlLP9r6qlQX95N3/MUtj
         2poIGmguXB/ce86dO8BlTQA0pwOd/5ij2/Nq/P06rYKQ1omjNmo/5ht8TcsrPy79Tdkd
         j8Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774839; x=1789379639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NvhoiELaoR7kd2vY205ko6ySCRXz4bZekivzye23j6I=;
        b=fotLWFobXO0cyiPa3GOt7iR6qobp6S6xu3UG52gbCjc/cdeVSkBQ3twEzawwbYBC3z
         qbQJ5ROCPy0pM+G+RTW2VgiIQpvQzOyG3Tn2eSCLYvusRA3Zy11598sSb45+NiRA59uw
         VVTqngbuXfOIzsRTDZ41/gCRz8nBNWY4Uwd47D29BXqWkuV6QVzmQWmM/KHCMgNE4/ed
         9Rwf3eB9qZJIh7P9dbzMZrf3b1dwLHDIxnM9DSM6oP2NAKy5FPYxQ4SkgXasI4FeXOH7
         e7XazdIEvW/SBFOWm57WLTa/4LesfHNu+zFxm0+ahclxGhwTtjZ5WNyiRakXTdd8nJct
         G5dg==
X-Gm-Message-State: AFuF++n0YD3g1NyKjx6Qk/fAauaCEg4mbEFweCAxlEXUGp1cdGvb9ieD
	3IaRzsWRhI80mSzGq2yp72z/3AuXN3dhQKmHT/eKw1cXjvg9JWUfvcjN
X-Gm-Gg: AYBFou2KGITEPVJgqAKfl0InO04eE/YPTd9egKESW7J6xKNZVj2zfIjCcZBscrq78dn
	zdfsv3T2iR9dBmEaclcL8UTjuk50xnbfgreGk4LDpnepbpfzLYT8AKKh6VBzk9eiDEP67RnEPlG
	T0cHqFc4B/m0S3AAsmgM8ID7ioH8G8bNAOOBv5xyO8N1GCIRDBwnYrUwSBQOCYspyFaVDian/bx
	Ns3BE89cTtC9uUc02qu2vN9BeUJvztGTuqrsMeSmhRSLR85JPuK7LjtZxTgKINCw07GhKOlWaD9
	0VWtX9XDhsERd3zQP3xYpGQJv6mJ9Ft+h1PLvCCwcZKvX0n2ox+el/u+m4PsyoypckcPS+QvSAz
	0RTXZldow9rSenTw0SDrOuRBcGG11Krh0KbztGw091Z9w0lEaVO7NXi9wzA2Sz845udpe5SzIQ7
	ersQ861ZSWGUgdeG4z+nQ3J7oQi7UktJsW1Z3TPibEnCei+FNquz+gqiXq2W1DWWeES02xHIwW+
	Gyl9hN5hsUqOQ==
X-Received: by 2002:a17:90b:2ccf:b0:398:a2a3:b631 with SMTP id 98e67ed59e1d1-39b262aaf3dmr35242453a91.19.1788774838738;
        Mon, 07 Sep 2026 02:53:58 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm30377066eec.21.2026.09.07.02.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:53:58 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 3/4] wifi: mac80211: fix typo "capabilties" in comment
Date: Mon,  7 Sep 2026 15:23:47 +0530
Message-ID: <20260907095348.26094-4-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907095348.26094-1-hemanth.selam@gmail.com>
References: <20260907095348.26094-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo in comments, found with scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt. Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---

Notes:
    v2: designate the patch to wireless-next and use a subject prefix naming
    the component, as maintainer-netdev.rst asks; v1 went out with a bare
    [PATCH] and a "net:" prefix. Rebased onto wireless-next, diff unchanged.
    
    v1: https://lore.kernel.org/all/20260907061417.33729-1-hemanth.selam@gmail.com/

 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..0ce7a7ab769c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2870,7 +2870,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		}
 	}
 
-	/* NAN capabilties should not change */
+	/* NAN capabilities should not change */
 	if (statype == CFG80211_STA_NAN_DATA &&
 	    sta->deflink.pub->ht_cap.ht_supported &&
 	    (params->link_sta_params.ht_capa ||
