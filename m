Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793571939;
	b=vwhdpD6lVNf/Z80fU26W4/kicocfwKm7+jpVgVdJ/F2wSC3fbn03H2/6EwZ8yqV+oKO3
	 Y6Vu2ikavcM/K8IEDvfhtFlELFqi11aJzebNXGcuRKvKLqjjllCxFPeZaDWwfaXwfNw8W
	 HiI+SHs89DBZNZr/ESHFDO/H6M7nJ50ZlANRhzayuLIC4u5QwlygSl1PDGSR2szKR2gIE
	 CMSNMRINNl/RRC8vNLswXwhZSSp7xD5srOrGTV50woHxP50zxawzJArCySuCzJggXC8RV
	 N7ur5XLj5O4i2A8O6msIrJWPKwFYhc3lSrLVqJr5nCbk3tsFIF53P87DgzeRjEklOyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793571939;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=kJOBoJUkoFAEiWtg0dNKy3UlTYdlf7GE/vw5ICcDfv0=;
	b=wuRXQdBLeBtiN52XD+ChywtiDDIuO0hxCoMuGM5sMLN0FarntKu5VZTQGlG0CN2rAXWD
	 mn5d/YurWPD4ff1u2u2A5+QdWNS+jreVElK8Uxu4+apJjxUcF+vlkiJMMVLKeDlK6VsDm
	 dqfHlsZ4OX0Z2ot4eLsFJDHf7qE9raEnaeTdqOeuIjXLW9mw8oKN7jcYnoqDHIEu2yM9/
	 TscQEdcTJef94fONqqjXXrizR1S2Skr+sUX3yQXjF+lK5bZPgI6N1VtzV5HCcsFN8vBFs
	 S8NHh8APeN90tAOFaG005asnaEGb8oWigACcdwCVisNV81ypb0NeR1i7a+ttiiDcOug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LmEr+VQ1;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57C460701D1
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 22:25:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B57C460701D1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LmEr+VQ1
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso4241565eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 14:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793571938; x=1794176738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kJOBoJUkoFAEiWtg0dNKy3UlTYdlf7GE/vw5ICcDfv0=;
        b=LmEr+VQ1TBDpm8PGMdN8isqSoNjalLY06F83FXsd3LHuMPBaCR3le02S2H3oDV8bDl
         Hu+Ba/o+5nLxa51WKsanjBYw//9XaQPzbRve/L705NDW9XMvSr0uJC2SkoVPAp4GSTdu
         QUoy7fwPs2POs9RCz8bl4EMCnC6gFwvy09VY2+EunqEP57j6DGPK9TAtZwUHo+D3Qsfg
         6pLzal6tYEZaeNQFftE/FesVeLv+KT6G52Pk/CWIE1F5pT6D0tForpzNdOjWuZwMT6rd
         BGWIhNY7h+yImwTSypUSrI5L4YBdgroybfAoljcyhhmPUfhMctU/2oURCmUk1UfvGdvS
         Lfag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793571938; x=1794176738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kJOBoJUkoFAEiWtg0dNKy3UlTYdlf7GE/vw5ICcDfv0=;
        b=sXkPFdamSFNz0HZ1JOxwLKurjtdkKcrv7Wh9SDNvDh2w9ec5th9U5Z1f4VxR+CJvEj
         ZbdzrmLgQoG6EX6d9+MC8VTuf0XiTAprg1CzJjGyHQYR3DrUflfhQV/xplateNQv2Mmx
         y419qQD7+GM+E1qPcJJ8yhtXlXeasWaRyM013Pl8YpnqE5140bcpFeU5vUIBrSVoIiIu
         IZaqti+uwmpqloXj51aeE27/ohN1usxp6YrO5U9PyPKgATa50/yi2EQRfEX6I271g1cT
         NE/kKS/EkQFBVHK5yj+SMcqWUFXLFnOquu+ah7aYcaftXmiOlx3VTVmVZXcnvdBEPRLP
         vHlw==
X-Gm-Message-State: AFq9FYIjiZHRCggpvTl3wC35kx9DE1wXfAOlTjsU/1FWcYqtwzPKQqsm
	7BN66JHrPRFTDcZcDWoinL5iyrJHtV4MaXSSIh4RSUEl+NctNjwwrHzsIbJaCg==
