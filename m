Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905A24F4D14
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898613; cv=none; b=P5UrS5JwPH3/WR7fFYHBogFz6/5ddd4IiMM2smRaL7zWBLN08iVjO/MXphv8vn2SgSbaKFGHli/BVAVcbjPY2IyyoOSkFyTLWDea77Gf9GCt2+igMshJaPDrYpg9+TBr4eHSYsfjTTYGkjvYJiFL3WJm0Rg+eAfdVK1MsYq4e9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898613; c=relaxed/simple;
	bh=uKg+2jJ6/5ViBHzmi1HAxNU6iGulD9qiT+fDz5Y4ohs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UF+ACFhURHL0VSpcgMLH11b+BzhWeMEWWiY1Qa5D6rEDLvulLQr1z/mAxyHWzLKlApRaaqkWnusbsHiH1PZnHb7FLMY9jzans9REY4Kgy3ynDDmg38jZiM7qM46vwZ0QQVgXyCCxmav7IV71K4hXjQyiaozQdTN5VSqqIfPm0ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PhyI9Bc1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PhyI9Bc1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=uKg+2jJ6/5ViBHzmi1HAxNU6iGulD9qiT+fDz5Y4ohs=; t=1791898611; x=1793108211; 
	b=PhyI9Bc1DDLnGynT69L12oT29QIXyYjAlfK6r34JvPSlRAzQRdMF8A/YyKh4uKcBw8ZYsl1WEal
	2ZagFUI2V4S6AyEiWdGtDu6fan9LWuUpabqiUdhG++YuXo+r1nG0yVoDbrWTvudN5rfcwyFJstzhG
	j/yEmgJ1X56UmXqXVvqyPX+WJYcXrAhTqjdXjyQt0mcb9r1hFy9WlWj55p2PQIQUIHcklFEQjeAbs
	3GMXV6167H3Pr0wGSwzFXwx79O8Rs+X8T6VrTu/CU7UhCaWEWhS2Hol+25WgB6nBfFeHZ0p7nxhI+
	ND6BKBmCkKTvMepDe3UpI9tquB+/QfwxoGlQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgN-0000000HRBK-1SQp
	for linux-wireless@vger.kernel.org;
	Tue, 13 Oct 2026 15:36:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 00/10] wifi: UHR updates
Date: Tue, 13 Oct 2026 15:25:12 +0200
Message-ID: <20261013133640.270974-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While looking through what's needed for SMD Transition I found that
I still have some collected updates for D2.0, missing features and
just bugs in the existing UHR implementation.

johannes

