Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234353FA5E4;
	Thu, 30 Apr 2026 08:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777538034; cv=none; b=M2zGhlGJyL4vkpW6zj6rHsPskgpDSU6Qko3svgerf0jjU77rVxEcvNmiZ9rjMzn4FdLBpijz0IBhs5cdQwAA+hI7vU15w3L8f6JjceQfXFwL46AHNVfpnNxCfHlF9sSpJqdN5b5iXdWbpyNGoZLzMtioozTqaftTrf2jNuwRntY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777538034; c=relaxed/simple;
	bh=YO7Gtjp7Rhq78Vi+kItsnH71DQJHJ1pnJYYDbxGMe+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1j7MMQ/cl12nbfCNh2I4OMj23SuURovIrP/tqaPtJFROq6sstk70WiwzAOEYnRGXc19yW9VTa4xFJmII7llpDfiNiJaGB8xXD+ztECYN0VRhs+bDlXffRjFgkCgiFGH0NVqgz4v0ykHbf8T+GwOh9tibjMrHt7VivuSG7htLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDOXNcIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDOXNcIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C1DC2BCB3;
	Thu, 30 Apr 2026 08:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777538033;
	bh=YO7Gtjp7Rhq78Vi+kItsnH71DQJHJ1pnJYYDbxGMe+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDOXNcISNwOHmdvjlAuVgXfVejMPGwgZhctG7cnr1733J9TkluzPNLKuOiol1A+nK
	 9Lcb4TnpLjLGPlV+F6i8TPap6JNINJUd1VeTGDSZYGqB1W1QZFl80KHyQZoOQL4SsP
	 A6rtTtfIr13/i4EqUF4T+IIuplgXc+mqk3FJZRcn7MzoDSjMidJd0fTO2WzhSK9lM5
	 2NFutflm4mgYKNZgBf2TwAIfGwWpF9lbvNi+rB5ntnUJ26hjwbWfR5lHQxTLVsQ49U
	 Z0Rl1FU1aT62b1B+H4jUqFh2AFe6/fRs6LrtB90TNLMx4GF5DsDYcFCUA4dptTI6Xa
	 adGmtl/Qk28MQ==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1wIMqF-00000000u0C-1oJe;
	Thu, 30 Apr 2026 10:33:51 +0200
From: Johan Hovold <johan@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 RESEND 2/5] wifi: mt76x0u: drop redundant device reference
Date: Thu, 30 Apr 2026 10:33:32 +0200
Message-ID: <20260430083335.215239-3-johan@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260430083335.215239-1-johan@kernel.org>
References: <20260430083335.215239-1-johan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

Drop the redundant device reference to reduce cargo culting, make it
easier to spot drivers where an extra reference is needed, and reduce
the risk of memory leaks when drivers fail to release it.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 90e5666c0857..2acce121fb14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -245,7 +245,6 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	if (id->driver_info)
 		dev->no_2ghz = true;
 
-	usb_dev = usb_get_dev(usb_dev);
 	usb_reset_device(usb_dev);
 
 	usb_set_intfdata(usb_intf, dev);
@@ -284,7 +283,6 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 
 err:
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 	mt76u_queues_deinit(&dev->mt76);
 	mt76_free_device(&dev->mt76);
 
@@ -303,7 +301,6 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
 	mt76x0u_cleanup(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
-	usb_put_dev(interface_to_usbdev(usb_intf));
 
 	mt76_free_device(&dev->mt76);
 }
-- 
2.53.0

