Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CA9299920;
	Mon, 19 Oct 2026 01:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373564; cv=none; b=O4Aw5690VGnR621xJraSF0RdOdZWDo75HA+6D7brF640OjnHlj5t0HPsjwInahyM+bi4zvc5D8PaXTLsFsuoSSwkgIRxD0sCnhPciVukG0PCptImVUOr/w+811t0xa6AAS5OKmrdY+zwtGKz/e8zVr9UWFH2puRx6jdWQQDXz5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373564; c=relaxed/simple;
	bh=A+PTOFvFqONkMEzdXaWWUnmokU/BiLBP+VkM88wYkxo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Brr+sAJOCuYETX62OytHxxURjlghhhzkI+MiAYKPkBX3nKUvtHYsbtlsXnr0XM6bpcnTB+fGOpvtQB0M7nIJDiFq/SkpFYYcNKdh0WVH9wGA/bsDNI2QSAe3RGZkQApWwMsiGlofrNCzuhUWf7wlrvj0W0fjbckmMfKUwf3BXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ILgIeEMy; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ILgIeEMy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=up
	XqkTsQowjQwqpni2Xypm7gQtMweXqMFvfW78bVeUI=; b=ILgIeEMyBXrzzef+rs
	1tHqF6Zd23XV9QAgd+SXTANR+8ZcgJAzK+MiX4U8VrpDjBYrhFgE1+BfEQfhnBVB
	wQFQvioXkWJLr48H0PTW3MnAk2AKLQenc/iRdnrAywsUKd7t8+8QO/AQpyqJxGEJ
	7gBPgtRF7dRoHbfpkTwfYwxLA=
Received: from pc.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgB3sQgpc9VqLZuVAg--.15458S2;
	Mon, 19 Oct 2026 09:32:26 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 0/2] wifi: ti: unwind failed interface additions
Date: Mon, 19 Oct 2026 09:32:22 +0800
Message-Id: <20261019013224.1489500-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgB3sQgpc9VqLZuVAg--.15458S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruFyrAF4xJrWkKF1UGF17ZFb_yoW3tFc_GF
	W8WF97Jwn7XFZ8KFyUCr13u3yF9FW8K3WxCFsrtrWxtrW7X343Krn0vFy3Zr1xWF4xtFn8
	Jw13Xa1F93ZF9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRtKZX5UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgr2MWrVcyqfiwAA3x

mac80211 does not call remove_interface after add_interface returns an
error. Both wl1251 and wlcore retain state or resources acquired before
fallible setup operations, so a failed add can affect later interface
requests or leak firmware and host resources.

Make both add paths failure-atomic. The first patch delays publication
of the wl1251 vif and restores the previous interface state. The second
patch releases wlcore per-vif allocations and disables firmware roles
when later setup fails.

Jiale Yao (2):
  wifi: wl1251: unwind failed interface additions
  wifi: wlcore: unwind failed interface additions

 drivers/net/wireless/ti/wl1251/main.c | 17 +++++--
 drivers/net/wireless/ti/wlcore/main.c | 66 +++++++++++++++++----------
 2 files changed, 56 insertions(+), 27 deletions(-)

-- 
2.34.1

