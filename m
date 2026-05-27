Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823BC3EDE63;
	Wed, 27 May 2026 11:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779880605; cv=none; b=johkBWZNaJawv9SrLjBxS4x1s01x15NLOaxm08FcDl6i9of240GMwt/n/bRFtpIhq4V4FSIpls7kWrmvz5ux9dixMNNAFxNHQ74xGjp3n7ShWs+Jfm7yUyn2YT+bQ25dWH2eivC6PkwepKRuMVHMefr9AXW4dqtvRBYjotg/hWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779880605; c=relaxed/simple;
	bh=UnRKbphJSn+ZWtZXXRp5Q4HA51koXjLnxQZqGHP7fyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t3cnXAtwk01xPUjiXhkkCipX1nLyrFnQ11U7/fhYjx1O8sP3OvsQv0mVRCwRJZ0CG4SD4NXQfPlU1z5EQHsWEBkC6e95xR1fOZMHMvufpBSk790Sc1bif4OwuX0IWVNwvFy7qBx2Gt+Jp9WkF7BYpnCsx6UcXt9Kde/nwboPvjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=FHIULeCg; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="FHIULeCg"
Received: from mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:94a9:0:640:a3fa:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 5284980784;
	Wed, 27 May 2026 14:14:49 +0300 (MSK)
Received: from kniv-nix.yandex-team.ru (unknown [2a02:6bf:8080:1a::1:10])
	by mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net (smtpcorp) with ESMTPSA id aEXgm00XBmI0-ZdLcqubW;
	Wed, 27 May 2026 14:14:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1779880488;
	bh=UnRKbphJSn+ZWtZXXRp5Q4HA51koXjLnxQZqGHP7fyU=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=FHIULeCgFRw4lOGnD+ZA2pxqp2GdlP7uQcHZG5ub0W3nuwZ3sS84dPZOb/WCRCUYl
	 QSZKInvp4g9qaPgtMDXMbbQjxGsJSQpL5f+iEECi8CIIz/4caT21N8cr6d5FDQ8ift
	 P1vcHgRclYQ99mzGw23L9T+ENkk44xyABn22LapU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-68.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Nikolay Kuratov <kniv@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Hong Liu <liu.hong@intel.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	Nikolay Kuratov <kniv@yandex-team.ru>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re:[PATCH] wifi: ipw2x00: Fix potential NULL crypt->ops dereference in libipw_xmit()
Date: Wed, 27 May 2026 14:14:36 +0300
Message-Id: <20260527111436.533744-1-kniv@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <57001abe5cdd0f2a7fc533764f0d9140fe20a3ad.camel@sipsolutions.net>
References: <57001abe5cdd0f2a7fc533764f0d9140fe20a3ad.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Might want to fix your tool to look deeper than just pattern-matching
> the surrounding code :) The prior commit was also already wrong.

That was me who blindly believed in existing commit correctness!

> so "host_encrypt && crypt" is equivalent to checking just
> "host_encrypt".

Thank you, missed that.

> And the only way to set the crypt[] array where a non-NULL 'crypt' comes
> from will always have ops, so "crypt && crypt->ops" is equivalent to
> checking just "crypt".

To make it more clear, this logic belongs to libipw_wx_set_encode
and libipw_wx_set_encodeext. If there is no libipw_crypt_wep module
available, then it fails with NULL crypt as you said.
Some parts of code still check for non-NULL crypt->ops separately,
but at least it should not cause problems.

Lets just drop that patch.
