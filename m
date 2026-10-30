Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793395386;
	b=Ek48qDdjR7deAADUZ3CHuJN9bRInKwbZCt876kb8v3Cw+e8akiDMlA7UNYvXWG6ZKNs0
	 Dr5cdUa48+O/yDz8U6HkSutIFcPMbyMOsb7TFjZ8W95F1z1aqoz7eT4WTdPPmZFuFG0+H
	 pbKXi6OhbH9MwOBB71t8axAwbk4efn15xBgrtlma2+qdqOiVoBvShJwK7qBvdyt90eOZr
	 wSMg0tVGwH3G6WwcAVW5E7DU+dv1c5aUH9Y1LCxgnHghk18r8I2rWETkAM3tTfsXoNTQ3
	 1kQLe9PMtauOg+FDZw4BJrtl/yxZQAUB41pmxJ6VpFdzSDMsZLAAv5Uvxrpcksb7Xsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793395386;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=lY/l1/aO9GT8bDZSLqLaJYY9fXdCTCZbR0oyw2U3AJY=;
	b=Iia0ZInyZko8T61R4CbVBYpgAm4fG4o3FmeYGY3qWcexDSypiXcv9r+nBzeB8xcRSeCi
	 QUGiWkiTndmRt2ZolBCi2er4PkDcmBeWXzZWcSxjKv+enmw+6ChPvjhNdxRUqAQsuxGB+
	 0QmHl2vUj3+rMn3TmMIN7j+E4Vv22GzNEP45yb7d3AMMZ+4+glhXqPCeLyEWlS8Qs0IfO
	 f2gj3CEiJIIYLtXMQpgl1z4e9GMfI9VZaZULXzvcxMcj7mONBZi33C5WWGByTir+ZYUO1
	 mNl8Z2A7zYsNKP07puzxEZheTpXNnUJSM7luPUMnWhj+fhwHUJw5637xnglcqhigkzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="LGaijJ/P";
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B344606A323
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B344606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LGaijJ/P
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso8483575e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793395384; x=1794000184; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lY/l1/aO9GT8bDZSLqLaJYY9fXdCTCZbR0oyw2U3AJY=;
        b=LGaijJ/PP/4xmLlx98OS8KmffsL2nQx++A7yfV+utTh4fvLe+WUBuMkaIrsPbExsh8
         7wYTEiOxJ9F7gmDZAQB1bnprSqNLj+gAbVViGrxmwE+0UuwMJ/zP+E9L/iuj4cC5Qixk
         l3h+EnXjpem4LbrkoPfsCwLuJOML2LceAypHnolW/eXpGVvBd7QogFnG2DQdZ/tFA9G8
         4PwHJDjULJL1AtM+UmB4nwvcv7WQCBU+8J8wo2vipuFozDWLCQje/9ApBIiqRlpt9qtV
         GMTRuwcQJuJFwcwKVcyPFTQQvYGxsQK07A1amamsIylZoqmrZ7Ft6U0odUkhvcm73WIL
         o6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793395384; x=1794000184;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lY/l1/aO9GT8bDZSLqLaJYY9fXdCTCZbR0oyw2U3AJY=;
        b=yjQqj3t7LoMJNHicwfcg+z7O/zzTRPietz6sWL78FlvhAVGCCw2NYzmHnp6/MuxdJc
         8fjHUm7ZFPWeDvuLwmE0t4LkXCDvc9ilS7oM8Au8OQIn1c2XwnclCF0hQW2UYNAiWV8L
         nUkbgVE9yXxy88K1LUuSUi3wAzcOAgE9cVjGz+swCes791y2eLYjyPrNs3BST9Jo7dtf
         m7wFiGzNg+LiuzFuotlH+Ou5W7CmoQAmLtmYT/5r5d7JmoQa9VYkIe+XOGAclfejOhhj
         kMwgWV9YbOpmckn5rHMC+5RJgi/sbw/Jn3EyjE+UU/UBF15NlGaMf1M1iulO/FZGwXtU
         ayVw==
X-Forwarded-Encrypted: i=1; AKwUvByp+y61AWAcMtoR93fkK6CyPTMA1FBUU9aa3KyuWZCe0WNyaF09oKgQ22JkvfpN1YmaI1gWjSEPbT8nm3oOVw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJlJjB3WHLbwAVokb7CoecRuAfeQP9x/0uyetjnGa3laWqcmAMV
	GnEjGzQ/wDkdFlRHOR57EqHV1aVUXkcUmopffk2/WFGUTroT+DXQbc+9
