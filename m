Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A49C351C3E;
	Fri, 27 Mar 2026 10:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774608477; cv=none; b=L0WjTx3tXYr4FThXAHDI+tNWMZaYge0SpoDKVSwTsAqNW/bsRNym5SXVKAoP7FkhmhpUV8XL9yq5pTaUx3aokfk789vD3cYdeRTLjqwiwHkoStN/gB4tLYigIGAcJOcdUKdIiIUlSEFuHZ1/CH8sN9xJJUrq69/7CtpTLTgBC4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774608477; c=relaxed/simple;
	bh=EY+zApDmLCojDGrospVJyoGtGtB/mFNCfZFnX5EpXno=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qj45YKhuWGV7PcY0g6tMB1VFSVfJqbA8bXXCt4zfVvwxiuwmpjmN5whG3yHwFpcoodxkOUlVJujmFKE6AS+fHkmDHwGJNsEJ5Y1+RlilE9i5Nnt89i7UbwngklEgB1FMm/psIYjPi8ENxYiyMswWKxxskDitzXFrMl/WE7zg9ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1JYJtXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1JYJtXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98197C19423;
	Fri, 27 Mar 2026 10:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774608476;
	bh=EY+zApDmLCojDGrospVJyoGtGtB/mFNCfZFnX5EpXno=;
	h=From:To:Cc:Subject:Date:From;
	b=a1JYJtXMJ5pzHCPyty+gsN9EsuWIUkkKwtTTUvYsDKbvi8zoQTEHMLD6d+/txQ8VU
	 oDWclszowchsZ9M1WGL9o3lG+ypaYob1rrBSS7/Afo7aeuUj7fFOuNNUZRhSZriD75
	 DxtKJGBC6HMrYWhQhean9mv0eW+8QAZAwLvBvuMSwXe3169YOALUNJr0Zz+mvKY3KP
	 WPOPmyez8XWNV+n/nAMKAA5TyYaFcnieMYNQSpvQQUanqhep2zur5SsOBknes6dwFL
	 30IPHITnItqlEOM0dGioBO1vnhqSPFca99UFrgXFY8nbhHrtGfsCg0HQwfPPRtWSgr
	 woGTjwJiva7sw==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1w64jK-00000005Ut5-1mpV;
	Fri, 27 Mar 2026 11:47:54 +0100
From: Johan Hovold <johan@kernel.org>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>,
	stable@vger.kernel.org,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Subject: [PATCH] wifi: rt2x00usb: fix devres lifetime
Date: Fri, 27 Mar 2026 11:47:26 +0100
Message-ID: <20260327104726.1310327-1-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the USB anchor lifetime so that it is released on driver unbind.

Fixes: 9f2d3eae88d2 ("can: ucan: add driver for Theobroma Systems UCAN devices")
Cc: stable@vger.kernel.org	# 4.19
Cc: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 83d00b6baf64..174d89b0b1d7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -826,7 +826,7 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	if (retval)
 		goto exit_free_device;
 
-	rt2x00dev->anchor = devm_kmalloc(&usb_dev->dev,
+	rt2x00dev->anchor = devm_kmalloc(&usb_intf->dev,
 					sizeof(struct usb_anchor),
 					GFP_KERNEL);
 	if (!rt2x00dev->anchor) {
-- 
2.52.0

