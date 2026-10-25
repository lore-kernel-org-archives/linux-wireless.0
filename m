Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792952423;
	b=4dRx3ujGdBVKPLLOlBWtD7hCKDlKw145RXwOk8Bx/EURTz6g/JqbpSk0HGebLGFYzlm4
	 esXq3TUL/5XWVlfRG/wjNqcovoX8PZN9dEA9a3OXyj0ljxv5MZsQy7g1jJNStO7ewh3nK
	 HRP1XMzKXoEWbtFh3idVd7TyrYPklIBUZfY4G4vjCMneDWBK9pxU/vbR6j6NNr64P168R
	 gGuiDiC+F6+l8e9N5qgEkjsFD4ZIsibsliElXL5cctKYxxAuZVXgvpVL0pbWcjza9OTub
	 O/8oV4atKtetM/RNQW7jm9x0hezpDPyIEQDn7DJybWgJcpe01agbifdON97v8hf3M3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792952423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=6dNyV3fpMybpXNc3EAQIMokM6V/kPapL6dCc89nw+uc=;
	b=2Wq+vA6D0DEb95vrorj+69BhqNYTmrodLvcpVHLNr+c57kZlf7BSbEdoqGflWYf8SXYf
	 gnvjEbUFAywPpxGn0qBcqkliEUwmHiPA7kt8TVQdfK27CTQmzt6RD18Xf0cdgBy71waCo
	 yn3YBIRw3Gy+hxT8lFLReleFHDg0+zz5ShusuiXGiqpiaSpygPkNYAKfzpTlUmt/4EJr+
	 gRzQPXklBpaPmR8UcI6mJtbmTGmd9srwT6cLIBnIurI/FmDREy1mZduhY5g356EkgB8Wl
	 emFK7H1KMpSxEmlhI4CK/QCvVPkij6NlOiCNiepLK7wHRxHL+311rIae8kOMoRODybw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UJ+bpWgE;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D82606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2D82606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UJ+bpWgE
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso4523273eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792952422; x=1793557222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6dNyV3fpMybpXNc3EAQIMokM6V/kPapL6dCc89nw+uc=;
        b=UJ+bpWgE9CXU+GK5G3PYpRu90D19azJNtd50lQcuj9wQhnZJpNEomqmASzzbWS3214
         5gARjZ1qCXsbdKh2EZunI70GMamgrqCZd2Q29tKkrpBJSKZReuaZ3DSSOidiz8058p3D
         Pi+XJTtMUsEoBd2oMR0dkwJfx79DztlqTka4dttQDVoBl12f82PXGNYT0NvVRWTCh4Vq
         6JI1Kkh12Eme4ujYBD/pe8kMJGI01xraLwlo5FiOz6W9jw4RntShD3hPuZZ9lWhcKcvb
         8TdGJTF6xrzjAUeHnEpN8WdIEGETVzTmdKbWKxy3U9kiHKunUWeADJEIJmXXtdpS03tR
         Ffbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792952422; x=1793557222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6dNyV3fpMybpXNc3EAQIMokM6V/kPapL6dCc89nw+uc=;
        b=FvXN9BrvqD1j6x1dt6pUv0lmUaRgjtXNkcuMtdgWWgSZtUr6+ZYVNd61hFfWekO7y8
         wSBLYso7PHVzkgYyjlPnZhk/xIZrzrPbhP9RU4cidgTy9cIYiCeIXlmo2VDNrVpuii1O
         UhR30W/2z8gXUJd5rzPIZf0iwclPDoVEKmvcX/a35cN/c+M2w3C3++/0K4IWhJfZpQX8
         /w+VYhV/06icXrU2k597RDXFnnh+oqn8umke+ilUiL6fTGUa2ZJw7kdMbtuMch64+Iqq
         XDPJS9AeU2Cvvi3WtHbG/mswHDzq655LR4W6+bIRPk1uNlvEjKGhcwMdr7QyCv241Y6M
         RMEw==
