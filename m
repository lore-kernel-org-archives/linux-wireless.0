Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822D93C8C74
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 08:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791274497; cv=none; b=oAwx/dJ6Hdd9qEccLyA8KnWi3H/jT58SHGO7nMUZnxIEFqy9ON6bfhplgDL9Se/hJ2Iryrv2M6E5ubdhQOpHRL1WOwd1DqQvb0dyY4pMRBFfGM4HMOw9kx0FWrw00WNV8wiXCj3HfRsYKSV4bfhK+qL9uO8nTdHi+ZTdu11vObQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791274497; c=relaxed/simple;
	bh=PgqhwvN4IyJ9LTLjR2tnGZQRwQPGekWUjWejb8rsNVE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LmBzXgu5ZRVB/Pdf818q9PUjO9i33Ua8rBXDcPXeONTj9lfNTHGInw813ikjTgt8wp9gsh7G154vL6odJddPT5GCT4SHj/iUEIGlJtxp8yicXXWUM82ITqsr/eVdU+HWRUVSNlGwDcib5/zjK5aeA6TJXzRE0stlTcnpoUmEYnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=kaDAwxtr; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="kaDAwxtr"
Received: (wp-smtpd smtp.wp.pl 34358 invoked from network); 6 Oct 2026 10:14:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1791274483; bh=CGv1WaeCEwIFtDej9+GqNGteZ5rEgee+SYkeqLub/8Y=;
          h=From:To:Cc:Subject;
          b=kaDAwxtr/L289A3F3OcD1FtnZ9s3uzDe2WnwrISU/LIu/4IHwFKne9eKb4PBcuWK4
           5tGZGYG1j7YSBf8uEjKZ/ah7sJs0QlCg6rHT1NRpiS39A5EGMEgSvIueed5lgeS4/R
           Ch18MLJ+MS9qiG+ASAYyy/VP+KP4zJNkqEx+IxELX+Gx1BSG0qzsT8iLiP9/cvEEz/
           Ylv6y93icsIqxOAqv3+K+VZoZRc35FO6hVSglLhOUW6tfE/K2oy4miBhhJCgKLHGKH
           pmTNLQ5u/4jM2nWWIDxksteUJKhbnLU9UZJWoTz5HOKsTnF1SuWbQumpkgHc3cMlTf
           mOy1/UvxG0dXg==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 6 Oct 2026 10:14:43 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/3] wifi: iwlegacy: remove undocumented sysfs files
Date: Tue,  6 Oct 2026 10:14:40 +0200
Message-Id: <20261006081443.28017-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 7dfe2708a5f8b4d59cb5cd915c281c4f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [MXFF]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Remove custom undocumented sysfs files. All are seems unneeded
at this point, except debug_level which is useful for dynamically
change debug mask. That one was moved to debugfs.

Stanislaw Gruszka (3):
  wifi: iwlegacy: set debug level using debugfs
  wifi: iwlegacy: 4965: remove custom sysfs files
  wifi: iwlegacy: 3945: remove custom sysfs files

 .../net/wireless/intel/iwlegacy/3945-mac.c    | 441 +-----------------
 .../net/wireless/intel/iwlegacy/4965-mac.c    | 121 -----
 drivers/net/wireless/intel/iwlegacy/debug.c   |   3 +
 3 files changed, 5 insertions(+), 560 deletions(-)

-- 
2.50.1