X-Gm-Gg: AYBFou28QmTgyFJbAb5d7Hg1GZN3xz+jOrRMwlsOkMSCMZPk+RU72qoim1+lXpOHw8a
	vrIhopVQhIb2W/xY35r8OGGbrLBF28+ffDU6k/0JtZfDkNHhMPGJbrARkA24n6v77WrwIXLlbya
	UbbXW/r2WHX1fBITsZt9wt23lCg0FzOLzMNg7cX7dscOmKcGwoEr6cmeV8DGm5kaneek9ih75B7
	roi5vDrQz/NaPn3IPySvw/QD/X+1GS4O+etbdsfy1PvfglyzZ9Lax9oUPs4scC44O5wGtQz/hnS
	Wwr6rWSjczYSSJEhd3dYIbwjbQg8CCj8mqD2zYBVuGmWf4zqtgXRPt5kl776D3v2tJrJ3hFNJUV
	0p8NXqObtxOe7WadCkGyd4TEczmoAXAo3Zuj97nEYfEwN/fnhb/ygChJIyVilP4BIS48tHxFU+E
	o2OUVZrYes3Fv4cxg8UoxBwvTvyosFYBDXqbWdTwlqR0FOB0DwlkeBZ1zPQC3O3Xq3As1pTUKGn
	D+M1NC4Kcu95O2puuWTmL6M0zUVmmNEflrZ5ZxiKcAmC49BtjhnOkEdHErsfMQ2hUKfqIRZ8Gl+
	k4CtCPdTG9AtHj9SqvtmmgGjY6LUP5ijiFd7JLBt3UK2MzYR3oLP1n55dJmmuv0qesvgPeKZhko
	6cNQimmXI8JsFD3yaWHlFtkdQnAER9CGs6NwwtAfDaXaMNvL8F4Xb/TwZoEGSJq2OnRZfzzokvY
	0nqg==
X-Received: by 2002:a05:693c:87cd:20b0:36a:32de:a239 with SMTP id 5a478bee46e88-36a420643f1mr12848026eec.0.1793571937651;
        Sun, 01 Nov 2026 14:25:37 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42669128sm33089979eec.3.2026.11.01.14.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 14:25:37 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rtw-next] wifi: rtw89: acpi: check for _DSM function support before evaluating it
Date: Sun,  1 Nov 2026 14:25:35 -0800
Message-ID: <20261101222535.34573-1-rosenp@gmail.com>
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
Content-Transfer-Encoding: 8bit

When the WiFi device has no ACPI companion, or the firmware does not
implement a given rtw89 _DSM function, rtw89_acpi_evaluate_dsm() calls
acpi_evaluate_dsm() anyway. ACPI core then warns on every probe:

  ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 rev:0 func:10 (0x1001)
  ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 rev:0 func:6 (0x1001)

Here the handle is NULL, and acpi_evaluate_object() returns
AE_BAD_PARAMETER. All callers already treat failure as "no policy
provided by the platform", so this is only noise.

Use acpi_check_dsm() first. It returns false for a NULL handle and for
functions that are not advertised, so absent functions fail quietly at
debug level, as rtw89_acpi_evaluate_method() already does.

Seen on an RTL8852BE in a desktop PCIe slot.

Fixes: e897b0bef38a ("wifi: rtw89: introduce realtek ACPI DSM method")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/acpi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/acpi.c b/drivers/net/wireless/realtek/rtw89/acpi.c
index ebb6cf555747..2968918936ac 100644
--- a/drivers/net/wireless/realtek/rtw89/acpi.c
+++ b/drivers/net/wireless/realtek/rtw89/acpi.c
@@ -372,11 +372,17 @@ int rtw89_acpi_evaluate_dsm(struct rtw89_dev *rtwdev,
 			    enum rtw89_acpi_dsm_func func,
 			    struct rtw89_acpi_dsm_result *res)
 {
+	acpi_handle handle = ACPI_HANDLE(rtwdev->dev);
 	union acpi_object *obj;
 	int ret;
 
-	obj = acpi_evaluate_dsm(ACPI_HANDLE(rtwdev->dev), &rtw89_guid,
-				0, func, NULL);
+	if (!acpi_check_dsm(handle, &rtw89_guid, 0, BIT(func))) {
+		rtw89_debug(rtwdev, RTW89_DBG_ACPI,
+			    "acpi dsm func %d not supported\n", func);
+		return -ENOENT;
+	}
+
+	obj = acpi_evaluate_dsm(handle, &rtw89_guid, 0, func, NULL);
 	if (!obj) {
 		rtw89_debug(rtwdev, RTW89_DBG_ACPI,
 			    "acpi dsm fail to evaluate func: %d\n", func);
-- 
2.56.0

