Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573209;
	b=ggWPdwgEzOe3dfzMLorkqAFjqEzUpXQB3W0dJn9ytgFt8iq6uFGyxo2klYPK7GRJEpGf
	 lPR7n61BustlohsV4z5p5QAKqx/kPM6D3ZdyMZFEm1sI50bfhfC43zovLTFIskhEV3VcB
	 AzC+gQ/kS6kdZMnipLgFmUhnCFEFSbarw5d12E3PbCnzGSW6yoGWE9PjpCUpJ9CVEa+xa
	 iDzQ8oL9vVoVeD+EdOaxVqOad49T8Pi86hD+BRvgDBA5dTr9cZ91maXGyVZCSpqs4uBDs
	 V+EJu3rCU4DCgrJZ0b4CeoHioaMKz8J1u0MkZxwd6SrWGN89P+ZWvHQOk0gvPbSKWTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573209;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=/yaSKcMzzUv1sUGM7pbJj+MEVMbViDlM59nBQJXp4jA=;
	b=3KAKS3z1hNefWpEzzcGvUOxPLc24J3v418iwXAlwEdUtfohevGzhiw0IwQVhii2YelPK
	 LcHAVFbbsWZZII0eurI9ZZW1kw3y0wVmfGFf0dhDaGK1/9tAY6x2KinKrzBiAYSKTTkxw
	 HW5e4bBG8sBMpDj2bn2PN6BkNMXp/F9euA/MnKCmsGKr+QgeoxSBw5RrQSz+Z0wax74O8
	 CM9hzuQO9ao36jmJ7/xWF+m6ZYeOsTahKlib9BhUMFAyP6KfVmWk5STXAU89wa0Lhj4/5
	 b6MnwrANft4EfIzS9vwI+j8Du6zItmPIX6ZrGEERBuJjEjj8BkrUpfUvCDGPqqvgmFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUxJhuXC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A23606A319;
	Wed, 21 Oct 2026 09:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lUxJhuXC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E1B1F000CA;
	Wed, 21 Oct 2026 09:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792573209;
	bh=/yaSKcMzzUv1sUGM7pbJj+MEVMbViDlM59nBQJXp4jA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lUxJhuXC7YcBKH+fp0LQjyJ8CJ8vm9f9kDqkA/29OchKKpycb9dsgZlTCe2sQC4CC
	 CuXNlMUUXQgaP143VRvRpHr6aqfr2eQiFB+pyUoHu7VBRFD4MbqFDD851TSpVdaPgQ
	 4vm0G5Ucp8t4QoKLIMLE4tUjBzdtKavHYvCs+86ne3dvLB5kiEEl5xnvYwFIMtIdBT
	 c5BQT0s/Cx19P67gQNESlmT1abOWG6fX0aOWLtYQdtcPF15/2Q9qLSToETgOUfdy8F
	 9BLD7kGOU1qeRtPs7c0Sjq+InxVqXeioXnOsKI3gAA01SlmW3j+1QrUAV3gklKbmgk
	 iLR+MKpUKYJ2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14543809A12;
	Wed, 21 Oct 2026 09:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v11 0/6] rtnetlink: dump link-layer multicast
 addresses
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179257320752.497899.5250896275273758269.git-patchwork-notify@kernel.org>
Date: Wed, 21 Oct 2026 09:00:07 +0000
References: <20261012011707.3378-1-sigefriedhyy@gmail.com>
In-Reply-To: <20261012011707.3378-1-sigefriedhyy@gmail.com>
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com,
 andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net,
 dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com,
 idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org,
 johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com,
 kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com,
 pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org,
 sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 12 Oct 2026 10:17:01 +0900 you wrote:
> "ip maddr show" prints link-layer, IPv4 and IPv6 entries. The IPv4 and
> IPv6 ones come over netlink today, with IFA_MC_USERS for the user count.
> The link-layer list, dev->mc, is only exported via /proc/net/dev_mcast,
> so iproute2 and other users still parse procfs for it.
> 
> This series adds the AF_PACKET family to RTM_GETMULTICAST so that the
> link-layer multicast addresses are reported the same way. Patch 4 dumps
> dev->mc in the ifaddrmsg format of the IPv4 and IPv6 dumps: IFA_MULTICAST
> carries the address, IFA_MC_USERS the reference count and a new
> IFA_F_GLOBAL flag marks entries added explicitly, the "static" column of
> /proc/net/dev_mcast. ifa_index limits the dump to one device and
> IFA_TARGET_NETNSID selects another netns. Patches 2 and 3 add a
> generation counter for dev->mc changes so a multi-part dump reports
> NLM_F_DUMP_INTR like the IPv4 and IPv6 ones. Patches 1 and 5 update the
> rt-addr spec and patch 6 adds a selftest.
> 
> [...]

Here is the summary with links:
  - [net-next,v11,1/6] netlink: specs: rt-addr: fix the type of target-netnsid
    https://git.kernel.org/netdev/net-next/c/bc6728374478
  - [net-next,v11,2/6] net: change netdev_hw_addr_list count through helpers
    https://git.kernel.org/netdev/net-next/c/778a262a6c69
  - [net-next,v11,3/6] net: add a generation counter for dev->mc changes
    https://git.kernel.org/netdev/net-next/c/646cb8868bd2
  - [net-next,v11,4/6] net: add AF_PACKET multicast dumps
    https://git.kernel.org/netdev/net-next/c/ebff14be20c3
  - [net-next,v11,5/6] netlink: specs: rt-addr: document AF_PACKET multicast dumps
    https://git.kernel.org/netdev/net-next/c/48191155c538
  - [net-next,v11,6/6] selftests: net: test AF_PACKET multicast dumps
    https://git.kernel.org/netdev/net-next/c/0e87a4a83e13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


