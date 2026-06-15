Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35D0145B3F
	for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2026 07:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781509203; cv=none; b=jU5QSRnaMjTkyvHb9OjHVY06qxRAKI1IzeEWy+oNY/zwIxLWv+A3QHv3Mevs6+9gxBmF7FTThk19b3SXfErTGFBVmSDxYH9cvpqUJaCCbqMUuHXsLSmhebEPGegXqUhzcAm+Z9CdK6ZsFchUMUO5/4lrgmowDCMUnRXTSjVEXxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781509203; c=relaxed/simple;
	bh=/DLB/hZ4BFZTunhAdAkCg6Z1+YqkpajWTUPjgRVb9/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ldzeWMJsufzlo/0CxYfMMCP8h8+6TJ5HNjqoiSYFp8dVeOPXzAzEahsS2bnMaEjA4BMAx12fBplMEDuBkz5OCw0kaHGbuLCxcuElzieeD079qfB8ubfWRYeL8Zv5kk59BtnjP1fHD1ljv3oSVPofHhV4wf2solu+3TUgNkozJ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Tsws8llr; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Tsws8llr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=WnbZ9qE0t8K6FD1NOa1Jksms58p5skUqch/Pha3BChM=; t=1781509200; x=1782718800; 
	b=Tsws8llr+lUYy4arCJLW5bwuUK0unocuGeuHIYeAmzORWJVr2quUEoFUyoHEcY4U40RXC6cdjln
	t/iaXFHSHEuc1bh4pqfkSKhdAzKYSuWrD2Rv+pXwaFxosbbf8s+HDAVOuIG6MIKeiDN3pZVcsFPW9
	vfTkKbEQSfrdYQOyZiU9NxwL4WpFlNd5Iu+udszQ9UxdPOuoZRLpdJ1KpaHpp3ScZilbKYNKcjlST
	q2UVHaKypWtN8njeHjfTUSEwBtLyu19EoAvZmwmUk0Ytp6uK9PYUVHvGufr+r+5Kcv2wjXWn0JWjp
	ldKGpq9OIC2YroRDyzZzHc6fVGiQIpKZXm4w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wZ1vD-0000000DjgE-0dLj;
	Mon, 15 Jun 2026 09:39:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: nl80211: clarify NL80211_BAND_IFTYPE_ATTR_HE_6GHZ_CAPA content
Date: Mon, 15 Jun 2026 09:39:48 +0200
Message-ID: <20260615093948.0f730833a6d5.I1c8c5c09dfe16b0b1dcb10d54fc030f6b1d4fc8c@changeid>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is currently __le16, but really the whole content of the
corresponding 802.11 element, which is even extensible and
could, in theory, be increased in size. Clarify the docs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9998f6c0a665..74593a151e14 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4474,8 +4474,8 @@ enum nl80211_mpath_info {
  *     capabilities IE
  * @NL80211_BAND_IFTYPE_ATTR_HE_CAP_PPE: HE PPE thresholds information as
  *     defined in HE capabilities IE
- * @NL80211_BAND_IFTYPE_ATTR_HE_6GHZ_CAPA: HE 6GHz band capabilities (__le16),
- *	given for all 6 GHz band channels
+ * @NL80211_BAND_IFTYPE_ATTR_HE_6GHZ_CAPA: HE 6GHz band capabilities,
+ *	given for all 6 GHz band channels (binary, element content)
  * @NL80211_BAND_IFTYPE_ATTR_VENDOR_ELEMS: vendor element capabilities that are
  *	advertised on this band/for this iftype (binary)
  * @NL80211_BAND_IFTYPE_ATTR_EHT_CAP_MAC: EHT MAC capabilities as in EHT
-- 
2.53.0

