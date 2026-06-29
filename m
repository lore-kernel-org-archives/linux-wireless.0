Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26EB3BB4A
	for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2026 12:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735145; cv=none; b=nTeI3uWOsYAaTNU8ca7pdRsP9hugJlpNJaAJnOGks1bGclcGsBCjFAPvkAVC9izYoFGifbsmq6R5Gkh5nfivcEEqGIvXfEwiNyzp8ptZ3mEcWUaPtKdZr8Rr1wvzmThF8EmbsE7GPp9QTGoWNFVORzdbR8dsRvBxb5A8L5/i9PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735145; c=relaxed/simple;
	bh=XtGxf+5aDal/WtBKt7lgKKKf3R35RuELt/a3Nj1ryio=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MLQxwG//1AiiMQoVlS2bcCZTA5zCnivHvwqKcjFKpQSTTlzpxzyQDkwrdHSp2HXAMkrNokKPsE6I6W2OeBgLrccUFyTkwNtMKmVa0H8bAm64jpM1UnOBhL/FdgNcfOk3JqS1NsOYTifr9LS1GlPHgdDG6co9SWZzO+BV7lcXMEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Men4FEOs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Men4FEOs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782735142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tET1GxODJ+iBQSEPXEqBWD/ZI7nKPc3wxOhFSuZ3QEg=;
	b=Men4FEOsD9ZL3zdXmmO6+/K4y4VJl3Ykua8J2somhhmPowGZcutGmD0QNgGYfIoibC0l7S
	eLxuTUPkA0q7h7fQgJpErZXuP3i0E4EQ+weWinlEQKEq1Y2BG8G+NC7/74JgL9zBM0HF/G
	xMLEGp49ixqEs3n6MAWXzxY1h8RaZt8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-0Gf2hTPNPyCYuOz-Bi24hg-1; Mon,
 29 Jun 2026 08:12:21 -0400
X-MC-Unique: 0Gf2hTPNPyCYuOz-Bi24hg-1
X-Mimecast-MFC-AGG-ID: 0Gf2hTPNPyCYuOz-Bi24hg_1782735140
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 121E718007F4;
	Mon, 29 Jun 2026 12:12:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.56])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC384195608F;
	Mon, 29 Jun 2026 12:12:17 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: miriam.rachel.korenblit@intel.com,
	johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH 0/2] wifi: iwlwifi: Fix WiFi operation in FIPS mode
Date: Mon, 29 Jun 2026 14:12:11 +0200
Message-ID: <20260629121213.597038-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This series re-enables WiFi connectivity in FIPS mode for iwlwifi by
allowing Management Frame Protection (MFP/802.11w) to work with mac80211
software crypto.

Currently, iwlwifi connections fail in FIPS mode because commit
0636800c8ee1 (("wifi: iwlwifi: disable certain features for fips_enabled")
disabled MFP_CAPABLE when fips_enabled=1. The testing shows that MFP works
correctly in FIPS mode when mac80211 software crypto handles IGTK encryption
/decryption using FIPS-approved AES-CMAC/GMAC algorithms.

I think the original concern that "MFP since some frames need to be handled
in firmware" can be avoided for normal STA operation. The firmware-offload
requirement appears to apply specifically to features like WoWLAN and beacon
protection, which remain correctly disabled. AFAIK, for standard client
connections, management frames are processed only in software and mac80211
provides complete IGTK handling.

Patch 1 re-enables MFP_CAPABLE for iwlwifi to allow basic WiFi client
operation in FIPS mode. Patch 2 reduces a misleading warning message that
appears during normal FIPS operation to debug level - the warning actually
confirms that frames are not processed by firmware and are correctly handled
by software crypto instead.

Testing on Intel WiFi 6E AX210 with fips=1:

Before:
  # cat /proc/sys/crypto/fips_enabled
  1
  # iw phy phy0 info | grep -A 10 "Cipher"
  Supported Ciphers:
      * CCMP-128 (00-0f-ac:4)
      * CCMP-256 (00-0f-ac:10)
      * GCMP-128 (00-0f-ac:8)
      * GCMP-256 (00-0f-ac:9)
  # nmcli connection up SSID
  Error: Connection activation failed

After:
  # cat /proc/sys/crypto/fips_enabled
  1
  # iw phy phy0 info | grep -A 10 "Cipher"
  Supported Ciphers:
      * CCMP-128 (00-0f-ac:4)
      * CCMP-256 (00-0f-ac:10)
      * GCMP-128 (00-0f-ac:8)
      * GCMP-256 (00-0f-ac:9)
      * CMAC (00-0f-ac:6)
      * CMAC-256 (00-0f-ac:13)
      * GMAC-128 (00-0f-ac:11)
      * GMAC-256 (00-0f-ac:12)
  # nmcli connection up SSID
  Connection successfully activated
  # iw dev wlp7s0 station dump | grep MFP
  MFP:        yes

Jose Ignacio Tornos Martinez (2):
  wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
  wifi: iwlwifi: reduce encryption error message to debug level in FIPS mode

--
2.47.1

