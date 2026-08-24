Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA36459AFF
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787586232; cv=none; b=XsWiNgqYFSho9UELAU+5Jt2X0/a3rP7DFcXLjgFRnyrPrwu4X2g+JnMwcXBiZxvp6Y3uu2P3Oomn44CfBXz24BpMOZeDFYat85qvz8a7SSM7Po3ilunftUhMAB8rFdrCKbPZmzQH4/KWQuFE0ilELhXiI4/fPJUqhVKexfWb6Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787586232; c=relaxed/simple;
	bh=HhTDr6LdKbqjS7T4pxiNEPUA2fjb3YuiIILv6oehXMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oh7jIBy6kRAetXIL95Zo3qujzyNvfYHVsVekjMvTCnc1NzgS0F1Sta0WrjR7L+0aadKzyZnGqBdHfoMJ68nt8cfEKdpULSBMjoeuJ3LxrsDHP7dUmLAu2RJJXaIU/6JpHgyRUoBQX/DDaewj3cKf+1bj89JvDFglu3N13aR/etI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=aQ07CKpq; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="aQ07CKpq"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1f758014b8so395854866b.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 08:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787586226; x=1788191026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HhTDr6LdKbqjS7T4pxiNEPUA2fjb3YuiIILv6oehXMw=;
        b=aQ07CKpqoq5EM5FsPMO/haK5Gn1mqQBREJaduqBAtJAGlAbB3ANdCDh4sv+RmfvI3R
         gs6SnfXQlinw7WLKidCCg7qRMZpZmxJKz62g1S/NQYHr3zZUXb21kuKdqAzswhffdDRe
         lS9kzjTBbNj/UeZq+TByHEXXyYvjrXGaUY4rLFycTOXJ6XGi6o42VYWMXi2fQyUGoL90
         b/ivmovLZSLmqn/AFzfEImGoZaTrXmXznlWpyuJikOjousqzF8Sj9S9GP6EbG/6oE7AL
         JLr25jz1rSGotEuHngLd75fwYPeTel12fa5tcTJLzR1dof3g3b+i5LohmEGiS331atyK
         20Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787586226; x=1788191026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HhTDr6LdKbqjS7T4pxiNEPUA2fjb3YuiIILv6oehXMw=;
        b=etVtdWWvbTF5vnxRM589/5ERL2q0lrwyjzYzGA5uI9IvhhsO/lMIEE3ZooiwXGXFQr
         kJUXE8OKCxZDAOycXXlNd76pEKUjUbTPMpoUVbC9iC+xb/55Ol8mhC5lz2avbItarcOo
         0Cctd4JD8ul27x4NTYm5BzXVQFNGCZn0RF1FDA4jqkxGf2aErzFsRe3rpPzMoNo3Zw+y
         C9P7vngHdq3t6WW/Asrgiw7lv8LggSXDCgZp7bB3rgn79ga4v7OGosdlemTa8RdPMPWH
         iKxE91ho9byJ26/kaLXAhM2O0UtOqib6OCT3OuBGHW8hk3oiDmLPsUdIDNRulTRgjqFk
         jaoA==
X-Gm-Message-State: AFuF++llRUvV9XYUfszaz973qfL94PU7F6JTf+vom9/4shxuHvIndYtB
	+CULliaZulQCYbVT9oKH9SNvxXlL4Td2zI3edxo5Tc9TcD7XbJALAhhlRnE0z3/NvA==
X-Gm-Gg: AR+sD13piq5Q/GbKuZvaJK+2ow6GrpwXelg0P3ODj4dVbe2AhVmFVG/tS/a8ANNNmAu
	ILrcuxYgkJJdQNwwTiZLzn1GmedYLBziN7VOdRX5GyfBlYncjP2DcHPYUmfRbLRY6KCkx8iV9sU
	Um5Og8FXEMN9EFzhnsINzWFvzzycZYD9QY3O1XA6iOkaEs1IDMEf8nv22rw6idfIihgblxItsGa
	MdhrBjir/G0TqKVrlHenvpEJ5VuzqKdNLQgsMybvcYRVEE0+P3xhQkiIlS3py+Y3RVIEyfsvmhQ
	DKR6YIbSWe3Z+Kbh407VDuZ29d7aMpwJEiZhPvFxfIq+J7lIji1rRk5xz3WLRQltIWrXn/0xhmR
	/smYb7+UoH9QackniI7EH5jYGNSTQEAJIBGIABZC4VIM1fbjpKcdmRH5amAl+pb8EYH/l8GLRcz
	93ipa29fn+WCzDb/1M9DlQw+xXILO5GSV0QpMH6b2t81iqN8vg5JpAfs7fe8Ke2h2HzAD7jMXJu
	J2b7FKPHgQflEk6qgJJ3R3O9251fs2yPHRjhSvnzGLkTLzJNy4jiGxNcWdrT3aXRqt5a9tIMovS
	ZGpYZb0DAGzvqThtNCUe0L/7AYiylmnvtvgGMzfIbQ3L/TMhdzMbQUbk7G+3o0eFxUWsVv0zmAQ
	KJt6uoU4e2NT1wFI8eWDGIWnEe1evY3wPeF+QIdKblEyl2UuFcWBshyNKTvUkx2/0fxSJ66wk
X-Received: by 2002:a17:907:7283:b0:c24:b11a:470f with SMTP id a640c23a62f3a-c24b11a493emr1268153266b.0.1787586226444;
        Mon, 24 Aug 2026 08:43:46 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24966f99basm1270182366b.37.2026.08.24.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 08:43:45 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: Re: [PATCH ath-next v3 1/9] wifi: ath11k: free tx skbs through ieee80211_free_txskb()
Date: Mon, 24 Aug 2026 17:41:48 +0200
Message-ID: <20260824154306.2277246-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824142350.1757379-2-julius@bairaktaris.de>
References: <20260824142350.1757379-2-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

+Cc Sven, Vasanthakumar and John, whom get_maintainer flags for the
lines this patch touches; they were missed on Cc for v1-v3.
