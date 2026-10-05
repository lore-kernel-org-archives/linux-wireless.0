Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DAD4A9D49
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211369; cv=none; b=kdVIyAjqZzVeSZef7RkFdCG5E1P2jKeyG9RRPYEAdv1a6Mm7WdtnDQNlp8VUTVHiYHvb0oxTXTYMJHhsWkuubMtFo0u//o5JkUhfdV6HexS8xRZAJuY5CruG6r48gUYm5Gk1P+PZ+GtaSokG58ja5y35iihm8HDGMKY8iRm4dfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211369; c=relaxed/simple;
	bh=I+VMziVza2uwKu/H/BBZhFCvPqZ9uw075TZ4mZkkwXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYNHIaYCqn49NWPHuzckoLYaVnUgB+4dHHWrw0P0PruScedLzJejFZM7zPYerL+iHJMVX/IbZhJafuWNQz3pqbqG9yQudYYWcWs5Q5TOAYKaOG+cM39zHxJnKTeWISfEh5CUBWZr15mQdi+1RMf2qtPqeRxWagv0NnyzhJrHTIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZRtr4cw9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZRtr4cw9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso9803305e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 07:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791211359; x=1791816159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I+VMziVza2uwKu/H/BBZhFCvPqZ9uw075TZ4mZkkwXA=;
        b=ZRtr4cw9NiUKdajOn9s34/CBxNZw+nlytDqYPPgQYCWVaGGLWrB7kdbc3QZ9RGhSYj
         W+NkOzJI3bj/VR/w796if8aRJZIoWRRsaVz27YEFe1LTPEZRtEgeC3eNJK5WrmyhhIzi
         cPf6/NNMjdH4l2p1VujusJeaynpUCf6LEJBhDOe5PKcCzvCtWxk4V9iEnjmeKURm5X1c
         mHE/uyxS74DOmvLhKqhySjvkjf4+tL2EqMeaoXM7MzA9WBzn7f4GSX6mosmnjMmnQUDl
         zSkcDhNQUTCciNC25pUa9YMwPYvEQktTJ7nIUDyyK+y6VuUbWpj4TcUqWTdsN7YuM6xj
         k+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791211359; x=1791816159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I+VMziVza2uwKu/H/BBZhFCvPqZ9uw075TZ4mZkkwXA=;
        b=uCIAFgXVvq/EWSQAMszQpGDwuKPblYWYFmx+xfnv31JXt3HyvSck/j3iP9fNDCZgum
         SsQFEm1wpoInVTkuvpB2vLa9Qx4CxVRe9dPmbQ9qHlPQf1MQbWiRR3dXzoVp1fvtqOvT
         noxkM1ttsOzWvgxYBeptPblICnBbHhdD7xl9+bZyQIb9xPUpd0Ozpa2Zs0iG/ZxFPYl4
         3WoqjuWmoht5t3WBItBfd4b809QNrGE4wV4m09M4DywgWslBqXlYV7uM7y7JtmuU9DOk
         jgkXTX0HaE0FNJv7L4MgTCcNpUzwVhInXlP6R4ZVYEfsDece190r4VuRJv3QxNe7iX+2
         J92Q==
X-Forwarded-Encrypted: i=1; AKwUvByFLeVlaEDsm+pgn9+24rP17ulqIW9xYjGIAeQoByX8QYz8j6gYjJtfvgOO6Nzcypmuaoxg/MwiaqcJRExWMQ==@vger.kernel.org
X-Gm-Message-State: AFuF++ly7wHtMsOEIGULfYJf5x0Nf9lszaAVYKvGGw6w4ztkub08d1zP
	yAQmGMejDpbs+xd9w2fZM2Olq0H/gVTG1NA/zWATBe5O87A1Y4SNAPUf
X-Gm-Gg: AYBFou2oz23dbeIeyByx+iJ79MxRYG/rKxxeKtIik9c3KKowTFQH49wDIG81HHHYLkU
	/AYmak0RfFZBdqjZiByQD5iwv9YCNzqsSEezBicY7z0T7yXXJcLBnfnczWO6EuxQ//c0tSLudBP
	wF6bI9/7HwyHgZyENLzrGZfRD1led5jP0PEUdQiUuPvRKI4KLjng2kUXZVUTLTW9hYJbLvBlpHd
	z7mDDQC5uWGLz+YbPIButzXB886GpE8KI6PXNz89yioeQlRdK/Emrq9OtXUHpRENo8TRQiq1GRZ
	d8zQn4v7DGnu1CgX5JYNKG/RRQNAfbPgX4HEALrJd2VA0a1B6uzL81Uc7tJVLn4nQe3aKFqrtpr
	uBxQxmkqmaHgeqT7Bt4idZhSHgps/UMO6qyUQuXppWNGSogOC8dItHgoKKPiV3sD9mu2D7/Sr+H
	c8E2V0SYUyEuAGlhLdYIUoCNjuJ1zb18Uo7tM27zJv7SfbUJOHG7OrP34OgZvnCG2EkQdJcOyaS
	so6
X-Received: by 2002:a05:600c:1d07:b0:49f:cbf1:e765 with SMTP id 5b1f17b1804b1-4a168068ef8mr122155045e9.0.1791211359246;
        Mon, 05 Oct 2026 07:42:39 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a02752aeb3sm359490185e9.0.2026.10.05.07.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 07:42:38 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Date: Mon,  5 Oct 2026 16:42:37 +0200
Message-ID: <20261005144237.132627-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005143313.129670-1-mehmet.fide@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series went out twice within two minutes, a slip in my send script;
the two copies are identical. Please take the second one,
<20261005143523.130287-1-mehmet.fide@gmail.com>, and ignore this thread.
Sorry for the noise.

Mehmet