X-Gm-Message-State: AFq9FYKa41lmiFIcvUmXD3eYNtOOzsaKNdJLw/kbfpi8ERjVPBRxDv0b
	2lat6kLWiieviK/DyR7zXZ9rrR4qXH7PH2szquJ3Y/8k/RHOdXM6+fCTsYvfiMDzsyQ=
X-Gm-Gg: AYBFou3rdB1YQgv3fbkEJZIhWyX5DvfInXbR/AbMRaUa75lZZkPoSbssiXpIPMNQJdI
	eTd9EH7UFxa9aL1TtS//BOqmGdxml1aoDP1GgH28YjFyPbUkgOEwrbfbWNymXre07217Myx7/Jt
	LiUe3swwPKmovdeIbqlVdfm4P+xD9uwnI+tHwhdArOn534NNLJJSk4pk4STgzLIBLLdu9405XGk
	ezyhKUGgwCQ8tPgUrBiSM7oqW3HUj0PO1F9xeTgfpWoZc+Z3oJrO/4hXi+4qn3awodLftEFZycW
	M0jo6TDuxNlBA4GjWBMt1VsJ6Lf2WPvpUnrBR0eDYhsgvsR8G0kXU8BJNx4L5BDCH66EsbjBdgs
	cKGIUYHEDe4f9IpHgvGcThnJdxJIN5QIbD8FIf3rAwLZyR67eLzOyOH1Mklvl3CZy4lyEQVbQrt
	faXTAEY1b+3v+VtiK+PA65Abnrg5GjtEDC5rH0hS08rdFe3a3HuAUn4yBxYo2W+XpX/2z37DaFl
	q1pi3yyQrR9+T89ewmhzLxS0H9Su3m4ZimkDf9wPszBPRVL0kYsMw1CdOzxm5h0jRXl3itjpy9G
	Yfd36C/SVAMYQizJWQ5oqw==
X-Received: by 2002:a05:693c:8642:20b0:35e:9c54:d41b with SMTP id 5a478bee46e88-369e85004b7mr9067107eec.21.1792952421588;
        Sun, 25 Oct 2026 11:20:21 -0700 (PDT)
Received: from ZephyrLabServer.internal ([165.162.64.148])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8d93663sm21226162eec.13.2026.10.25.11.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:20:21 -0700 (PDT)
From: John Macias <dencity7@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Jeff Johnson <jjohnson@kernel.org>
Subject: [RFC PATCH v2] wifi: ath12k: service all RX rings in an interrupt group
Date: Sun, 25 Oct 2026 11:19:55 -0700
Message-ID: <20261025181955.2089498-1-dencity7@gmail.com>
X-Mailer: git-send-email 2.47.3
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

ath12k_wifi7_dp_service_srng() services only the highest REO destination
ring selected by ring_mask->rx[grp_id]. If a group selects more than one
ring, the other rings in that group are never reaped, and the flows
hashed to them stall.

Every in-tree ring mask selects one REO ring per group today, so this is
latent upstream. It is hit by the QCN6432 ring mask from the vendor's
downstream tree, which puts REO rings 2 and 3 in one group. On a
GL-BE3600 using that mask, 7 of 16 single-flow TCP downloads stalled or
failed, and ring 2 reaped no packets at all.

Walking every ring with the full budget is not enough: under load the
first ring can use the whole budget on every poll and starve the others.
With that approach ring 2 reaped under 1% of ring 3's packets, and the
flows on it ran at 0.2-4.4 Mb/s while the others ran at 100-360 Mb/s.

Instead, give each ring in the group an equal share of the budget first,
then hand any budget left over back to the rings in a second pass. A
group with a single ring still gets the whole budget in one pass, so
current hardware behaves as before.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Assisted-by: LLM
Signed-off-by: John Macias <dencity7@gmail.com>
---
Changes in v2:
- Share the budget between the rings of a group. v1 walked the rings
  with the full budget, which starved the lower ring under load (see
  below).
- Rebased on ath-next.
- Added a Tested-on tag, full name in the sign-off and an Assisted-by
  tag, as Jeff asked.
