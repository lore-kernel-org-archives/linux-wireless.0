Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565449;
	b=YVGDaZLtrgRaAQtvLxiNsaOLIzwO/slxuSr8FeMt9UXyugg36RgAjXhqu0T4nsRK8KTR
	 U+F/48r+2J6ExoY5Okei98vZBgKdmNQ3QHatcwCl7Lrw4LJMXM3j7zoGN4LoCeuufrcK5
	 Gztu6FG6u5IKxskGKBN9m9Orl7yrrqcRGnAVfTHLrz+0hRoJBdmDBdnDhDm/2dzkJL1LI
	 n2CXKs2C+dwEYoos1rVpl9PLjpb5TGoOcqZSEIOjfwN/98eCj9yQWxI5stGpQ79QoTpep
	 UazItGRSpcOQWhJXznnn0+qlJ5fAZl4YC1s/Zzbw+kUGvTe8SgEz6i5SKUTVB7nMKdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565449;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=CdvzC7jyi6EVZj3hz0ypTrm0LGiQW5rjVEzapNaDSYk=;
	b=r55kmJEckX2TczcMG5iN/nEH5tGskc+OnuCteUQrwgES0ZVbn3YGfB5FT+yZ/mxMTn/q
	 oYH7LTKgffgfEyHhbBzZ4AcDQTx4GYZ3ttJ42lOLb9Gs36PH/fvN6aeDksjvWXUChS2ts
	 8pko3lqQ5X63hIFbVoQaYCgRPDhxkpEBdPjCnz2TvCM946fwybznW4MWShBmrLyTeJr/3
	 LxUPZ0jBpnyqvXdoamPt8uHvCuTdli97Fc67+1B9azS45JKjWLlSAgUjkVbuQpL3hRHW5
	 4dofQGGG4vobOO09mVidHUcFuvORqssmQchG9C2eNiPVASfBxa/jzaBs64nwzGTWo/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CnKwNn6j;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D213A606A32C
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D213A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CnKwNn6j
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso15250465e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793565447; x=1794170247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CdvzC7jyi6EVZj3hz0ypTrm0LGiQW5rjVEzapNaDSYk=;
        b=CnKwNn6jN47bRDMTXDOdq7jK+0lagtIA8r7Zcd6MgWfi4mtSlB/5Hyq+vVshAwOIc+
         79WrED3NipPQvN/bG3aiau5yPNnhHsC8l+81Vaj5F+UcNlmCJkh1OMx6gC5HvbiEij3R
         se6YqJtOcLnNZO+psbBMsL7Wlz3KD/ugRW76ukirJzlLAFWRr33I7Q725Fy5J6aacsFV
         yLx0jx170RCyWdeT7OVT+PB752DRpHPknl4cn8Nqa4jT23H0NTHWqqDrlqV7QjNwlUMd
         pxaBrNyhb9Qm/nG5bfUuB14cIjTEzxUMKprSm4dFLCMhn5sCWIi7KrhRv+JC0dSehbBs
         nnog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793565447; x=1794170247;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CdvzC7jyi6EVZj3hz0ypTrm0LGiQW5rjVEzapNaDSYk=;
        b=rbOZZmsTv682FpTDw8ak7WAfN0FviBr04vvICkk2z0Fv/Nb+mFx5ekfAkCKX+W243X
         7MqEVBf4rYHrB3A2v3F4W14PIVy05/KVp/VV0LJraSsnppbvbQ5k/4qvByMoK8s4AnQR
         ooFbspbxjM0XGmau4Jifspfeo4UKjvrFr6jSBVPnN++DE4dbBS8k7z0v6d3FYs8Qwvq5
         ZUEo7VOmS0QBcin7nJ/wfi1zM20V+nSrlzis2sXwivI9O85IQY9WPSY7WEH8mtEuVoDe
         RducNlM22MwD+e6+mPaQ566dYYv9z9ZLsq4bDqbZidzLcZGPjxSgEw3PCo7rKjqcv1xJ
         waeA==
X-Gm-Message-State: AFq9FYJyn597EFKFZPoTLGTaQ5faAWToE7ZBOX0AQZLzXxcGibAyXcW5
	vdoHqxYsi/ytlvr8D/23q5WkFNOyLsssf8B/uuOoGurifSfeOZ2GjEQ2mC2NStvmpBhOTw==
X-Gm-Gg: AYBFou0o+xg02pzSgLTeum40mPXUXT9dz/p5+Er+coy2dN2zXKuSRFjv3uJa5D+zkW1
	+GZLI219rrws/dfTWHV1bDJvd3MhcyFKBgOzro7l9Qt90K2WzY2En6Znmc1OoeeW4wRYYIAJ58i
	408lX36EVkZYH7dxEgg5WGr/s15KIZY290iHUl9yZiFy0RniZZMPAbglKDN77IWPWUmbYVY3FUf
	LHX5PHKemQRa5m84eBlUJAIKihE0jLpkLFkUAweK5SbFn8m2RZOYFDAjXWJMUhFDC1Y/i90CwjF
	ocqX8/FOqU36fzskHOjCfL3JZKQEGjRyqdcVGDDvsu6bx5h5lc8qF8rLDaTGh8IIpkRvCpE5xtn
	1iOKqKpyjDIzV+hAKditmzQgeaHI3ndEj2KzdUdL3lfrl2szgtLteMyztfpa4uAx2z23hhAcVyg
	mGgOdHgErlKh/2dF4/sk9YQCs5muIqun4hSKllwJMG/B+na2qnNo817sLTUbh5xFGagi9cj9SlC
	YdpcZQT3HidhE+zPbxllgTh/zgOBaR5Lwb0AnUfS3700BwuNHFyCcl6idbhGxEm7wYBaist7Zgk
	lIN3gMQuGUCpsD+bKXgY3wfmrQcIs6S7bwugtq/8beWykSbPl74bRMZICOstRNBOwu37Y50TZiN
	j8KwK2FWi1bTY9JcuaNNWWx9nqtVATGRYrpWOYbEqzBQugy7fcGHf+yGOHcuZEv+e8jEANRz2HJ
	KyyULcg18P/MM=
