Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E4948E0F4
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 07:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790840263; cv=none; b=IZS0c3j7Ps419bLv///ry+SxhX3uu8GBWhWqOKK+LN15QStKTyyctv7fvEkDli1CLVYeeuce9riVSlp4XxJNnwNxw6/frm8Ni5QmXoU/gXXRhr/wjeFiz+vMe//0hF8zdWrYnLu1w+9VwwSDUhgUTzQusfqqpqrA14Unt/bFS+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790840263; c=relaxed/simple;
	bh=5PFIbh3eDdhQjUnbfiSfXkew41IVq3oenFWuGyTLgns=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QQgR0crjkdWUvkAa/rpv9vzGyeUp2BoEFvL/2d3NeDIrHxz4F7jdCuVH0dshKsH/QaGndbHAqqYIB8aeZZNCLDDOwqIL+VrsCnyb0+H/NJQ7zCNuqrvl/r4Uo+omx0glxkvcLjYOMNRM2+Ku5n/PZ9Nhkz8Uk8ohWrIRW6HX7QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qln76CWH; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qln76CWH"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e3507d4a9so85164966b.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 00:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790840260; x=1791445060; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WF+NPJiXy9Vnmi5WHh+QYbvLk/ut+YzrNBY7oFb/Eyc=;
        b=qln76CWHMJERoBNe3fgRKzv1gP92aA18sucD9L3nmym9AhPmSEv1IuFVnQUKc7qbSt
         Fe2dkdKrJT8g2DbkSpDNZzD715auE/760uyzWUce34dgud1/eoUlItT0wJcDguDJnHMl
         kZC24LoC0Qfwmvnay7K2fR9ZRzhsxM/KKXN5mGVZktU3MimxLARbEB5EaSCshiztn5R1
         /UN7+Dogf8OGwLwCo+E8LueqagQi54/oTUp/32ReuxhnfpmOmDaLJ7SToLhMWGV8f+56
         jnIidPfbiPdW69ZEwBdc+1uX0jZkquqf8cFBHqJDQhJ8DcP2Fuh4iAipVW5a9L3aQe1o
         Zg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790840260; x=1791445060;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WF+NPJiXy9Vnmi5WHh+QYbvLk/ut+YzrNBY7oFb/Eyc=;
        b=dFfpcrRT7tUQfZ6/MnKq3ukoMdenej/CWmaw8e0iqwQJJIjSqrrb1vc3qY84J0mFDK
         j983cXRSXo29WBEVZMgpaqtU+koHDDbNOsgoDEU3+32bITPl0ySW5La8o3vfIED5JinA
         o5Cs/5CXbOzlp3R429CwXvm34EW+b7Jll6BoLLBI4FM2aw2fb0KX9xCs+fLvWmB0mkCw
         a1yP5qLdb/DgnCt57wIt65OKAO9/rgwwCqBLNxjTzhxD/PgpbcyQSlr9RHAzt8my/kue
         mjbN8aRF2u76Vmfk8/Vhwv8fiB2YEztxQ5BpoPl/qUQulGbt1C0sAAfwXAfL3A/fNAmv
         MOUg==
X-Gm-Message-State: AFuF++kjiQosU1J8JtPbQyDzdmYxi5x8hKN0vCc+fYplunkeUwnF1OJn
	TK1nBmthXMIZfx7YcgVeLlxqDlh5KmkrkxMBK7yC9GRuQ85PEm3bEKWgoH8mFAy0y1enPw==
X-Gm-Gg: AYBFou2OsQksCEp41ZZBCx54v/nmjaOkWfNov4v6qrwZGMyaLfW4W6sUd+wUJGCxK5C
	BhY+oQoImVqV0iqaFkoUVtlsqptw8cO730BSjsaWECc3fZjwwNatI24h4m4M0sXo1U9AbSNPYG3
	20HN4AVYhxh9Y7wJRbzrkRG9Ux88vj4/ATDzQTCGk4wlTFCJpZVL7sMs3h2rxDxOP/F4TXO5ZJy
	xwDUEIiP09L2OiMV9pxyocugDBXgeU2gwG0T2uTBdAI+f4h9c0+gFt1TzsbVpCjpCIHQz/IfOLy
	Vp8/ztH3rWueYWFeHw+Wl982jOzbzkv8YYRZJAch/Es5gHkgsFXH9pMX8PK3CZVrOlRgUy6/diy
	ArRixhv2GLzp46KVHIgx2JlxKHAL3YrKOvhsbGQijqmoBkY+CH7FaDk0DKgN0ymL5PAw+6d0V70
	R4fDl5bae7RiaylLKJYlp+KiBDGnBd9XqasI7E8e6MqS/X89Io0ZLpPPBF5St1MsRGjp4=
X-Received: by 2002:a17:906:478d:b0:c2d:fc0b:551a with SMTP id a640c23a62f3a-c2e233cc313mr310528166b.0.1790840259645;
        Thu, 01 Oct 2026 00:37:39 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d36795sm97826266b.38.2026.10.01.00.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 00:37:39 -0700 (PDT)
Date: Thu, 1 Oct 2026 10:37:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	b43-dev@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] wifi: NULL terminate some user strings
Message-ID: <cover.1790839793.git.error27@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

These strings come from the user and they need to be NUL terminated.

Dan Carpenter (3):
  wifi: b43: don't pass unterminated string to sscanf()
  wifi: b43legacy: debugfs: NUL terminate string in debugfs
  wifi: carl9170: NUL terminate string in debugfs

 drivers/net/wireless/ath/carl9170/debug.c         | 5 +++--
 drivers/net/wireless/broadcom/b43/debugfs.c       | 2 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.53.0

