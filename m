Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D894395AD2
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 19:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791313595; cv=none; b=LT6TdhKvdXbE6YAKvDltE7L9yMam9SC0IY9StCuV6SDxpGHK8wuuZfa7sSczeZWKh0KZv7+QDZ3Q6mWgmvlwEp5R4O2iTXxeelEcfNb/UNtIMFgRy2HoQGDA1eYq++4H61OIhOhr5lsac1iVmwDUjcwENJeQf2xRS/m7dl2Vi88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791313595; c=relaxed/simple;
	bh=9BixdBj1TQzOiLu0N7/HmWsSO2laP/29Q7rZKczxOO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gfzOR9tuPQYmAOHPTVSbiQW0Suv0LN3cqyhRxb9bNoTKgXFrvSCrnvIcRFTd8obNmprhi5wlQ9BJsNIJWXVKk7493bjkbwXm9NM3xzG0WG73OLxLhIhMuH+h8Pd6aCpy7WoZ3Z5Curxz33fxW0fkJveq6nigNMWA24d57+svkho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=rBk3ftN9; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="rBk3ftN9"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9BixdBj1TQzOiLu0N7/HmWsSO2laP/29Q7rZKczxOO4=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791313591; v=1; x=1791918391;
 b=rBk3ftN9WYB3ZZ2klTVKHBXxeQR8I/49CpzgqLV1tVw6MHxSYphUv0D9qGr+OUDHHkO0W4TO
 9QLMTe5J1ReOSfFAIdXVhqxKu7v5DHQqns+EuT2gsd7B0bSg0vb4L7bJh2EcCyG3CIshpiL1B/+
 z8cqg1QNcDfpOdXYFuag66E3hiXDGjMDqnKvQHH7Pidd8Pp0TqvSzLdNmjuVQTveqKUiFZvAMRV
 19qp6nyYsXAxl4gYCFyLI9C/bpqcicIcCRAoMdog1BWXCV80svmOkmWoChuAMfowXgMvpEqqXH3
 9gnYcLc+DGdjwPywlsiFNs1AtiByL7AXIK4yMuDFrsPsA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6d0fc2d441671710;
	Tue, 06 Oct 2026 19:06:21 +0000
X-Mizu-Trace-ID: 6d0fc2d441671710
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Nick Morrow <morrownr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH rtw-next] wifi: rtw89: usb: shorten the RX aggregation hold on RTL8922AU
Date: Tue,  6 Oct 2026 12:06:18 -0700
Message-ID: <20261006190618.258037-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RTL8922AU holds received frames for up to a millisecond before
handing them to the host, a value carried over from the RTL8852CU.
That adds up to a millisecond of round trip, and under load at 160 MHz
the access point drops to lower rates and download suffers.

Shorten the hold on this chip. Upload is unchanged, and so is download
on a USB 2 port, where the bus is the limit. The cost is some extra CPU
at the same load.

RTL8922AU on USB 3 at 160 MHz, power save off for the round trip:

                         x86, 6 GHz    x86, 5 GHz    Pi 5, 6 GHz
                        before after  before after  before after
  TCP down, 1 flow        613  1002     579   948     586   999  Mbps
  TCP down, 8 flows       656  1187     629  1080     605  1108  Mbps
  round trip             2.33  1.29    2.25  1.18    1.44  0.88  ms
  busiest core, UDP 200M  8.4  12.8     8.3  12.9     2.3   2.8  %

Fixes: 32cee8a9bb66 ("wifi: rtw89: usb: Enable RX aggregation for RTL8922AU")
Reported-by: Nick Morrow <morrownr@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Ping-Ke, Bitterblue pointed me to you, since the 32 came from Realtek.
Realtek's 8852CU driver uses it as the default and also has a
small-packet mode that sets the hold to 1, the value this patch uses.
If the longer default is there for a reason these tests would miss,
please let me know, thank you.

 drivers/net/wireless/realtek/rtw89/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index dbad42c17761..3dc4c97bba50 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -821,7 +821,7 @@ static void rtw89_usb_rx_agg_cfg_v3(struct rtw89_dev *rtwdev)
 {
 	const u32 rxagg_0 = FIELD_PREP_CONST(B_BE_RXAGG_0_EN, 1) |
 			    FIELD_PREP_CONST(B_BE_RXAGG_0_NUM_TH, 255) |
-			    FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 32) |
+			    FIELD_PREP_CONST(B_BE_RXAGG_0_TIME_32US_TH, 1) |
 			    FIELD_PREP_CONST(B_BE_RXAGG_0_BUF_SZ_1K, 20);
 
 	rtw89_write32(rtwdev, R_BE_RXAGG_0_V1, rxagg_0);
-- 
2.55.0

