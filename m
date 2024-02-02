Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B00B4401
	for <linux-wireless@vger.kernel.org>; Fri,  2 Feb 2024 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881878; cv=none; b=lwGUKAyifhiv/kYR6JocEWP9VrHIoOwMnICESkiidp28Ka97b9HkpvxtGR7joOjIwbZod3foZhDWAm6Z6XzdBF2o2gyIBQdG8NsxveIxYhKdZpXVgihbimm5m01bLR5zItKAtfxQ6seydiZ0GJ8OXcERbmzHLDID7DHxIVWxNPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881878; c=relaxed/simple;
	bh=2u/xsY1L2si0J2WGbemdiniFW2LPrp7tHa/x+5LzCkQ=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=X3LskWxiSQ0PvCBSspikJtCc1DRQmugTaST+5MwawXffzmgIElONWAo1jHLZZJb1I2hEOHrzMGp6pEhl64gpEnvzwvfhwnQ9n7+EfG5HRvbxnhBeKx5Q0krfpGxHuZIvNCIr+ugL1IiWVbvMyIHiTmu28QvMCHcpUwjkjaSo4Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1uldy5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1uldy5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C09C433F1;
	Fri,  2 Feb 2024 13:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706881877;
	bh=2u/xsY1L2si0J2WGbemdiniFW2LPrp7tHa/x+5LzCkQ=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=j1uldy5EIqxh4o46Mou0yx/SeNrZaUungBmwNQKQa+sRRm/H+O14Cze3NQALUoSY0
	 FXprzXPBbTIr3dbrRgJoJ6mN5o1S9NkkVQhni3KltCcdSb15jeCFbD3YDsRG6E0Gbp
	 abgcyDpaG3HO+QaCeSXn99tV97c5dCOSCiRuizUlg4UmDaLJivV9k1tZ5C977KXAzH
	 7VYKWE5gmk1E54IL/g4ama3BfMqIbibQN/AKnk8xY0xqu8Lwb2Ib+LwQ/+r1/952If
	 U4qRKEsXtm2hY50M0JsjgQUfnkigk7HmFa264O/PEUC+Vx1AhYFfeFFtWpqSr9rTXt
	 dS4gECAAkRM/A==
From: Kalle Valo <kvalo@kernel.org>
To: Baochen Qiang <quic_bqiang@quicinc.com>
Cc: <ath12k@lists.infradead.org>,  <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wifi: ath12k: enable 802.11 power save mode in station
 mode
References: <20240201035830.2534-1-quic_bqiang@quicinc.com>
Date: Fri, 02 Feb 2024 15:51:15 +0200
In-Reply-To: <20240201035830.2534-1-quic_bqiang@quicinc.com> (Baochen Qiang's
	message of "Thu, 1 Feb 2024 11:58:30 +0800")
Message-ID: <875xz7t1nw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Baochen Qiang <quic_bqiang@quicinc.com> writes:

> To reduce power consumption enable 802.11 power save mode in
> station mode. This allows both radio and CPU to sleep more.
>
> Only enable the mode on WCN7850, other chips don't support it
> for now.
>
> To test that power save mode is running, run below command and
> check there is no NULL Data frame seen by a sniffer:
>         iw dev <inf> set power_save off
>
> And run below command, then check there is a NULL Data frame
> in sniffer:
>         iw dev <inf> set power_save on
>
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4
>
> Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>

This had simple conflicts in hw_params, please check:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=f776fd9ccb6561c4e4fdf05552a8b57a06686a90

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