X-Gm-Gg: AYBFou3zFUKYPZUzbdLjZCKe974cQxpxS/F02LrCZBSBf5cWMzFu5OBHd4e23z4mF4e
	L0/kJKKA6Aet+tsQ4dph5EZ9BuXcBpz20ofBNHafdZM6HOpVzGAp5T9WBL8fP0Z83Q09KPbTyFF
	iFvMLrtpCjGSFQ9+4F8pO/DeWgU4J7X0asM+NzjrTABZ9oTQnDi9RhCXa6GLJx6G2YBsj5DXJF4
	RgmzGSq0snQvRkb7/P487rDI/leoj3tx+e1/yiAgiU2bcXcDjgDlqwtqKoMxt1brVBvOaqJVDHl
	lvQd/UWlnApMfkstXATVvCbnkdx/L03wKF5AQYEdUlHwaA0GFDzFg2edcgv3xOLyswEPSrbwV61
	006SYw/2plaPQx7+AvpeHvNAlBXfxRsW09mKj6bc0YFdd0ebQiKMHz7YLKKkE1gbVegxK3dBdtR
	K3u8RTwVFreGQoo9he8GSBJXDCdyfO6cDpSJsv4iCDvkznACj/W/bJT+7LL2cjdeLnzMIcOT+PP
	7wlHItidgQVHRrbvVV2B1KuoKFXefGuBRjnX2sam2Ij3JnA7QHAOvbPIJ6CeKNzEm9Earj9YKPP
	EydN7FBfUd3rFr87PLx5abK0wIgoL5NigKIyHTHf4LBJiADjN2byM6hK+C/67mK/8UzWS6xJKYB
	b2u8ET5EE07PpWwY1CwmRv2tyrcLP8KnhQJlLJzGeI+A=
X-Received: by 2002:a05:600c:8709:b0:4a1:9078:911 with SMTP id 5b1f17b1804b1-4ac181e75b7mr86458555e9.31.1793395384275;
        Fri, 30 Oct 2026 14:23:04 -0700 (PDT)
Received: from ahmet-f ([176.220.65.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf7146621sm88691595e9.13.2026.10.30.14.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:23:03 -0700 (PDT)
From: Ahmet Duran <ahmetdur10@gmail.com>
To: wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Cc: Ahmet Duran <ahmetdur10@gmail.com>
Subject: [PATCH] =?UTF-8?q?wireless-regdb:=20Update=20regulatory=20referen?= =?UTF-8?q?ce=20link=20for=20T=C3=BCrkiye=20(TR)?=
Date: Sat, 31 Oct 2026 00:21:08 +0300
Message-ID: <20261030212108.24494-1-ahmetdur10@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The previous reference link for the Turkish regulatory domain is dead.
Update it to point to the current official regulation document provided
by the Information and Communication Technologies Authority (BTK).

Also added a fallback search link to the BTK regulations page to ensure
the document can easily be found if the direct URL changes in the future.

Signed-off-by: Ahmet Duran <ahmetdur10@gmail.com>
---
 db.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index fdc2c13..528a9ec 100644
--- a/db.txt
+++ b/db.txt
@@ -1703,7 +1703,9 @@ country TN: DFS-ETSI
 
 # Source:
 # Technical Criteria for Radio Devices and Systems Excluded from Frequency Allocation, Sept 9, 2022
-# https://www.btk.gov.tr/uploads/pages/ftm-teknik-olcutler-ek-5.pdf
+# https://www.btk.gov.tr/s3/web-btk-site/7708c26c-5161-4919-8b3d-daa31d4ac8fb/2026/03/0965cb2b-c346-4626-85f6-fa06fb722be5.pdf
+# Fallback search link for the latest version:
+# https://www.btk.gov.tr/en/regulations?search=Frekans+Tahsisinden+Muaf+Telsiz+Cihaz+ve+Sistemlerine+%C4%B0li%C5%9Fkin+Teknik+%C3%96l%C3%A7%C3%BCtler
 country TR: DFS-ETSI
 	(2400 - 2483.5 @ 40), (20)
 	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
-- 
2.56.0

