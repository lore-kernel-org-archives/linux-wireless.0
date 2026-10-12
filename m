Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0287B37F8D7
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=165.173.180.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814070; cv=pass; b=PIGdaqzwg3MDbqJ/pTNMJsPXTnnjYFNiTikHAXMTYeBnOcnn/cN7Vfts5a1AUzpMUulivL+TO0fFJd6GUZAEGcDhV2tWIuVhSxSIxJx1HKrW5mlZzDVKCFBcQOaFdjZgv7tkDBbZv/FUa4pAKffo4YU9SmT2XCXzzsQHOVJBWSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814070; c=relaxed/simple;
	bh=DSPjN/2X7AOVhGM2vvBksDU2sTsfTiCH3cpR8hrC53w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NGHLL5YhmsrLX8nYvXrdOtmhW+aDvsW3wfXQjyn33nXvjLKzfnpT9rCOzaZYNNga0laL9O636vMV7mw1SgE03V+4j/MJa1sBEM/lUhLBy9N4KiH1WRLrvARjEGjR41P/Puyt6fSHvaPjpm0qpbwZy49kLviEF+t/Tep8puXJM4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com; spf=pass smtp.mailfrom=xv97.com; dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b=fTER6iGe; arc=pass smtp.client-ip=165.173.180.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xv97.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xv97.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xv97.com header.i=m@xv97.com header.b="fTER6iGe"
ARC-Seal: i=1; a=rsa-sha256; t=1791814066; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VV5zdTgb/4iFCt03YHflTTtI+W3ClWdgOHUGlga0hgLEG/Hkusg826E/KfDbn9ixekmennA6tqpgO71NszjfbuHkJqPPyXlthCqaE+jVLRQSkpvlidL63GOEaYeGkPXh8QKgsYSUnZJwdfE9Zw3+LeU4A5qicf+HrKflb8/1i2k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791814066; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FMs3g6p6vFW0ayLPUEa7w42NEVCHf2dHrlAD0WyJDHw=; 
	b=CelO0Xzi1txTJLQqQdR7c/kHOThJyZ+8yPViK9ozwhJK1UfeVmrbLC8t62r4sKCpNxBCELXnO6Jg85i76kV9dRyC/ZOhcmUrl5ZrPi4h5wt4F4xCBxyGQ5BhwZd/d+2dzPpihHwRCNQemerPUP+22cTtURU9b5FHWKUZN05YDp0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=xv97.com;
	spf=pass  smtp.mailfrom=m@xv97.com;
	dmarc=pass header.from=<m@xv97.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791814066;
	s=zmail; d=xv97.com; i=m@xv97.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FMs3g6p6vFW0ayLPUEa7w42NEVCHf2dHrlAD0WyJDHw=;
	b=fTER6iGeWsKyaMLueOyOaZPCX9k4/f8mytsn4hvs8iTcOlzlRP+mjp6Ul41p/m9m
	Of5P+r0FBfs081b3nFxRm5y3CcVvifV5bYWEpxcSqojJBUkZMcRRTlA7cJfImlx7yL5
	+N1eyt11SJnrTigc3oPzQ1ErBgsRL1XkHIqr0oyc=
Received: by smtp.zohomail.com with SMTPS id 1791814063749530.1352520573099;
	Mon, 12 Oct 2026 07:07:43 -0700 (PDT)
From: Chien Wong <m@xv97.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	jouni.malinen@oss.qualcomm.com
Subject: [PATCH v2 0/2] wifi: mac80211: reserve MME tailroom
Date: Mon, 12 Oct 2026 22:07:35 +0800
Message-ID: <20261012140738.70178-1-m@xv97.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

BIP-CMAC-256 and BIP-GMAC append a 26-byte MME, while mac80211
currently reserves only 18 bytes of encryption tailroom. Protected
beacon skb allocation also needs to reserve room for the MME.

Changes in v2:
1. 'MMIE' -> 'MME'.
2. Minor tweak in commit msg

Chien Wong (2):
  wifi: mac80211: fix encryption tailroom
  wifi: mac80211: reserve MME tailroom for protected beacons

 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/tx.c          | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.56.0

