Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D2A54705C;
	Sun, 11 Oct 2026 07:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791702630; cv=none; b=drJakggKo1rtdHDCDGtG9x9A/ytDCOnXO1RpMH6nP3btmCdiAf/ORRI4rjdDntSnCLxgu9sTMxABJr+ctENpOE492I7ieEk/sdCUuz+/ehB/5tRApkPJ/TPmqRx2GDyc4t8K8Ol3wbnOorR/D73kPZ5uh6zwyO9mpWObe7VyVP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791702630; c=relaxed/simple;
	bh=yJzyCXImaua9bP/WfED/VttSQroVOGPZKTgD8S/8vCk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=nrQNAEn7+y3t2NhNxsdop242Xr9fDztS2j4xjYVkedMSDQh1f4dXXpk/UaioQ6kAsRLVbR3gBa6rZuPcWzbNa/5O7oWFsvmxX3C+IjVr+Opk6ye4Sz0Wt7nLLqyREWYn6Sg4dF5CCIOH5kjzIMmRG3TftGLUFrG9+A7WMfCL5Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7MIoyxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7MIoyxm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 119A9C2BCF5;
	Sun, 11 Oct 2026 07:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791702630;
	bh=yJzyCXImaua9bP/WfED/VttSQroVOGPZKTgD8S/8vCk=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=K7MIoyxmrE2No0mjb56BkWDN1skbVKiICPl6oVo5MT7uV1kbRjDtNs4P5QGx6LDaq
	 YeWVOawmVkohGXio+2O0hsCapcYsxWcbIQg4o8X1/cVxfpfCoFGlHKFGRVL/wuQU/q
	 3r6u6C9HeLgtN8/OAyuYLjSLFMSpqA6/tj9M9thpxwX0BJfYukbcEc5xT7tMMQGLpX
	 jQ2WVMaOKNa/tq2IXD+DIpuomEnQP6iptHsJsTb07l906xgxl8Z5YMLZMxKNE87Ydp
	 C+8GFRZICjDGZRoJ2S75/gQoUJLqPR24A9yrUOYLJ8T7JRpofqxnPgzVymP3P5Ru5T
	 hsXCIR4sYUz/Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FC0CA9EC7;
	Sun, 11 Oct 2026 07:10:29 +0000 (UTC)
From: Momo Chiyoda via B4 Relay <devnull+risingnusun.gmail.com@kernel.org>
Date: Sun, 11 Oct 2026 16:10:28 +0900
Subject: [PATCH RFC wireless-next] wifi: mac80211: wait longer for the
 assoc response after TX ACK
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261011-assoc-timeout-rfc-v1-1-c6cd52166968@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQrCMBAAv1L23IUkQqBeBR/gtfSQpltd0ER2U
 1so/bvR4wzM7KAkTArnZgehDyvnVMG2DcRHSHdCniqDM85bYy0G1Ryx8IvyUlDmiJ0/jW7yrjM
 mQO3eQjNv/2cPt+vl51YWepIqJtoKDMfxBRkYrs95AAAA
X-Change-ID: 20261011-assoc-timeout-rfc-963b2d62900a
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Emmanuel Grumbach <emmanuel.grumbach@intel.com>, 
 Momo Chiyoda <risingnusun@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791702629; l=3760;
 i=risingnusun@gmail.com; s=20261011; h=from:subject:message-id;
 bh=LOdM8a/v+emxV+3GmbWc+lYJdyPdcTUSe9gIToWDKyA=;
 b=G6UVCe/v5uILeWL4BKWHHduBF9xXMArOQtDkI5qXFtigNsrkT3DhWMfs1TV3mUVyuC4boOns1
 JoIj13gGPG/CMsqQY6B5ncsQMi+hguxSBa2bbiQCMUi0cvfOn5XpTgQ
X-Developer-Key: i=risingnusun@gmail.com; a=ed25519;
 pk=ExWtmy9phzUICIOOPUfUaW25aiqDA86U5ztzz8t7T4I=
X-Endpoint-Received: by B4 Relay for risingnusun@gmail.com/20261011 with
 auth_id=1153
X-Original-From: Momo Chiyoda <risingnusun@gmail.com>
Reply-To: risingnusun@gmail.com

From: Momo Chiyoda <risingnusun@gmail.com>

After the (Re)Association Request is ACKed, mac80211 waits only
IEEE80211_ASSOC_TIMEOUT_SHORT (100 ms) for the response before sending
the request again. That value comes from commit 1672c0e31917 ("mac80211:
start auth/assoc timeout on frame status"), which assumed a typical
response time of 30 ms.

An NEC Aterm 7200D8BE AP with MLO enabled needs about 180-250 ms to send
the Association Response. With an Intel BE201 (iwlmld) every association
therefore sends a second request about 105 ms after the first one:

  associate with ... (try 1/3)
  associate with ... (try 2/3)
  RX AssocResp from ... (capab=0x1931 status=0 aid=1024)

The AP answers the first request, the STA completes the 4-way handshake
and installs the keys, and about 330 ms later the AP also answers the
second request with status 0. From then on all individually addressed
protected frames from the AP fail to decrypt on the STA, although the
STA keys were not changed, so the AP has apparently set the association
up again. About 5 s later the AP sends an unprotected Deauthentication
frame. With PMF this ends in an SA Query timeout in wpa_supplicant and
a locally generated deauth with reason 2. The connection never survives
more than 7-10 s, and since every new attempt hits the same race it
loops forever.

The AP is at fault for resetting an established association on a
duplicate request, but retrying while the response is still on its way
makes this easy to hit. Use IEEE80211_ASSOC_TIMEOUT_LONG (500 ms) once
the request has been ACKed. A request that was not ACKed is still
retried immediately, so only an AP that ACKs the request and then does
not respond takes longer to fail (3 * 500 ms instead of 3 * 100 ms).

IEEE80211_ASSOC_TIMEOUT_SHORT is kept since it is also used for the ML
reconfiguration timeout.

Tested with the same change on the iwlwifi backport tree on top of
Ubuntu 7.0.0-38: before, 33 MLO associations had 66 retried requests
and 31 reason 2 deauths. After, 12 associations in 8 days had no
retried request, and the current connection has been up for more than
5 days. On wireless-next this is only compile-tested.

The trace analysis and this patch were done with an AI coding
assistant.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221868
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Momo Chiyoda <risingnusun@gmail.com>
---
RFC because this changes association timing for everyone:
- Is 500 ms acceptable, or should the longer wait be limited to MLO?
- I left out a Fixes: tag on purpose, since this works around AP behaviour.
  Please tell me if you want one (and stable).

Emmanuel Grumbach suggested sending this as an RFC in
https://bugzilla.kernel.org/show_bug.cgi?id=221868
---
 net/mac80211/mlme.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6ec45a9f7..b3704b6e8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9207,8 +9207,13 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 * the response to be received and processed first.
 			 */
 			if (status_acked) {
+				/*
+				 * Some APs need ~200 ms to respond (seen with
+				 * MLO) and treat a retried request as a new
+				 * association, so don't retry too early.
+				 */
 				ifmgd->assoc_data->timeout =
-					jiffies + IEEE80211_ASSOC_TIMEOUT_SHORT;
+					jiffies + IEEE80211_ASSOC_TIMEOUT_LONG;
 				run_again(sdata, ifmgd->assoc_data->timeout);
 			} else {
 				ifmgd->assoc_data->timeout = jiffies - 1;

---
base-commit: fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
change-id: 20261011-assoc-timeout-rfc-963b2d62900a

Best regards,
-- 
Momo Chiyoda <risingnusun@gmail.com>


