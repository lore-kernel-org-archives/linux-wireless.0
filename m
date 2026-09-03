Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06D2D8364;
	Thu,  3 Sep 2026 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788399673; cv=none; b=Cu+vZhvozm2hXCPK6MAiFoYtKWb6QMXgzopxkd25thwfd/xdC8znLbXM0wX/Zyxis/SsQywDLaFJxDo5upaLKVOfnFryMdoLSF2xG7K7LMMXYBkgK0vSafIZtCegNVBnVo3PG1sN7F/tYqOonxuB4x5+FUsXeO6k+4fS3gmPGNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788399673; c=relaxed/simple;
	bh=V8bFuytzSdx0CGDkpq0sBs+XbY8wRnIcpvXcB3mCLbA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=U3lKuSH5208RpP35qXdZ2/UyvtLztefvbSRnSpQa0Dul68YVH12dbX3a1Nv8MpAq8yiB3uthi/XRsJo29oWzHf19Z6LDDXWflM5Nm6vSL87TPNmWDQF3m9pFpMJBsohSQYAFOXprbLNV/yW3JGr2l7cazPqj0kENWPHkaeT2si4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZeqVSmMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZeqVSmMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FFE1F000E9;
	Thu,  3 Sep 2026 01:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788399671;
	bh=OWl2OK8zHp4d1oHHBNS1e9zIdBRZUwaF/VJvsm3VBw8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZeqVSmMYeY54Eudn0I7lmS3Am7rQPwKnAbaEDCOhWGWPD0CDlqZAUCKqAewQpTbDu
	 HDVVq/tkVhVoYiEynqrjpuoHJ5uoVRo4kqzDzvinl2YnCRoqjXCoHEWzIu3mQGeW/1
	 mi0nD+emFMzs0U6MiUr+vhjYxSNW7z+RkhG3Ub1DL8QDJcnDf6TJF8pH79TeCn2xw/
	 gHGY4LLuNggFS0RUCvgfuu4XCVNY9oEJZAjwEsR6prNzX2ydqm3JipyZwoW2FwCr5K
	 5hR0SNBSMXjJsL9gLDh7iNtRvCNyYzUynYQjPpz8qIFBkUFNjg5WTiIvTAEWfrMLAC
	 GB1Hkq9t3mcRw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93AE23927054;
	Thu,  3 Sep 2026 01:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] net: Remove conflicting altnames for dying netns
 in
 __dev_change_net_namespace().
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178839961327.3035212.13630771412008250384.git-patchwork-notify@kernel.org>
Date: Thu, 03 Sep 2026 01:40:13 +0000
References: <20260901005550.2042357-1-kuniyu@google.com>
In-Reply-To: <20260901005550.2042357-1-kuniyu@google.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, johannes@sipsolutions.net, horms@kernel.org,
 jiri@resnulli.us, kuni1840@gmail.com, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 syzbot+74f338e09f1ef3ee6457@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Sep 2026 00:55:44 +0000 you wrote:
> syzbot reported the warning in cfg80211_pernet_exit(). [0]
> 
> The repro does the following:
> 
>   1. create two device in root netns and non-root netns
>   2. assign the same altname for the two devices
>   3. remove the non-root netns
> 
> [...]

Here is the summary with links:
  - [v1,net] net: Remove conflicting altnames for dying netns in __dev_change_net_namespace().
    https://git.kernel.org/netdev/net/c/debac3a20dec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


