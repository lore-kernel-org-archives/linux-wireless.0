Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880535DA40;
	Tue, 21 Jul 2026 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662856; cv=none; b=GAi6iSuWEtPIa9YyJWwI3ftFupA/+ZshcsFDSE2Pptl26KuktmQvSM6T/bMZssMx7bkmmToOwSZbwzOcjpnvOnJBC8sE4JjcJ1+W6kHyfqH+Ex9Lo0uS4vWAntMF57rTP+u5YDLghNq+/wcQgOoZaBRdol5iGZxNGCgJNqG17eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662856; c=relaxed/simple;
	bh=mLndIzFzABmlklm5FdH4epA9skLmDxTmhuz2UM1/aAk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VRvt0Wkw8U9XQ0lCUXrisSBpjdEKh5PQj910+kjOllefSumHHTGxTwJmHxH6SUA9JI9lZoiH3XzqFNJBJzHIdjk9Md7Bvq9gaPr1IWyRnvE/9BXAhUKPgZAcDjm8oBM3B8xtyYx/B9NhlI0Pt7wZ3TiI0S3JgXjMfVMeSd/qJIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezzXYzWY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezzXYzWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDBA1F000E9;
	Tue, 21 Jul 2026 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784662855;
	bh=osUbJg5zacfOql4e5w3uR0b08xBhV45dDVnEgTWUGdE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ezzXYzWY8cPuBi1rf9oA/zwKRvNwOIzTpnTMrf9bL+SLDOvbJjn1WQCpeK2X/fNZ1
	 snU1iWALahPLCdd7mpBsRDFrbd1ukYtipkSGeb5cL7FjmXtCyrGmWOFCKVrkbfaP1/
	 g2G0hXrbSVWBQPCE/3shiuVzxVlR/9vfsvvyd0O4uYZteenmDduQfycLT/tzTMGsgC
	 TramDRU8/yFlAR3q734EIZLZaa5a9Aoy41EcxBYnEpcW+ZJPsqOlqSKxSAwXMaXpWS
	 v9maxsl/ANk1Z+zmHwcwYFv7jRdZhJ+/EePRT9eNMOdSu+vG1zQqBFg/lZDRzg74aY
	 /BgsWtRMoCtcg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B9739253FD;
	Tue, 21 Jul 2026 19:40:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] align IPv4 teardown with IPv6 and fix
 driver
 regressions
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178466282488.1001510.7257007307370291814.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jul 2026 19:40:24 +0000
References: <20260711005405.2861680-1-yuyanghuang@google.com>
In-Reply-To: <20260711005405.2861680-1-yuyanghuang@google.com>
To: Yuyang Huang <yuyanghuang@google.com>
Cc: davem@davemloft.net, andrew+netdev@lunn.ch, dsahern@kernel.org,
 enachman@marvell.com, edumazet@google.com, idosch@nvidia.com,
 kuba@kernel.org, johannes@sipsolutions.net, pabeni@redhat.com,
 horms@kernel.org, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 11 Jul 2026 09:54:01 +0900 you wrote:
> This series aligns the IPv4 address teardown sequence with IPv6 by clearing
> dev->ip_ptr early in inetdev_destroy() before freeing the multicast list and
> individual IP addresses. This prevents RCU readers from accessing a partially
> destroyed in_device structure.
> 
> However, clearing dev->ip_ptr early causes __in_dev_get_rtnl() to return NULL
> during the notifier loop in inetdev_destroy(). This causes regressions in
> some drivers (prestera and mac80211) that use this lookup helper in their
> inetaddr notifier callbacks.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: prestera: ignore duplicate RIF destruction events
    https://git.kernel.org/netdev/net-next/c/3cbbc9fa3338
  - [net-next,v2,2/3] wifi: mac80211: use ifa_dev from event argument
    https://git.kernel.org/netdev/net-next/c/e5b14e9ae82b
  - [net-next,v2,3/3] net: ipv4: clear dev->ip_ptr before destroying inetdev
    https://git.kernel.org/netdev/net-next/c/aa22336b76b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


