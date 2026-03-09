Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266C1C2FF;
	Mon,  9 Mar 2026 08:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773045232; cv=none; b=VT6FHHlmE2UBbazpABWKHB/nrYW4YRfrHceToNQ9VCbQ9rQX9YgBWIO5SMRlUjD+flS9h3hlL1vfQN9ltKS76WOX4b9Jltz+YLAnQuSyz00QgXsbimX7pWg/tl2IIQtP252dHoTA0uzlLhYc3MimTL+DyIayBC142ihD4b2LmRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773045232; c=relaxed/simple;
	bh=cntfyFJOAGhFo2xEuZn1iIGpl9MoGto1eyA8bUjR0wc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BDuqEn5vr04vylp2hpO+Do2W3XZX86OWWmr7u5S0QikTLxcTxbCP6+Gmig6Z+HlntxEXnaQlZLULl64pTXdAUR48j9oLmoIN3i8ZcuckIQaRRBa7UrlXoczdmS2xirOLXeveO8Eqn463n+aUr99X2bjnuwUS5TpJwL07hwO0iiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGq8gZXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGq8gZXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1666C4CEF7;
	Mon,  9 Mar 2026 08:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773045231;
	bh=cntfyFJOAGhFo2xEuZn1iIGpl9MoGto1eyA8bUjR0wc=;
	h=From:To:Cc:Subject:Date:From;
	b=GGq8gZXSBLMuCIXxfmPbpOLTevSWbrS799u9kpbq8Fjwm571lFw0RFWUwUhx8J901
	 Mh2SVw2TJ0YZZQ2D+TCDy27bJS7ztUbdgw99FNryVYGkfUPMVNTUXdhSe2CHQX4TyA
	 8tqjYztucL4vuGzNUnMfVfunIG9cIRgW9aViJJXDdUkUh7hcsLdyXqGMOPtNvgUniC
	 aQ2/FD9mES+UvAulEWHULEAzbCZY12e5xliEU99/p1qs00mD0sEG41Q8sBQtgdvzPm
	 5/w9ONy+PCEjlHIv4w/pDhKE4ubhkOff5ZHyhmSAagJaz71VCOp61ApWTSrHtBZ5Xr
	 obZEK5rwLdm/w==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vzW3h-000000004Gl-1vRE;
	Mon, 09 Mar 2026 09:33:49 +0100
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH RESEND] wifi: rtlwifi: usb: drop redundant device reference
Date: Mon,  9 Mar 2026 09:33:36 +0100
Message-ID: <20260309083336.16397-1-johan@kernel.org>
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

This one fell out when sending v2 of the series:

	https://lore.kernel.org/all/20260306085144.12064-2-johan@kernel.org/

so posting again separately.

Sorry for the mess.

Johan


 drivers/net/wireless/realtek/rtlwifi/usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index d35ed56d6db9..9a64df9eed39 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -986,7 +986,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 	init_completion(&rtlpriv->firmware_loading_complete);
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	udev = interface_to_usbdev(intf);
-	usb_get_dev(udev);
 	usb_priv = rtl_usbpriv(hw);
 	memset(usb_priv, 0, sizeof(*usb_priv));
 	usb_priv->dev.intf = intf;
@@ -1038,7 +1037,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 	rtl_deinit_core(hw);
 error_out2:
 	_rtl_usb_io_handler_release(hw);
-	usb_put_dev(udev);
 	kfree(rtlpriv->usb_data);
 	ieee80211_free_hw(hw);
 	return -ENODEV;
@@ -1050,7 +1048,6 @@ void rtl_usb_disconnect(struct usb_interface *intf)
 	struct ieee80211_hw *hw = usb_get_intfdata(intf);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *rtlmac = rtl_mac(rtl_priv(hw));
-	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	if (unlikely(!rtlpriv))
 		return;
@@ -1072,7 +1069,6 @@ void rtl_usb_disconnect(struct usb_interface *intf)
 	kfree(rtlpriv->usb_data);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 	_rtl_usb_io_handler_release(hw);
-	usb_put_dev(rtlusb->udev);
 	usb_set_intfdata(intf, NULL);
 	ieee80211_free_hw(hw);
 }
-- 
2.52.0

