Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676922;
	b=VpJ3SaM6MU+ieu+1zzs3sBAy8W/myAmZG69/83rqo3/sCcGyV6a0SJVbeZqDNmmTPtfI
	 gp6N4RtickiLp7Z00A4/3H/Rq3b3SoXsJaSkl/5V0Gbc8AC7m6ZmRXGskdFmNRME+DBuq
	 QY+JqsEagJHseEa2gdLf/FUiU/rgz20Lr2BoBnuhuq7Ayu/9InXHjimBeYvfT0FszdJ0o
	 gLR0anx7v79XvUR2LWSB/T4J1p5MG3bzdoz7n1VhEhhaP8QhWJvDkDPByfkkYejI0nl6+
	 pLKCI/M3WbtKFSUJke5P18pxSKC8yQfOQ8pNndRIUQ51famVNCfaYD772N5ceO7zmaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676922;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=4uA49ef9muVRlHqAtrsTS4CYgc+PPnnVYcR80HgZwss=;
	b=p3MojzggGL/1zWQBjxleObw/E8Oa7k5NIz+bSpbAbKkox+Fa38t0bBW41iRs7oRdjkcI
	 K7xm+Ei60HZg0UEvIScGQwqOH62hMnOMN5OSEEitRNzawwn7BQgG9OX29kpmVgmARMDBM
	 BJ/dWSvNEuX+8njqYx7p0Yqdb+u/kVQBq92VRYFTOroLj7lPb4yR+jlFDYjuapE7m1ZxB
	 RiNjoFIPRs4YNEtRNeAkOmSI07r3MYGkv9U4qnt6Pui9CSlQwSnhymrhW37Zzhj0ol6Oi
	 L2ggKHsSp8KJ+314fruR4ajqtZbSWiBbbAilbNq2G8mcbY1eQ4M6PMAv/16RLGIIRkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fzsuPfw2;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18372606A324;
	Tue,  3 Nov 2026 03:35:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18372606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=fzsuPfw2
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33ZHFr82703608, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793676917; bh=4uA49ef9muVRlHqAtrsTS4CYgc+PPnnVYcR80HgZwss=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=fzsuPfw2q3Wz1+TSdoICoha24ZUwQ1/zLuMGVIo4GdO21CuiGj00ngwqi14Zy1SP9
	 mjG6ZqzQUeJdy6qDEboGev8AiN8wldYbQnkK4a5n7bua26Lqb4BUpitUslmmLov+Dz
	 Gc4xoiTUw6ZgnT9sCmkheb0R59l0uRqZtZyYQ4WzVdEA+Vo7M7i29L249PJ0EL3WzE
	 j8ZuqDEacXtBlXED0Bp2uqEt6gA8qzY/GNW+GHXg2lFt0cqutxN4oJLz0zEIS3z2XV
	 hcZBT0tVy2RdVVMkjRWfnCOl3VJcbH6OYhB5ZzXvI5vUk9Evb9x4uW7L+E09VgTndL
	 hwZb3Af4fXAaw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33ZHFr82703608
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:35:17 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:35:17 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:35:17 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:35:12 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hungyu Lin <dennylin0707@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<reza1234khan1234@gmail.com>, Hungyu Lin <dennylin0707@gmail.com>
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
In-Reply-To: <20261019165103.5990-1-dennylin0707@gmail.com>
References: <20261019165103.5990-1-dennylin0707@gmail.com>
Message-ID: <664184db-a543-4cb5-9113-06f50525282c@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:35:12 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Hungyu Lin <dennylin0707@gmail.com> wrote:

> rtw_ops_set_key() looks for a free CAM entry before checking the
> command. When all pairwise entries are in use, DISABLE_KEY returns
> -ENOSPC without clearing the existing entry.
> 
> Move the allocation and bounds check into SET_KEY. DISABLE_KEY uses
> the existing key->hw_key_idx.
> 
> Fixes: 10d58823cb44 ("wifi: rtw88: fix out-of-bounds CAM write when key table is full")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Tested-by: Imtiyaz Parvez <reza1234khan1234@gmail.com>
> Tested-by: Imtiyaz Parvez <reza1234khan1234@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

b60ee9891e40 wifi: rtw88: allow key removal when the CAM table is full

---
https://github.com/pkshih/rtw.git

