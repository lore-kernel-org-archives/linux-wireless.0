Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526B4422523
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792136516; cv=none; b=qN9G558tpPHEef0TrJW/kHXZEjjhsyQXVznkr++WVxLOMj9XMKOZ87l3DWrSrDPvB8oHWPaKaQYDhY+wpoCcjAWKwX5Id13gpUxM3wlY/QRqRP/8vYqi17qlbY6gK+u538uCJ+oEsB8mH/JH5Ny7GVEQT+VQMxS6mmx7bhLXcr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792136516; c=relaxed/simple;
	bh=YWwmvElUc9AXiaYwHqeJ+Bg15uqZ2VhciNZerknv3os=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=AKxPlMbVXhq0BgCA2CJ/BI2CdUo67OSJkQ3dIxq25qmR7+xHJJ4icNfQImU6opkivpgeydFSa9HxJRK/OA+jzUA4hb8MJcKcDRrUlFwcXX43YOFiRciIfMP6pQ1uGPrbMuzaQh8F0GsUdYNNnXFGIi6VOv7jNMNPcZJ2PDvFvOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=b+Qq4NJf; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="b+Qq4NJf"
Received: (wp-smtpd smtp.wp.pl 48689 invoked from network); 16 Oct 2026 09:41:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1792136504; bh=Tj1NIUfIdB8KWsp0CXgkxumcGbJaElnC+Y5R81pw15k=;
          h=From:To:Subject;
          b=b+Qq4NJfW4l3sQbhkQKU3ApyOij647r91OFNhVzwlZt6p8Q+Ilyl0zsC6CBMpcaDF
           wsiv/0zTU0xHiuZFuC1J8PIvBImtQMd3l+TRTvqemkN+WP6YLKXoaFgeug+SE2gTwl
           FV9pFor84czq1zATv6vk7qEn7wCL0VwJcR25WKWdAEFB7wMwjre9j/ytwvXiCTKfBu
           C+2q6Ouzr+YSilkBp0N/ay5gjqXk9230W//88CBBbjlmFS0Z6iL7Gt5M8UOS842Bab
           zQx4hAuEs42vGYofjcS54xUFm3sO9RnpLbG6lBl0QjzDSGvkfv/+c4cY+2WU9YXrN1
           Kt2AA1OqyC09A==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 16 Oct 2026 09:41:44 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/3] small debugfs cleanups
Date: Fri, 16 Oct 2026 09:41:40 +0200
Message-Id: <20261016074143.71057-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 220636735df0217feb4420d24971501f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000002 [sUFm]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Remove some no longer needed debugfs files.

Stanislaw Gruszka (3):
  iwlegacy: remove configurable watchdog timeout
  iwlegacy: remove channels debugfs file
  iwlegacy: remove disable_ht40 debugfs file

 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +-
 drivers/net/wireless/intel/iwlegacy/3945.c    |   2 -
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965.c    |   1 -
 drivers/net/wireless/intel/iwlegacy/common.c  |  36 +----
 drivers/net/wireless/intel/iwlegacy/common.h  |  10 +-
 drivers/net/wireless/intel/iwlegacy/debug.c   | 149 ------------------
 7 files changed, 8 insertions(+), 194 deletions(-)

-- 
2.50.1

