Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878984;
	b=z0eRpH7iTBCeFdh6i65iaR5W368bz9iT0HA2HyCkFe1OZAmPpDnFzJgM7CmL2lMftu39
	 IwSrkOXPcXdE0plNXepsCStrk4lJcK3aa2Gem5ct8dZ0V4rse2Qxi2WN4K1r25Grmpbnc
	 TTpJueTJdYfUv4OkI/dXElFtA1MMv3vlIUIfIZ4IScXutseR8HmaO5P9GnsFhoD50MMgr
	 7WLKtsUmn4I/xatyPf2rZ+gZBwPSvFcG0G7XQXcbdoXSTCWaBKqh3G8I051zZHIkBS2i9
	 XM7a2GVpaMbUjlH8y3HiZUQ7MatMV6gyBpDr0vf89gNW1PhCyCay+y0F5Jrni/cKZkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=cdCM073jR/DCJh2HUDXaqMPcxaAwWF1lPqWNiB/vLUE=;
	b=dsn5bCWj1f9pte5inM8FDmMISp32FQpHI81rHX06sTIbcQ7LNtdy9m27rh70Lj5aWk3L
	 AEeqCnb7GobfMd+cXMpSVeQzzYpLavMiew4cIYfFu29LUEn9J9AJ4z7qWIGMAV6j7sj5A
	 1hNlStYU6XxNUmOcfFMZ6leM5Mvu9cxqjvpkveWMEsYEVX3Qrz4n6NA3Rf9G9z9f3VrGr
	 eSePCsKKpM1K8Vy4m5GNKWtGnIdqnSzEUHDjeA8cxtY0MGLZz8ysv92NQ+jC/BothPdps
	 b0MB+FOHKZGf+3qIBl+yd5wgEwqB+Mf0VmJmd1TYI2PtAjgZdL4hdRCkFU86TLUW8Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eT9v7SQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1244B6082BFD;
	Thu,  5 Nov 2026 11:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eT9v7SQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDD41F00A22;
	Thu,  5 Nov 2026 11:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878983;
	bh=cdCM073jR/DCJh2HUDXaqMPcxaAwWF1lPqWNiB/vLUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eT9v7SQ2y40A5UP/390xXLrJsObRzc3AcOzfvEdORBqVDMN/q52Qniru19gINalgH
	 JGk2bwSuLsIXV5t3ZEyuFDYmjpnJlfua/IAzbcEYKlMQ5Aq5wfcSAOf0kujEuOt9ES
	 ycVUHMFg5X9C8EHHPioe1DmIKzXEePWmQnnHd/tW7Jj8oMnr2C839yipt6Zd1dwzWU
	 kPYZfW251UgxkBntPipWQEo67dbzvXXaaB5/NDGTShbtposKweytgxdFtDpGdHmU9w
	 qY8WXx8BbQRVsbYSUZ0I2vuAS6Cz6sIr3afUL4xRDWaeTsB3YrW3TBviftXA2IGvMi
	 lHmgYx8N1Gc0w==
From: Leon Romanovsky <leon@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Johan Hovold <johan@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Cc: linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-input@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org,
	iommu@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH 04/17] wifi: mac80211_hwsim: lock device for manual driver binding
Date: Thu,  5 Nov 2026 13:42:17 +0200
Message-ID: <20261105-device-trust-core-v1-4-1e536825b4eb@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
References: <20261105-device-trust-core-v1-0-1e536825b4eb@nvidia.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

The documented API contract for device_bind_driver() requires the device
lock. mac80211_hwsim uses it for a newly created class device with no bus,
so no automatic driver-core path can bind the device concurrently and the
missing lock was safe.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index e53714b81ec2c..b796da3dd54b3 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -5769,7 +5769,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		goto failed_drvdata;
 	}
 	data->dev->driver = &mac80211_hwsim_driver.driver;
+	device_lock(data->dev);
 	err = device_bind_driver(data->dev);
+	device_unlock(data->dev);
 	if (err != 0) {
 		pr_debug("mac80211_hwsim: device_bind_driver failed (%d)\n",
 		       err);

-- 
2.56.0

