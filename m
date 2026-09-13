Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DE839BFFE;
	Sun, 13 Sep 2026 09:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.38.247.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789290257; cv=none; b=PMPVpKQho9T6afPzjWyExEVbuZqXMF+S56QMjHD1omEIM/5sO0b21xoJc/UFaTHQpR+5nTCBaiQ8YRx2wkEwYQvYgk12kmBx36cZJc5886lpvhPeFJ1Bhp5I0I4KaJJrpm2X0C5ex5NSQdU1n4P1fSv0jEfuQL0JjilfGqH66PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789290257; c=relaxed/simple;
	bh=FqRABiScQWTUVxOxsOnT35qcLBrYzvgdptPhwHgTIIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsyT++4LWMzSiHWXS6lcFXD71lNumBw+arq/A+S+BaKbqoo6Kw8HZdSLqaCyEti+g9rvIYlHVxPIxAw/AXb/s1t9ncphrtfwfvgyeRowWwlraJ3q9leeWHdc5BaUz+3r6NgrcEXUyi/5mDtevMrBzZ0G7tcmO8trTyyOua/It+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=NfDXsNLY; arc=none smtp.client-ip=46.38.247.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="NfDXsNLY"
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4hjMlq2FQTz8LkW;
	Sun, 13 Sep 2026 11:04:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1789290247;
	bh=FqRABiScQWTUVxOxsOnT35qcLBrYzvgdptPhwHgTIIM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NfDXsNLYDv6qLkPrEgyeVTdyerUILbYpsDpfWE5+PsIrPdxtm+3aLA1UCvJOazLNG
	 BD/LrEWI3wAA3eV3Ph3i1uHcsF27Q+UwAp/N6ghx+BbZNMjvaoDJQELP80LEBy2CgA
	 iAPsoDVa5tyeRpR1vIgBdw4C1Xxa4Ph82PEvsHev6QcTMbdh6vX004jjTkoF5F80Yc
	 cyadQ03vP7FSrb7ulUUSY0ffwfke47+szcYNy9WJbIQ5T7kjAAQzSrvj3fQdutdHkE
	 x7odM0CR6up4uAQl0qXF637gk/WmMfgnmIQuIoh6U3fQ2wTURXokAs6xVAU9tMooef
	 fyeCLY4qIVLag==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4hjMlq1XDwz5012;
	Sun, 13 Sep 2026 11:04:07 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hjMlp5Cjyz8tHq;
	Sun, 13 Sep 2026 11:04:06 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id DA63C5FAA6;
	Sun, 13 Sep 2026 11:03:57 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <2741f995-dca0-4645-848c-34752d62574f@leemhuis.info>
Date: Sun, 13 Sep 2026 11:03:57 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ath12k suspend/resume breakage on 7.3-rc2
To: Takashi Iwai <tiwai@suse.de>, Chris Lew <christopher.lew@oss.qualcomm.com>
Cc: Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
 Pranav Mahesh Phansalkar <pranav.phansalkar@oss.qualcomm.com>,
 netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <87a4plsg4w.wl-tiwai@suse.de> <878q55sfxo.wl-tiwai@suse.de>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <878q55sfxo.wl-tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178929023825.1374849.273701538115019544@mxe9fb.netcup.net>
X-NC-CID: nzkLd+oddwYESOweEoSZjOL4kVB7Z+cQ0KIRx63bqlfq7OVK+p8=

On 9/13/26 10:39, Takashi Iwai wrote:
> On Sun, 13 Sep 2026 10:35:27 +0200,
> Takashi Iwai wrote:
>>
>> on 7.3-rc2, the suspend/resume of ath12k WiFi on Lenovo Thinkpad T14s
>> Gen6 AMD model is broken.  Upon suspend, the network isn't recovered,
>> and the desktop got eventually frozen.
>>
>> The git bisect pointed to the commit
>> 544d85de4dc22c01badfd8cefa59829ce35c4858
>>     net: qrtr: Send HELLO message on endpoint register
>>
>> and reverting this fixed the problem.
>>
>> Below is the (stripped) dmesg output after the resume showing the
>> problem.
>>
>> As far as I understand, the problem seems to be the change of the code
>> flow: ath12k uses mhi_power_down_keep_dev() during suspend, so the
>> qcom_mhi_qrtr_remove() and *_probe() won't be called.  This makes the
>> driver endlessly waiting for the HELLO handshake upon resume with the
>> commit above.
> 
> ... and below is a quick fix I tested.  It seems working so far.
Not my area of expertise, as you know, but have you see this fix for the
culprit? Or is your problem a different one?

net: qrtr: resend HELLO on MHI resume
https://lore.kernel.org/all/20260909055846.16539-1-daniel@quora.org/

Ciao, Thorsten

