Received: from mail-139-mta247.mxyeet.net (mail-139-mta247.mxyeet.net [23.172.139.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD5C372B32
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 06:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.172.139.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791182814; cv=none; b=nAo0jlvDMcEfQdvpsDgIWffDj2U4DPVrhp1kUgZR7BfEgSd8ZKmAf8uWleB5BAX5dlkb9MVWEJGYBSzbWhwsbvIxDs0K2ZC0AdJBMAbjZrhKAa8zF6Zl8aFB+BOWD4zwFmX7oekVcFjI6ZplSrTUb/C0ufBryXq2ym6iIDjXNUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791182814; c=relaxed/simple;
	bh=TNinW+JRhebAFuylBEWnK6vZV2oH/SSym98xcVEJtVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmqZzslZ7lYF4ilKTcYkMkudq/hVTWwjf6ATgLMShdvnZMutRg8i4HyazGmKn/uVyfEmk5H8c7mHC1N1Q8FWMkGvcORhZCfs7V3XDa9jM6PQqS3dsi4/FVBsH4oQ1UE/3QJoLxJ4+xJDpBEoeAOh238wHfIN95bth3XtGs4cTqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev; spf=pass smtp.mailfrom=endrik.dev; dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b=0suPi18D; arc=none smtp.client-ip=23.172.139.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=endrik.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b="0suPi18D"
Received: from lu-shared04.cpanelplatform.com [2602:faa9:3000::1006] (Authenticated sender: relay@mxyeet.net)
 by mail-139-mta247.mxyeet.net (MailFilter Outbound) with ESMTPSA id 1a10acbfdda00089d7.003
 for <linux-wireless@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 05 Oct 2026 06:41:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=endrik.dev;
	s=default; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Unsubscribe-Post:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TNinW+JRhebAFuylBEWnK6vZV2oH/SSym98xcVEJtVA=; b=0suPi18DMldeDVX8YwPEoS9ubn
	klefZbl+2Q6v+ignBD6YPf+8o/pe7f1Zu2slRD5z0p47B9w9zM4SHUTkBKiT71F5teL9zr/hMuqTA
	7QYsbjUjYWB5ORSpaF6fULBQ2u9FCI7m5KKL1bW8xwtst+shff5f13+C6MZa4Lnx6+NL7mPXOgZD3
	lVCU8AaPZvVQRea3D56a3WagvWsbqeo3BjyKcsncH4uyBH7qNvgvGSUe7igmA5B4diZYg9kPuZ/p8
	gyW+SNgWkitYfz2a4TFuUcSqXVflLriKjk1qZ/j4wLUeq3y+Ic6+stmuixTYszJwiGg8L3li/CoM7
	TOV0Zxiw==;
Received: from [85.253.174.246] (port=36680 helo=noether.localdomain)
	by lu-shared04.cpanelplatform.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <git@endrik.dev>)
	id 1xDcOL-0000000EnUD-2NpI;
	Mon, 05 Oct 2026 08:41:41 +0200
From: Endrik Einberg <git@endrik.dev>
To: netdev-bot+sinfo@kernel.org
Cc: Endrik Einberg <git@endrik.dev>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: iwlwifi: mld: include VI packets in low latency detection
Date: Mon,  5 Oct 2026 09:40:40 +0300
Message-ID: <20261005064107.145800-1-git@endrik.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <179115079203.1402591.13378681769152307097@kernel.org>
References: <179115079203.1402591.13378681769152307097@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-From-Rewrite: unmodified, there is a forwarder that points to the actual sender.
X-AuthUser: endrik@endrik.dev
X-NCN-Id: qrBpiUCfTMOkjygEbw==

Hi,

This was discovered during Wi-Fi troubleshooting with LLM assistance,
then confirmed through runtime testing and manual code inspection.

Synthetic video-priority UDP traffic did not automatically
activate low-latency mode, whereas voice-priority traffic did
(observed through the iwlmld debugfs state).

This is definitely not a theoretical bug.
Whether it causes actual noticeable performance issues is unconfirmed.

Thanks,
Endrik