- Link to v1: https://lore.kernel.org/ath12k/CA+KzPsr13czsH=k_UWJqj48C4Vsb-diQ-tiCh7W4XW31E8WzHg@mail.gmail.com/

This is still an RFC because I have no WCN hardware, so the WCN side is
untested. Since every in-tree mask has one ring per group, the change
should be a no-op there, but I would be grateful if someone with a
WCN7850 could test it and reply with a Tested-on tag.

Testing. Both radios ran OpenWrt (Linux 6.18, backports 7.2), and only
the ath12k_wifi7 module was swapped between runs. Rebuilding the
unmodified sources reproduced the installed modules byte for byte, so
each test module differed only in this handler. The QCN9274 build also
carries an unrelated local REO fix, as installed. The QCN6432 is a
GL-BE3600 using the downstream QCN6432 support (not upstream yet), as a
5 GHz client of a GL-BE9300 with QCN9274. iperf3 over that link:

                              before    v1           v2
  16 single TCP flows done     9/16     16/16        16/16
  slowest of 8 TCP streams     stall    0.2-4.4      70-83 Mb/s
  ring 2 vs ring 3 packets     0 vs -   3k-8k vs     about equal
                                        0.7M-1M
  QCN9274 RX, 8 TCP streams    1012     1048         1034-1042 Mb/s
  UDP loss, 8 x 50 Mb/s        -        <= 0.02%     0.00%

No warnings or errors appeared in the kernel log on either side. The
QCN9274 groups are single-ring, so that tag shows no regression rather
than the fix itself. The hardware runs used a variant that differs only
in cosmetics (left-- was inside max(), and the comment sat inside the
loop). The patch as sent builds without warnings with W=1 on x86_64.

This work was assisted by an LLM (Claude), which helped analyse the
handler, write the test scripts and draft this patch. I reviewed the
change and the test results, and take responsibility for them.

 drivers/net/wireless/ath/ath12k/wifi7/dp.c | 31 +++++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp.c b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
index 397da016b..67a347362 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp.c
@@ -27,6 +27,7 @@ static int ath12k_wifi7_dp_service_srng(struct ath12k_dp *dp,
 	int tot_work_done = 0;
 	enum dp_monitor_mode monitor_mode;
 	u8 ring_mask;
+	int rx_rings, pass, quota;
 
 	if (dp->hw_params->ring_mask->tx[grp_id]) {
 		i = fls(dp->hw_params->ring_mask->tx[grp_id]) - 1;
@@ -50,13 +51,29 @@ static int ath12k_wifi7_dp_service_srng(struct ath12k_dp *dp,
 			goto done;
 	}
 
-	if (dp->hw_params->ring_mask->rx[grp_id]) {
-		i = fls(dp->hw_params->ring_mask->rx[grp_id]) - 1;
-		work_done = ath12k_wifi7_dp_rx_process(dp, i, napi, budget);
-		budget -= work_done;
-		tot_work_done += work_done;
-		if (budget <= 0)
-			goto done;
+	/* A group may select more than one REO ring. Give each ring an equal
+	 * share of the budget first, so a busy ring cannot starve the others,
+	 * then hand any budget left over back to the rings in a second pass.
+	 */
+	ring_mask = dp->hw_params->ring_mask->rx[grp_id];
+	rx_rings = hweight8(ring_mask);
+	for (pass = 0; ring_mask && pass < 2; pass++) {
+		u8 mask = ring_mask;
+		int left = rx_rings;
+
+		while (mask) {
+			i = fls(mask) - 1;
+			mask &= ~BIT(i);
+			quota = pass ? budget : max(budget / left, 1);
+			left--;
+			work_done = ath12k_wifi7_dp_rx_process(dp, i, napi, quota);
+			budget -= work_done;
+			tot_work_done += work_done;
+			if (budget <= 0)
+				goto done;
+		}
+		if (rx_rings == 1)
+			break;
 	}
 
 	if (dp->hw_params->ring_mask->rx_mon_status[grp_id]) {

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.47.3

