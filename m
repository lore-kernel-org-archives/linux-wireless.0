Received: from smtpcmd0757.aruba.it (smtpcmd0757.aruba.it [62.149.156.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F4533998
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 00:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780013354; cv=none; b=MoK2F8paNt2XGU3h0tJnjViSFO6MgczY8nhg8z65+nWUFrB6CJgt+cHiaH7uQRQ0qg/f+15WfeNTJuWWPqNl+2hXZvW/cWCQUqEtXhmZ8f7P+5+ZGfL0UFKWVF44lJeb1BXwlDqTQps0sfkQa3s2YSb0gK7J4Qvnm/RpXeFwLKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780013354; c=relaxed/simple;
	bh=5u8Fg5vtsCQBtsotdH5esRw3mX1604EFdvjvTl71aV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oNyNsjInx4yeqEPU0B61INn/T8SNIPkUHf+TymG0a2rPDhxmrr39JB3351tfnEdE4bD3PEPIEYqEEz48QdUDydJcVsR5MCWL5q1NpR9DiWi9tfvhMY/RhZ0yf1EkZyov6RUjfMCFBR7drXofe78lAVqCYpViD2q8sChCNuPIBiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=CzKqJxZI; arc=none smtp.client-ip=62.149.156.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="CzKqJxZI"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Skjiwb0oZtpTfSkjiw9YPX; Fri, 29 May 2026 02:06:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1780013163; bh=5u8Fg5vtsCQBtsotdH5esRw3mX1604EFdvjvTl71aV0=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=CzKqJxZIfmnLpD2ZE01LtVJS8b9je0nKIjM67ya5r0jLirI2ii0IxGNrMJdVrvKUj
	 zVXDhLp9KtaPp6PHkCd4j1b7zuft0Og8e9w/g8qoW2SQGBZsgLNBE1uTgLGtKhhR3l
	 TyFbdiyUdLTuvBZUDfNQ61lT/qd0ZZbCUPOTrc9vqrV5/2ZS3Pl8taUEb74lz1rLJs
	 3sS10L7KwQwJ3UmnTvpPCeOlFeC2ou3WrZWj4UqBG0sUwI0Md3NSGIu2tltvnAwn9M
	 EzCEQM1imoU3GB7iAMmB/4vUrDeUelhODg2rz6/DdWposLOhvk7i04YLz/roeLjwN/
	 rsg8fhZydONcQ==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Fri, 29 May 2026 02:06:00 +0200
Subject: [PATCH 2/4] bcma: allow SHIM-style mini-EROM wrapper-less cores in
 scan
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260529-add-bcm6362-wlan-v1-2-722242777f58@gmail.com>
References: <20260529-add-bcm6362-wlan-v1-0-722242777f58@gmail.com>
In-Reply-To: <20260529-add-bcm6362-wlan-v1-0-722242777f58@gmail.com>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Alessio Ferri <alessio.ferri@mythread.it>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfBcr/DglRpxN7rw6gJy2iDE09fw681n/E0jjnusTr+YBzo0LvhdgKX9REQgLsE+08MNT4wD7AwS0wWzXJJxSryGamNMzjPD3JAECY5TxJEBqpCpvQZjQ
 jtNQyPnP/Nedax3aMJKayvYunmGdpvpOeIXNFL6EW4gfX8gyUyJXg2A73FbfvY+Nfd9QlEoYW+daAjCliaJOEvgIzRis69RY7OYX+Qd+UmK3U7vvV1PLoB0u
 2C5QtwVSKfpRZ8a1k3PeQOkP68M00EKZ05Fg6g68FNKvHo376SjaoXNZQg7alQLznV9EwQME4znJHzZapoiWomx4bxEIibWgzIInH7QxO0fD4YBjUTo4yc2T
 0xIQnInC8zUdo/YlUaNwEl6viUSG71eGNuKwBk7peD6QfG2lLYVvpjWgjTbeizGQrizxGLY09PdyXOw2KrER7EhgCGWbbvJhfVc/iXAkEhmn6vNNabCCQvlH
 GZn6vNEF9cuq+TFWK98ZdraTT736/WIjykftNuFjKJ90kTacCr6eOcT7lPM=

bcma_get_next_core() rejects with -ENXIO any component whose
component_B descriptor reports NMW=NSW=0 unless its core id is in
a short allowlist (4706 MAC GBIT, NS_CHIPCOMMON_B, PMU, GCI).

On SoCs that publish a SHIM-style mini-EROM (i.e. BCM6362) the
WLAN backplane lists three components:
ChipCommon, IEEE 802.11 and BCMA_CORE_SHIM. None of the three is
in the existing allowlist, so all three are skipped silently,
bus->cores stays empty, bcma_find_core(BCMA_CORE_CHIPCOMMON)
returns NULL, and a later bcma_chipco_watchdog_register()
dereferences cc->core->bus on its first line and oopses mid-probe.

Assisted-by: Claude:claude-4.8-opus
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/scan.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 983a62ddeebb..782fc53eb6b3 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -318,6 +318,21 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		case BCMA_CORE_GCI:
 		/* Not used yet: case BCMA_CORE_OOB_ROUTER: */
 			break;
+		case BCMA_CORE_CHIPCOMMON:
+		case BCMA_CORE_80211:
+		case BCMA_CORE_SHIM:
+			/* SHIM-style mini-EROM SoCs publish CHIPCOMMON, the
+			 * IEEE 802.11 core and the SHIM core itself with
+			 * NMW=NSW=0 because clock and reset gating happens
+			 * at the SoC level via the SHIM Control register,
+			 * not via per-core DMP wrappers. host_soc.c sets
+			 * bus->shim_attached on those SoCs from pdata; the
+			 * strict NMW=NSW=0 rejection still applies to PCI-
+			 * attached cards and to SoCs without that quirk.
+			 */
+			if (bus->shim_attached)
+				break;
+			fallthrough;
 		default:
 			bcma_erom_skip_component(bus, eromptr);
 			return -ENXIO;

-- 
2.54.0

