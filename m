Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7472331A43;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772787136; cv=none; b=tG7yVTcDx+ryR07BMfSVlBjLdAHpgy15Aiu19irxnlDl8FS39EHgLTw43O6IHXyEvQ4tQ8Y3zxv5zI2bkcWgzOzxwgBPY+LZZhgXfOYWlCJFoHXTDuhLO47wenpTKrs7BGpyToEKh/WIvV7EJ1A5pPM+k4tZGWL4pZH8E+E2miY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772787136; c=relaxed/simple;
	bh=Ke1gkgIAYNvXJE3uYWjze9f3v5h9YO7tPFOsLk607jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lr2S2Fl1ueHsl+McKjRU0TQeTbdXPTwZskrhJDxp2ojG6c3c6BVyXQfPbP4InHPtPp2OipwKyqkESIMvAXIpfVhM30oZTETkdKhFmd39WlA74BWKo45jpo43wT5TWLRyTI4fqplxY7Vofzuo34jZ2g+2EJvy55ftpU6r5KhMrmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RkTQdAht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkTQdAht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E031C4AF09;
	Fri,  6 Mar 2026 08:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772787135;
	bh=Ke1gkgIAYNvXJE3uYWjze9f3v5h9YO7tPFOsLk607jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkTQdAhtU9OR9wvXzGhf4ByQYCL81x9oU+6JIn2zapFSOpWh3n500gV1EOvKfElR6
	 4YL6PJn2Wc5gU2T9gLfblYVDs4+/HxQ47n/CboaYY0S7FMhjUi81erdWyrcbk+jvyd
	 kkg/0ejujbFNPj6TJVGkeP1Oa11mjtxFTJRDX2fE9fdiOP/iDDsDCoeTA3e52/NzGo
	 oFRf3SlOQW4uBnsdMOZK+YHUOk6Ia5MSxzI8sNTbH567UxMTfGGsXMa2hhoKO++dzs
	 nhNttX8+IvfLj082op/P53vR/pPknfF9cuPa7FfVYf06bGbYBVgKnJYYBw9/syBPL+
	 R+m+pVzH8l5xg==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyQuq-000000003AT-3aeF;
	Fri, 06 Mar 2026 09:52:12 +0100
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 05/18] wifi: ath10k: rename disconnect callback
Date: Fri,  6 Mar 2026 09:51:31 +0100
Message-ID: <20260306085144.12064-6-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260306085144.12064-1-johan@kernel.org>
References: <20260306085144.12064-1-johan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the disconnect callback so that it reflects the callback name for
consistency with the rest of the kernel (e.g. makes it easier to grep
for).

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/ath10k/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index ad1cf0681b19..987d57a01ddf 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1057,7 +1057,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	return ret;
 }
 
-static void ath10k_usb_remove(struct usb_interface *interface)
+static void ath10k_usb_disconnect(struct usb_interface *interface)
 {
 	struct ath10k_usb *ar_usb;
 
@@ -1113,7 +1113,7 @@ static struct usb_driver ath10k_usb_driver = {
 	.probe = ath10k_usb_probe,
 	.suspend = ath10k_usb_pm_suspend,
 	.resume = ath10k_usb_pm_resume,
-	.disconnect = ath10k_usb_remove,
+	.disconnect = ath10k_usb_disconnect,
 	.id_table = ath10k_usb_ids,
 	.supports_autosuspend = true,
 	.disable_hub_initiated_lpm = 1,
-- 
2.52.0

