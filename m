Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE274734C7
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 21:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790199380; cv=none; b=i2SmD46TcoBtnPwBkW7LjpZHT8PqV5L52nY7SJqfV9crvqdk8gbsGbXt2NmR7ILZX2nF7CwrAvdACXdnEJBpaaTlME5VdHNmsO4xDOg+q5Oy5VuLGGMidPTDF4H144k6nUDtV15LMU3eQp8NQs55xjdVuS+dLG+/G8p0RJfLoKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790199380; c=relaxed/simple;
	bh=xxhmOQt8zhfhZpO/r3xY/2WkgxymHy6PiHCsbhJ/efY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4BVPwFdZJwhdSJnXV/R7GSGfZwIm01vYI62lA9fC7AB6KU8hfaCNtjyV670ZY8s8AKkLHmOj2uDNXZT+DXpmqKelRuOo8gID2nVXoiOmJiP89cCzGzIpnYCXQL+Kb97nsDrI2UzmB2OQXzNJbqFlcfkqe4IJbbGh5hjxk5gxuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fBdBWzo5; arc=none smtp.client-ip=91.218.175.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fBdBWzo5"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xxhmOQt8zhfhZpO/r3xY/2WkgxymHy6PiHCsbhJ/efY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790199372; v=1; x=1790804172;
 b=fBdBWzo5ZT1dVmy0mjU3ry6gNzlKLKemB0MGkaoKGOxEZ6xWQVGK1skvhsLE2LM64HknPp8i
 XQi9lg0qJw8mOKoySXRh/0oIuJLpVDwOZYm1ux9laDlRy6vKraoAGQRMivsexs/VOtbtf4SYGDY
 7k6kgfMCHq/orPClm7ubXzzM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ef3550e837ed4cfb;
	Wed, 23 Sep 2026 21:36:12 +0000
X-Mizu-Trace-ID: ef3550e837ed4cfb
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 6/6] MAINTAINERS: add entry for the RTL8723B rtw88 driver
Date: Wed, 23 Sep 2026 23:35:57 +0200
Message-ID: <20260923213557.186205-7-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923213557.186205-1-luka.gejak@linux.dev>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Luka Gejak as the maintainer for the RTL8723B/RTL8723BS and
as designated reviewer for support in rtw88 subsystem.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b42e898f4d8..7851cfcc9368 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23007,6 +23007,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/realtek.yaml
 F:	drivers/net/dsa/realtek/*
 
+REALTEK RTL8723B WIRELESS DRIVER (rtw88)
+M:	Luka Gejak <luka.gejak@linux.dev>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/realtek/rtw88/rtw8723b*.c
+F:	drivers/net/wireless/realtek/rtw88/rtw8723b*.h
+
 REALTEK SPI-NAND
 M:	Chris Packham <chris.packham@alliedtelesis.co.nz>
 S:	Maintained
@@ -23027,6 +23034,7 @@ F:	drivers/net/wireless/realtek/rtlwifi/
 
 REALTEK WIRELESS DRIVER (rtw88)
 M:	Ping-Ke Shih <pkshih@realtek.com>
+R:	Luka Gejak <luka.gejak@linux.dev>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 T:	git https://github.com/pkshih/rtw.git
-- 
2.55.0

