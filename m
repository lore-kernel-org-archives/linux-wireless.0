Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443E93FF89F
	for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2026 12:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735155; cv=none; b=ZTjSRDiJZqsOZTOldzLYkzdcFKSQ1bkzH48YzC9FwASKYyHEVkWw8SD1InQDb1jyqWbFG2D7489EjcjK6Rp+LC5uFMhvcwlG2am2ViXH807W3nZtks3F0extILDR3U5eYok/l6P/UcHeuYR03iGGWowcjvhMsiFTt3R+ywFlB90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735155; c=relaxed/simple;
	bh=xNkn3G7UOegtKkx1kMyoGnRg2ustAsiDThF6lzjQXPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LR7CHyJgjnNiDVaMuqxmn166u5lrD5wQde0MYrts0iJDTnBRa88uPwWeYCiUP5upyJxH7Qe8phYR8/ZBeq57oMeqZWANf3W7Xs7cutrmqjUYQV/MvKiCuc3N37qCx44WwtklgUCndPNcfOIeG0fyAwcU6rDYd3flddKQu7+gi2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LjjP2fAh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LjjP2fAh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782735153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o7l7/11T0m+jkTcS2E9fJMxhpWgTbBQ5jf4vnvvdhOo=;
	b=LjjP2fAhLGIzI8RreIvmYiUSXzfx2UW7KnSLjANBR0OKQNnQ/ELLPvJdCbhP5W0WVjfHyd
	n2wJ2siELhDtHc7vnE4iCHXSOO3kThEPosBX1+87SaijS5m+F21Np3vBQrZ4ETxrmbOM4Z
	tGLR8exYsszdfkdfXPA8CCoPcWIuLN0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-kL1OV4UNOf-kqF9QE8XwVA-1; Mon,
 29 Jun 2026 08:12:29 -0400
X-MC-Unique: kL1OV4UNOf-kqF9QE8XwVA-1
X-Mimecast-MFC-AGG-ID: kL1OV4UNOf-kqF9QE8XwVA_1782735148
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BE54195604B;
	Mon, 29 Jun 2026 12:12:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.56])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1FAE9195608F;
	Mon, 29 Jun 2026 12:12:25 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: miriam.rachel.korenblit@intel.com,
	johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 2/2] wifi: iwlwifi: reduce encryption error message to debug level in FIPS mode
Date: Mon, 29 Jun 2026 14:12:13 +0200
Message-ID: <20260629121213.597038-3-jtornosm@redhat.com>
In-Reply-To: <20260629121213.597038-1-jtornosm@redhat.com>
References: <20260629121213.597038-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Reduce and modify in FIPS mode the warning message:
  "iwlwifi 0000:07:00.0: Unhandled alg: 0x707"
from IWL_WARN to IWL_DEBUG_RX when fips_enabled is true and status is
RX_MPDU_RES_STATUS_SEC_ENC_ERR (0x707), as this is expected behavior
in FIPS mode and not an error.

The current IWL_WARN message misleadingly suggests an error when this
is actually the intended behavior - firmware crypto disabled, software
crypto handling MFP frames using FIPS-approved AES-CMAC/GMAC algorithms.

These messages appear infrequently (shortly after association when first
IGTK-protected frames arrive) and are already rate-limited, so reducing
them to debug level in FIPS mode removes the false impression of a
problem while still providing useful information for debugging.

This prevents false-positive "Unhandled alg" warnings from appearing
in normal FIPS mode operation with Management Frame Protection enabled,
while preserving warnings for actual unexpected conditions.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 7f0b4f5daa21..3d6760d5c500 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -6,6 +6,7 @@
  */
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
+#include <linux/fips.h>
 #include "iwl-trans.h"
 #include "mvm.h"
 #include "fw-api.h"
@@ -494,6 +495,16 @@ static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		return 0;
 	case RX_MPDU_RES_STATUS_SEC_CMAC_GMAC_ENC:
 		break;
+	case RX_MPDU_RES_STATUS_SEC_ENC_ERR:
+		if (fips_enabled) {
+			/* Expected in FIPS mode - firmware has no keys,
+			 * mac80211 software crypto will handle it
+			 */
+			IWL_DEBUG_RX(mvm, "FIPS mode: Firmware cannot decrypt, status: 0x%x\n",
+				     status);
+			break;
+		}
+		fallthrough;
 	default:
 		/*
 		 * Sometimes we can get frames that were not decrypted
-- 
2.54.0

