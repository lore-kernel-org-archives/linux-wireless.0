Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A0535F602;
	Tue,  7 Apr 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574695; cv=none; b=S6veC5ehLC+7buST6qPNGMep1AhxOPTq4ywkDam4MTjWsaUPBTsvQo+dCTub+qVVaBXzd2SvjWQ6luDeU7kGCjBhEh1wyXo/qUC2xuUtVPJscLwI9CdZMBM9ICQtzsQUCd+xu+g+Q7s+Pl0YnBlzi/1Tv6bhWrxKhEkvMptZvzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574695; c=relaxed/simple;
	bh=yhVQppHVFW8Te0Gb8BJnlsGvxMPSV1L6vIxwkXFfjTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Za0F5fanw2Rqu9iEQWOghbgqgR/FglDqlM04YQsZnKCeTXvuN+FCF8yqvOtp+8mZbNzHqdFWhdOP6xWGAXlC7tEIlEZQMZT5MLTVtyLLBkZW9ZWFVr76TmjXKRdJFyAog8vIuG6U+hEajSd6TrLmpGl9bwXWWNM5MPXWOGZ/+V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhT+Wwmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhT+Wwmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F649C19424;
	Tue,  7 Apr 2026 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775574695;
	bh=yhVQppHVFW8Te0Gb8BJnlsGvxMPSV1L6vIxwkXFfjTw=;
	h=From:To:Cc:Subject:Date:From;
	b=XhT+WwmckAFNphsZkojivXoALb006Ioijr1YpwUFuxFBquloR4aZXN6ZlcAApuCrt
	 nIu0/nBWrJo2ERXqmiyjNCfArtWvW9cJ0z4w1Gad4Q1tKFJSRY/Cc9eHpJ0yJQ80aZ
	 +eBa7Bo49n5OMh9RPOurD9tbVbl4Vmm79L9hJdYD3tFNkY/g3VaNE9zXDtA0vf1g5V
	 jufjTzKno3n61nUA81Hxwkvpf0UFarF6yQYhX/8rDFpt5p1lMPJ52p32M96hRJ7Eas
	 njmsF5IJaWeseH2IaBHxU8kuTGVLdCHIcYxCCltqlbuyKGeVJqBL7Gnl0fxyzimUg3
	 gI7JMbWekSQpA==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1wA85V-0000000DNJ1-0MYd;
	Tue, 07 Apr 2026 17:11:33 +0200
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 0/3] wifi: refactor USB endpoint lookups
Date: Tue,  7 Apr 2026 17:11:08 +0200
Message-ID: <20260407151111.3187826-1-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the common USB helper for looking up bulk and interrupt endpoints
instead of open coding.

Johan


Changes in v2:
 - rebase on wireless-next


Johan Hovold (3):
  wifi: at76c50x: refactor endpoint lookup
  wifi: libertas: refactor endpoint lookup
  wifi: libertas_tf: refactor endpoint lookup

 drivers/net/wireless/atmel/at76c50x-usb.c     | 22 ++-------
 .../net/wireless/marvell/libertas/if_usb.c    | 33 +++++++------
 .../net/wireless/marvell/libertas_tf/if_usb.c | 46 +++++++++----------
 3 files changed, 41 insertions(+), 60 deletions(-)

-- 
2.52.0

