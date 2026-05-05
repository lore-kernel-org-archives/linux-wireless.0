Received: from mail-07.mail-europe.com (mail-07.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6F93603EB
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 14:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777991479; cv=none; b=SGAHDwbMN26yGvcZHzmh8f1IMOHSK+POLuDJC+/n8WaaQgSvMp7bv1RVRdXEn/e+eRxOS39RVGUOHVuJdkohr2JF/VZn3WlYvyBg5bHMRjp9xSw91V0ECHdE9JR7dl6MlCaPgudg4JqGes/ab9v7+zfXb+REjgN0DHfDhyoFusg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777991479; c=relaxed/simple;
	bh=RhQuye+2dSRP3iiJJPPGQBZ5I/C8Q3i8fUHS9WyJiZU=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=OMiB6HfNajBSbvzV7aGf3taBQM3jkDqnulbqaTdDhzZ3yzXtdP1a25eqMkluAlibICOpI3ba5VbbaU0jrNFlFxbuJVonGzweO+GBb3p0QtdKx5KPg/Os1SdAJVOsXG/3demcGjE1GBTIFL7UXbRKLTwdaT1E/5zg6ZJ46GxYQL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=met-dubbel-l.nl; spf=pass smtp.mailfrom=met-dubbel-l.nl; dkim=pass (2048-bit key) header.d=met-dubbel-l.nl header.i=@met-dubbel-l.nl header.b=H78AhBdB; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=met-dubbel-l.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=met-dubbel-l.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=met-dubbel-l.nl header.i=@met-dubbel-l.nl header.b="H78AhBdB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=met-dubbel-l.nl;
	s=protonmail; t=1777991457; x=1778250657;
	bh=/KyseQicvAhQoRnr9vZMXYYrcYZAuumgn80kI4HgiCc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=H78AhBdBJtmGXQVu9MXrAuUlsNsiNgxlDwOepYB4E9dSh8qwoMTKji9XWXKblr4Ti
	 tExgM88R0J0ozJj6q6Phubh9QB1/CW2/Z2GwdhlwImXnYvQTIv7Ql5vX/s/mKaxFmq
	 7QLV6NkVMB8mHjRT4Zt9ua2NoYT+BTPS5RrHl0ocq69Go9v2NWc9WzZTUUe025JO/U
	 f8gzgoPCfFr/1xXwacFbLCVXNN2sVJYyPQ/N7agTKfIHXKATXM6iyQSvewKaNNKgfB
	 vk1axkGCNKU02QCAqcpp8bOYYBC4PWwJY4BwxKnOybHZD9fVcn691skB/8JUYyF26x
	 3U5GwGYyq5VfA==
Date: Tue, 05 May 2026 14:30:50 +0000
To: jjohnson@kernel.org
From: Willmar Knikker <willmar@met-dubbel-l.nl>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
Subject: [PATCH] wifi: ath11k: fix use after free in ath11k_dp_rx_msdu_coalesce.
Message-ID: <20260505143025.234292-1-willmar@met-dubbel-l.nl>
Feedback-ID: 179140708:user:proton
X-Pm-Message-ID: 66a23df030ae86d941826c72772648a86dd64969
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

In ath11k_dp_rx_msdu_coalesce the loop uses ->is_continuation after
the dev_kfree_skb_any. This can cause a use after free kfence.

Move the use after the dev_kfree_skb_any after use of ->is_continuation
inline with the while in the while loop above this one.

Signed-off-by: Willmar Knikker <willmar@met-dubbel-l.nl>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless=
/ath/ath11k/dp_rx.c
index fe79109adc70..02bd9787d6b4 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1825,11 +1825,12 @@ static int ath11k_dp_rx_msdu_coalesce(struct ath11k=
 *ar,
 =09=09skb_pull(skb, hal_rx_desc_sz);
 =09=09skb_copy_from_linear_data(skb, skb_put(first, buf_len),
 =09=09=09=09=09  buf_len);
-=09=09dev_kfree_skb_any(skb);
-
 =09=09rem_len -=3D buf_len;
-=09=09if (!rxcb->is_continuation)
+=09=09if (!rxcb->is_continuation) {
+=09=09=09dev_kfree_skb_any(skb);
 =09=09=09break;
+=09=09}
+=09=09dev_kfree_skb_any(skb);
 =09}
=20
 =09return 0;
--=20
2.54.0


