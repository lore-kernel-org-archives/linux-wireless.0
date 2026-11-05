Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878980;
	b=PXPIfd/kD8d1isUquRVUhZxJMqitTJtF74xr1kxJ+4N4sLRH9ZGzz9u0uYqT7sGlEcJk
	 EUdSvVhZDWMLU9EgDKEirZaGMm5qewG0Z3TMR6rmOtZslOdy6daSeAi5aQNMwEZilxWHR
	 zJ23oGzbCmfVTvw2angaCmbg/8aNKbrVDLrELH9zpXmxcqRrUviYTMGvUINbzGc+AMrt2
	 v2O3KRrlKQq1y7/SBCIZuuRdSzTKBuoy6Iv8gf07+tOz49viGNVAm4it7jpK78eW9+hgv
	 GAJFJLPCgQ+YmgsaqqoMy5AXqnbL1KwMxcQtyx0Q0zhP+or54elWz10PV06pWiU2e5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=wh2ChqYF9XmNrt6b8ATpGBOGwb3/qYFuxeZ+hTus5/8=;
	b=IODUXf09rZU4m1IVrAa/B1AAOrTQ4VXlt+Fdj04brOQZUo2mjNr7wm+EyVUcHuqsbF+W
	 nqF9C06rUzVs6Y45gyouSq3T/1du0YddjMN4bUzgdVxx7n2UyG59QRhkYA3OuPm5TIIKR
	 P335YGmsdumVbzNbMxUxMBbY2wE5qfhdTcYxCyDNZrboBBwDZ87f9eu5yQYq3tzpWlSho
	 geiV3f/LfOKwnCUaMOow+4z1s+53xkGBbUdH9eyi8GjLC1Rp+4VqRdmVxI1ZtQxBM4uH6
	 me9Gi5xRfRvrkUzJWbrk7EFVONggoiHtBT8k6IuQJKjJy/TuvtchEttGY59Di+FJq2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hz+Q7l13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218496082BC1;
	Thu,  5 Nov 2026 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hz+Q7l13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C471F00A15;
	Thu,  5 Nov 2026 11:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793878980;
	bh=wh2ChqYF9XmNrt6b8ATpGBOGwb3/qYFuxeZ+hTus5/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hz+Q7l13ehrAH4JfC/EmnFHGXEzuVKlpCJ2hy0jgirPvlXDfbh9TzTMxvSEM6ftXL
	 V4gRcdHtqAxgaJGYxhvb9wFCVxSfrsAAeFspTWF18H2yAevJRWmbTRoiB1VxTBL26V
	 drIvK0pp+5Vy5BVtDKiwEoAjO2KuKEYGtBLshn+pSKmASjMVYF2/2OfECXUV/zq7Vf
	 DwdlYasjopA6fDNUUo1tirp/B5e/etym3wKTgkWVqF782WshoLHDVjRmtlDChPvjZY
	 oRH4EFh4/hTEI4ToBhirlTH+z+6szkJ4Rr4SuE9x29hl4l1rkbr6TNhUpciGDZtZox
	 s4g7D59du+NYA==
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
Subject: [PATCH 07/17] cdx: Propagate DMA configuration errors
Date: Thu,  5 Nov 2026 13:42:20 +0200
Message-ID: <20261105-device-trust-core-v1-7-1e536825b4eb@nvidia.com>
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

CDX reports successful DMA configuration when firmware setup defers or
default-domain acquisition fails. Driver probing can then proceed without
the required DMA setup or IOMMU ownership.

Return the configuration result so driver core stops or defers probing
instead of allowing a driver to use a rejected domain.

Fixes: 2959ab247061 ("cdx: add the cdx bus driver")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/cdx/cdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
index a118a89a7779d..0a030bf522690 100644
--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -367,7 +367,7 @@ static int cdx_dma_configure(struct device *dev)
 			arch_teardown_dma_ops(dev);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void cdx_dma_cleanup(struct device *dev)

-- 
2.56.0

