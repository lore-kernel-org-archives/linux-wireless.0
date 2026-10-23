Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.244.194.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792742616;
	b=qAtzsW22ZtdjVcwLaCD7bLN2xydJ8y0plU2HHm1fU8d9j5g07pOSuHmZUpUhEh5YsbFc
	 BtZRCVnq/DX84PLt2F4t2d6IeU8QVY1TErGvHAeiKdujgvFs+d+sDZquz3dY8wY9W7+Wz
	 h12CKKx12gKWfcA14njCX3by7wGlyTuYY4qM5VJ5IZ+pSo9Ay+gQYZvQN4dinWITqZ5x8
	 fVSteak3kjjohAvnxQYJolYZUrgLvOeZyluXuLA5hfgAyuAOg7cg6FWBMWEh6VGKGr3Zz
	 qEEkaDiAf+Tcmd77o4JpWalvYwyBVo7D0qmxpiRZfLpXdyhLMqlRLhCNImetRBB1BaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792742616;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received-SPF:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-PPP-Message-ID:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-NC-CID;
	bh=s1gTEjF5l3cNLfTPFBPubP5rXcUxTgsvBTvFcOzR7vI=;
	b=yE7StfY+ZeCZzdXbMBiuj2tlsREOOMPLVUk0gSGFoVnmxWMhpEovwQItR8EQeuHdcAMF
	 oYYyMgVYvGcMZ36WZ7O1cZxgHWWKJXt70JzedUGNeA0Z0IJsLnsbDdNujPjJctqxfo1Mp
	 XNq4hx4g2CcGTql8/GwCnwAlsAXUnP1RQaZBPkGkLELBar0eV6F3LPl/C19x3K72kDQ1S
	 0hO6bbNd1Sh4T8D3wUd1ZrHCmD5Z/PO2BNIqGKYX91fj8EpLgwM3UcFcqWyb5LH3RIxuw
	 VUE+dnb+iocbqgCzKXrc8LX6m+rcVEdhb+KyaAJaSbqyvFxKzihRk3djiEKh5KUX7Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leemhuis.info;
	spf=pass smtp.mailfrom=leemhuis.info;
	dkim=pass header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=M3au7dUE;
	arc=none smtp.remote-ip=185.244.194.184
Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [185.244.194.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719C7606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 08:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 719C7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leemhuis.info header.i=@leemhuis.info header.a=rsa-sha256 header.s=key2 header.b=M3au7dUE
Received: from relay01-mors.netcup.net (localhost [127.0.0.1])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4j9wWM6DwTz9ZqZ;
	Fri, 23 Oct 2026 10:03:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1792742607;
	bh=s1gTEjF5l3cNLfTPFBPubP5rXcUxTgsvBTvFcOzR7vI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M3au7dUEYRt7VacrMmIVy1Ti/GKhc+c/rFOzLSgkbKlfgGVWWdyAW8lEoE/m5JGWm
	 PvVzJ5ZFmHvbqG6gexzCuHm6wgkI+s/nl3iRqfExNy7HgfZTwthjfxrBTBYY0lUQAT
	 3g7LN0BbYogjxmQMnOkqChfm7akgPNJM1FKTVzQLIvsE8y4+rml+86xefFTrCtHpRc
	 pILhyEFW0TqCDFR0tMkS0on708lKHVOKEQrrkQfS0YeEFrl9NgcoIUKuF6zU4FAfg8
	 4x/bPs3701XTjQoXU+hJqWhR5L5hKHqqQ6WVsMdpOQqkdkj6W6vh6+PorkR2EcZJ+x
	 OG4mb5OUvxCGg==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by relay01-mors.netcup.net (Postfix) with ESMTPS id 4j9wWM5X0Dz7xdj;
	Fri, 23 Oct 2026 10:03:27 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4j9wWL3y5jz8sb3;
	Fri, 23 Oct 2026 10:03:26 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 8ECD85F9FC;
	Fri, 23 Oct 2026 10:03:00 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <f32dfa8b-fc3e-4d8e-a010-20e822ed0c08@leemhuis.info>
Date: Fri, 23 Oct 2026 10:02:59 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mac80211_hwsim: beacons stop after host suspend
 (beacon_timer is CLOCK_MONOTONIC, expiry computed in boottime)
To: =?UTF-8?Q?Lo=C3=AFc_KASSEL?= <loic.kassel@gmail.com>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Berg <benjamin.berg@intel.com>, linux-wireless@vger.kernel.org,
 regressions@lists.linux.dev
References: 
 <CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: 
 <179274258092.1091304.11815514332012150800@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 8ECD85F9FC
X-NC-CID: bHaKrTAahpzEaoxWAmf/YdJC+XGDJzfWnydqnO3hVLp/Wlim6Ps=

On 10/18/26 01:12, Loïc KASSEL wrote:
> Since 7.2, mac80211_hwsim radios in AP mode stop sending beacons
> after the host has been suspended once. A single beacon goes out
> roughly every <time spent in suspend> instead of every beacon
> interval, so stations see massive beacon loss, scans come back empty
> and APs without associated stations become invisible.> [...]

Thx for this and the other report you just sent minutes later. Sadly
nobody that is and expert in this area replied yet. With a bit of luck
my reply will change that, maybe not. Whatever it is, there are two
things you could do:

- Test if a current mainline snapshot as of now is improved (the wifi
changes were merged just a few hours ago) or wait till 7.4-rc1 and test
that -- maybe it fixes things.

- If not, test with a current mainline snapshot or 7.4-rc1 if the
problems can be fixed by a revert.

Please report your reports individually for both problems.

Ciao, Thorsten
