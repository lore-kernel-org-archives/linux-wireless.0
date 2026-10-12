Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5CC1A9FA0
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 01:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791767844; cv=none; b=YmOdLf4m8AvWSGmd7ZboXhok1r+1YcfQmyzCWFpnrqoLfsKT3sV0/RiP/O7PK+b17R+zzxnwba2v+gnSvJyA9pxwnUzLgBad+6vfzbqxjs30ZUNyKmtsrXz0SRmNWpZSSk201gVEZb+1+VQoZPgK680FBXkxgqTklU4Sx4vxP3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791767844; c=relaxed/simple;
	bh=s7RHTsXfEOg+gwqThuTUUiknVQDtwJu49s4s8eAwliU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uwqk2Iok395XYGI/bzYGQNQIbYTS/ODg4EKpNiL+u5b9Z6zbi+JTiFTHouInQc6yCPEeEPEy/qTKf86ZR6NgImjRNCN3ZGTHYM5m/fw/P7pb8KOlNVV3MDagSOSOpmjRi727vtQvlnl7mqeK6WqDacDF69N6PlM6fTnqbPcgYU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hq80HA5P; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hq80HA5P"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-398b3c37877so596553a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 18:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791767842; x=1792372642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEgFM2qnyZ26U72V739p3+vOc5ZxhizwkmlzBdho0QE=;
        b=Hq80HA5PNYCKkHHb0NM0K0h8IWpdT21FL9Z6PQfMnic7PJjxDK/Q6DmDK9ZAGtyi7X
         yTXZfPo6n2reX3Jncaazs0WeiyJyZ7AVIS/v60IscjYMTXdFzMSRt5CzaFpzKC3GwWtZ
         7SPNbh6sJmHWYfMdv3KbSHD9QFco57n19+S8ZDyNtyJScuQvvYgis6AESJkqTtU7ijlG
         ZmLIFkF5uDLUe8Zz0cBM8F5VJC1UiGySUxWGkbMG6ETXViC7oQ39WlvUcOSyagAU9fuo
         ouW4SRWUAJzp0Q3gzq4/WeuAQsufmyYbQtrVoA+Qq1w25ZfBuz3r8hfZDMTaeag24Yrn
         tpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791767842; x=1792372642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IEgFM2qnyZ26U72V739p3+vOc5ZxhizwkmlzBdho0QE=;
        b=BVQ8YZZB5AYXP+vXIyZe1cLkCz+nnqpuXHqe/Gjaw3LwjAaidyxCGBPET8zcF089xx
         1hBbHceqBcU915VDHV/0lZnN+K9dAw8L5ltl85W0s5kC2eMS7yPOdG5HJCzeA/ym4/8A
         fOwTC/NFMGL/r+yg9K7+g67JW3tc59/FiqSXySooUP3eB9W5JNgZAe2SI/tyUS0ffF2n
         FE9hUGnpe72qB6GRy6vwICycNAhjcn3tZvDhXiAOUCCACXY1G8wrrdKj8ATYn9leYvO7
         ou67Jd8+0ugiXLNoQ43k03p0JoONlejbUkNidGRDbYuhCL2pW9QKSNJud1FxIdWW7jMV
         8GYw==
X-Forwarded-Encrypted: i=1; AKwUvBwbB59HgRaCXk3amK0QT+ZybKi4xGmKToZmq72EVShMaKuB4RpKuJe6F9uoSQ5YcbPDhGf+pwQ3qwjtllwFew==@vger.kernel.org
X-Gm-Message-State: AFq9FYKtGc2oXYn2B93n8QSkVZnNu2W4ox1jyd+KgB+EOG9IA3tczFkK
	cbXJudbHKaSO2EL4CTtYcyf/w2AHp4mncE7iYihHmbFPkP9VEhDhKmDu
X-Gm-Gg: AYBFou1W2rWH4JwMMcozU26AKZyaLTNAblb7MyXnowFAAoywSKxeqRV1INbt4Mt7Giu
	z8gG1mPAlDDxKanWTYWVhqYIqtf8SvXelY/B1xj2h04JiHgQqwlOeGlJ4LuoHyXuVQ6t3wr9POR
	8ZxaxRrpZMHz3M8GT2vGfy9vHpIkcnXL/BIIWbnpP2NT75UMS9qAZFSudbwmjlY6SDDokoCwphf
	6bRxIVjvyagqeEc92lQOSduD/YoiGou17y6cM5hVT3qJknAqzDV2d5ZcQVb6Z5+CIn7zGW6KTXi
	OJVysBbLE62utJNmKYHTn+N9a6xqDrHYfamqb9SyXBgc7yqpusyVNpKxiTUwShNMJLuY0WXvb+7
	0G2MRzx3GF6cad3W1mQNScaiuIFxUjGddn6iCKpa/Srs81ncZwq7WnY2qtqxFnjMAyAhT7I/kZg
	7oSmqT3WrM49YK5x1mz8UKNGO5VLpslEzTf7uqa7cw9YfRP7nIa7Of/td9T2Q61T8ddmjWqfjWT
	HVSdbyPif4IYYpjEMTjrvHpDZLqU0la9DktR2GPiSP79dpUPXqcoFLErD5MmUIBt5APMXidKwMR
	sg==
X-Received: by 2002:a17:90b:3145:b0:3a7:eb0:119e with SMTP id 98e67ed59e1d1-3ab3ab5a2e4mr6280492a91.21.1791767842327;
        Sun, 11 Oct 2026 18:17:22 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38dd5864sm13743307a91.8.2026.10.11.18.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 18:17:21 -0700 (PDT)
Sender: Yuyang Huang <uyoko90@gmail.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Nikolaos Gkarlis <nickgarlis@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Shuah Khan <shuah@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v11 1/6] netlink: specs: rt-addr: fix the type of target-netnsid
Date: Mon, 12 Oct 2026 10:17:02 +0900
Message-ID: <20261012011707.3378-2-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012011707.3378-1-sigefriedhyy@gmail.com>
References: <20261012011707.3378-1-sigefriedhyy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel parses IFA_TARGET_NETNSID as NLA_S32 and rt-link.yaml
declares its target-netnsid as s32, but rt-addr.yaml has it as binary.

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
---
 Documentation/netlink/specs/rt-addr.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/rt-addr.yaml b/Documentation/netlink/specs/rt-addr.yaml
index 0ecbd24c890c6..17ead22034515 100644
--- a/Documentation/netlink/specs/rt-addr.yaml
+++ b/Documentation/netlink/specs/rt-addr.yaml
@@ -119,7 +119,7 @@ attribute-sets:
         type: u32
       -
         name: target-netnsid
-        type: binary
+        type: s32
       -
         name: proto
         type: u8
-- 
2.43.0

