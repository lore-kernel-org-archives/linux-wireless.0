Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B1C319859;
	Fri,  6 Mar 2026 09:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772789543; cv=none; b=c4caEQt/Fc0mBJ54+CK9yrYH/5aHPynYKHet8Twf6zzRnGJnKHvlQpECghLBe7lLzIM8Z2N8pqSJm6yhQDQG0D634zd4zgJrWn0a6ZEz7S9tTnXIkWTckninWVXdXkAR/56H4a+KEtzofMrhDwhcG5e41wFLFrpw+cCuOpsgt6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772789543; c=relaxed/simple;
	bh=02qqFWaE+jZe6qwABrdp99755LU9fsuY7r4hkFBHaDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rLhCJgcojGQRMT6d0Gt3/8SNXSLsnGsrlilmVGRsldQyRSfXUVTjgh/P6nlN78Oil1JJuplycVveCZ+reLBER+LaCTIpbmYey6rMrvi/VfxDUUKlpm6dwmOGMI4NYvQrA8oujC7rV3CnilJR+0hNqu5lbVMUT5Cd0gWJ/al6N0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZFD9MA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZFD9MA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48E6C4CEF7;
	Fri,  6 Mar 2026 09:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772789542;
	bh=02qqFWaE+jZe6qwABrdp99755LU9fsuY7r4hkFBHaDQ=;
	h=From:To:Cc:Subject:Date:From;
	b=PZFD9MA8hLpvEhqDR92GrH8RNbiNkurUVUgedAdPbMto+HFq3lBrsICLmmlYRH89i
	 yKdgrFgnKx/bfnb2BGwHHm500GVpAxW5oIh6IgMwWEIw0OBTBB8VT4EoybRJPyXoUa
	 dxOzQWLYEYqJsVc4Vp67kHfXYPOClur4sqToJ5S3cSoJZwDQQOxo3VCEUFMVUy/Ca6
	 O3AQiIplyRfNtpPoeUYXiLUYNsWn5muiHxFfMF9w1hDf0FZr1NehDs9zcFUkKwjJpF
	 wX1FweOa+pzuQusoNL55uqyEZ/DOWtFmEdeV9VTC8vNE6Fn9L55LBJzvr4taHeNCFA
	 zFelqNd62KzXw==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyRXg-000000005UK-2LtM;
	Fri, 06 Mar 2026 10:32:20 +0100
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH] wifi: rtw89: drop redundant device reference
Date: Fri,  6 Mar 2026 10:32:06 +0100
Message-ID: <20260306093206.21081-1-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
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

Here's a follow-up to 

	https://lore.kernel.org/all/20260306085144.12064-1-johan@kernel.org/

which failed to include rtw89 despite Ping-Ke's explicit request (I
thought I had grepped for usb_get_dev in wireless before sending out
that series, but apparently not).

Johan


 drivers/net/wireless/realtek/rtw89/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/usb.c b/drivers/net/wireless/realtek/rtw89/usb.c
index da1b7ce8089e..64f0c0ec5ed4 100644
--- a/drivers/net/wireless/realtek/rtw89/usb.c
+++ b/drivers/net/wireless/realtek/rtw89/usb.c
@@ -935,7 +935,7 @@ static int rtw89_usb_intf_init(struct rtw89_dev *rtwdev,
 	if (!rtwusb->vendor_req_buf)
 		return -ENOMEM;
 
-	rtwusb->udev = usb_get_dev(interface_to_usbdev(intf));
+	rtwusb->udev = interface_to_usbdev(intf);
 
 	usb_set_intfdata(intf, rtwdev->hw);
 
@@ -949,7 +949,6 @@ static void rtw89_usb_intf_deinit(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_usb *rtwusb = rtw89_usb_priv(rtwdev);
 
-	usb_put_dev(rtwusb->udev);
 	kfree(rtwusb->vendor_req_buf);
 	usb_set_intfdata(intf, NULL);
 }
-- 
2.52.0

