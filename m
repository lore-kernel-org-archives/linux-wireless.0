Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE73367F38
	for <linux-wireless@vger.kernel.org>; Tue,  3 Mar 2026 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772546968; cv=none; b=KlPoYLg3XuDSp3t/ptZ9E+yy2YJGcAsuGLwAaMmtJrx6w0NQD8vZzUCECVKfNTjyXfYOIlL6xbNC2DqWmecUcHZ/5VIWJkhFIW89Tbhy5pDcWYX6kTPQY8rhDKnmWuZ/POzP4h0O39RpjabFk9NbHzQZeZoqBr11wno5KgCPn3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772546968; c=relaxed/simple;
	bh=hpFkSeBA/9f/OaWYTm0SDk/UEdEuzb6vxkW3OwiKvaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FHpVFkIXntL1SA1q5BU1EDHLvbEzjzwhVK6pLATUYeBcm3BstJzDnNIN5iVFIzPcFi63KopZIA/BOHyPS77uk0HY+owD1CVMD66mja9DQ2lcFSKJgF8AIbKFy1J50mDdE7oFG6LpjnDtYPiJm9iLptdserqc4layHwKR6hj5bbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Gc8S/Y03; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Gc8S/Y03"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=zZAdlUzzN59rrd4OIvXt5dUmv+E8lz6RchrX9zOQ15Q=; t=1772546966; x=1773756566; 
	b=Gc8S/Y03ULfA40WuRoWJkOAEM9qyO6xDK+zMLrSaxl3UkQ8uYZifC+AGp9u26qtb7l/keczbcEc
	dytwgqYVXTZX9SbpSxuFPuMNo6fq13z4k3Ak7eIRH1r+BG3+w3eJVvL2r+8ykyIvTdmLgM8ieGAKE
	+BJSb+emnvK/6YjAUPPdmR4nJD9MKTnsV8rBrLOhr1hUe2gLNaNC0Zv+lE/CGXcQ1r5xYuQITj7y7
	dNuCP32TXqSEIIUizFDZrcnO0tFNH6smGzPVnGqnLxs2wyqPrLNnwSCqvZfKJnEixYXJx8wFqJM+y
	erS8UiBUt9AxjzRXfWeBGcPdtVAk/87IjmCA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxQR9-0000000797P-1UXW;
	Tue, 03 Mar 2026 15:09:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: remove AID bit stripping for print
Date: Tue,  3 Mar 2026 15:09:21 +0100
Message-ID: <20260303150921.d04ad4dfdc48.I78da2953982e85aab386867dc9db83471bf35475@changeid>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Since the top bits have already been masked off according
to whether or not it's S1G, there's no need to mask again
for printing. Remove the superfluous code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 170330d924a3..8993ba5601b4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6721,7 +6721,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	sdata_info(sdata,
 		   "RX %sssocResp from %pM (capab=0x%x status=%d aid=%d)\n",
 		   reassoc ? "Rea" : "A", assoc_data->ap_addr,
-		   capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
+		   capab_info, status_code, aid);
 
 	ifmgd->broken_ap = false;
 
-- 
2.53.0

