Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8102B3BADBA;
	Mon, 30 Mar 2026 10:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774866754; cv=none; b=RUWmQbkgn8zvmsyKO29u0hZlQIxUkCpH8UuJj+o8+ZKq5FnMkRDBCpnH+USvRaUb/du8rPCAnnhBk8j3LsBqkDxgeAuEWroI/572E6/RJp1X3N6/tFnw8hhYO7/W0mcAefFTO4tm0lFtG0xtCjtibq/YuwafBUIqSL2JIUvaOb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774866754; c=relaxed/simple;
	bh=bpJ677p2Y9LLptYgExhu1ofjrXWw3XJXeP1nje2Y9X0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=up2vMA6z1/2AQyFNuQag++WNazYnuC+OepOmq8VOjxWTlc77H6qXo1fvN9SSaVDvWfDoVvzfX90tPiizudDgF9hpCo7jsAeFCSHAQlRXgqz3xwWSmlFXretTtE/EiWPlX6FdLp8w+QwR4Y1ABAaWXmsOPJuum2cetkQ3B4mDCOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JpskT9vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JpskT9vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384D1C4CEF7;
	Mon, 30 Mar 2026 10:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774866754;
	bh=bpJ677p2Y9LLptYgExhu1ofjrXWw3XJXeP1nje2Y9X0=;
	h=From:To:Cc:Subject:Date:From;
	b=JpskT9viAtTtv+pIJBFC+Fj0cQHNmYG3reNtm7H7iTgNG6tkDU11+4j88SRmuAMOZ
	 IGL9wv6wa+XN1Rkglbd25INQbMNLU/mO0eqGVUeTVQQ7NB2J6QKymP0TDmnw00FXY0
	 E4MY1YQA7YrqAPcJ0OeuQ7WtMd9xrccJzWLuK6+qkmUPeJB4ZHJ0wHcD6M+6IG18Pb
	 kR1VLYpIazV5+v79pfOdFMcX/AtOXSffvTB3PI7Sgl8ma0fINHicWV4sfSbf5fvnIY
	 7+v8YjiPMiRyhvwJCLIN6d8O7NNbI8zvZFqQJm4ZWzA5d7p4S6rph+2Kgo14D1Yf2h
	 Cdhuw5CIRZ26Q==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1w79v6-000000070x6-0KmN;
	Mon, 30 Mar 2026 12:32:32 +0200
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/3] wifi: refactor USB endpoint lookups
Date: Mon, 30 Mar 2026 12:32:04 +0200
Message-ID: <20260330103207.1671926-1-johan@kernel.org>
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