X-Received: by 2002:a05:600c:4e90:b0:4a2:526b:d410 with SMTP id 5b1f17b1804b1-4ac17565fafmr196316085e9.13.1793565446973;
        Sun, 01 Nov 2026 12:37:26 -0800 (PST)
Received: from ADM-D9YH122JTV.home.lan (158-199.dsl.iskon.hr. [89.164.158.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba53d7sm20369990f8f.53.2026.11.01.12.37.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 12:37:25 -0800 (PST)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath12k: accept num_users equal to HTT_PPDU_STATS_MAX_USERS
Date: Sun,  1 Nov 2026 21:37:18 +0100
Message-ID: <20261101203718.60679-1-gsustek@gmail.com>
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

ath12k_htt_pull_ppdu_stats() rejects a PPDU stats message when the
common TLV reports num_users >= HTT_PPDU_STATS_MAX_USERS. The check
guards a loop that iterates i < num_users over user_stats[], which has
HTT_PPDU_STATS_MAX_USERS entries, so num_users equal to
HTT_PPDU_STATS_MAX_USERS stays in bounds. Commit 1bc44a505a22 ("wifi:
ath12k: fix possible out-of-bound read in ath12k_htt_pull_ppdu_stats()")
rejects that value, which is off by one.

QCN9274 firmware WLAN.WBE.1.6-01243 sends num_users 8 in messages that
otherwise parse cleanly. One AP logged the resulting warning 468 times
between 2026-08-17 and 2026-11-01, always with the value 8, and never
logged "Failed to parse tlv":

  HTT PPDU STATS event has unexpected num_users 8, should be smaller than 8

Accept num_users == HTT_PPDU_STATS_MAX_USERS.

Rejecting a message has no functional effect: the PPDU entry stays on
the list, its per-user statistics are applied when it is evicted, and
the only caller ignores the return value. A larger value is therefore
not worth a warning either, so report it at debug level, as done in
"wifi: ath12k: downgrade log level for CE buffer enqueue failure".

Fixes: 1bc44a505a22 ("wifi: ath12k: fix possible out-of-bound read in ath12k_htt_pull_ppdu_stats()")
Signed-off-by: Goran Sustek <gsustek@gmail.com>
---
Notes for reviewers:

The check guards two loops that can never run. Both are gated on
ppdu_info->tlv_bitmap, frame_type, delay_ba and bar_num_users, and the
first also on the per-user delay_ba; none of these is written anywhere
in ath12k, not since the initial driver (2022). The parser that would
fill them (per-user common TLV, MU-BAR user count) was never ported, so
ath12k_copy_to_delay_stats(), ath12k_copy_to_bar() and the peer's
ppdu_stats_delayba/delayba_flag are unreachable as well.

If you prefer, I have a patch ready that removes the loops, the helpers,
the fields and this check instead (about 90 lines, no functional
change). Keeping them only makes sense if delayed block ack accounting
is going to be implemented. In that case the BAR restore loop also
needs a bound (it iterates bar_num_users over user_stats[] unchecked),
and note that the per-user slot finder only uses
HTT_PPDU_STATS_MAX_USERS - 1 slots.

Compile tested only (W=1).

 drivers/net/wireless/ath/ath12k/dp_htt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_htt.c b/drivers/net/wireless/ath/ath12k/dp_htt.c
index 72069640bd38..9a409dd44d98 100644
--- a/drivers/net/wireless/ath/ath12k/dp_htt.c
+++ b/drivers/net/wireless/ath/ath12k/dp_htt.c
@@ -487,12 +487,12 @@ static int ath12k_htt_pull_ppdu_stats(struct ath12k_base *ab,
 		goto exit;
 	}
 
-	if (ppdu_info->ppdu_stats.common.num_users >= HTT_PPDU_STATS_MAX_USERS) {
+	if (ppdu_info->ppdu_stats.common.num_users > HTT_PPDU_STATS_MAX_USERS) {
 		spin_unlock_bh(&dp_pdev->ppdu_list_lock);
-		ath12k_warn(ab,
-			    "HTT PPDU STATS event has unexpected num_users %u, should be smaller than %u\n",
-			    ppdu_info->ppdu_stats.common.num_users,
-			    HTT_PPDU_STATS_MAX_USERS);
+		ath12k_dbg(ab, ATH12K_DBG_DP_HTT,
+			   "HTT PPDU STATS event has unexpected num_users %u, should not exceed %u\n",
+			   ppdu_info->ppdu_stats.common.num_users,
+			   HTT_PPDU_STATS_MAX_USERS);
 		ret = -EINVAL;
 		goto exit;
 	}

base-commit: a3ddbb45768717b5c9f923489387cf55c838d1ad
-- 
2.56.0

