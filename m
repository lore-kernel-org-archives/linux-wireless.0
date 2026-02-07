Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796E42EB847
	for <linux-wireless@vger.kernel.org>; Sat,  7 Feb 2026 05:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770443763; cv=none; b=BnUsQitmZfvAJL6wxnD8iaKw3A0XA+ZtsZzVIqdKFziz+jKRPb8rU5CiwY6+s3GU1W8E6iRrvt4lxP4tx5SRc8QB52e/NONMgA6TS8Tlo5qOm+xBR+EO1B/ZNw04chM0EHpbSK8YR2jpIIGOqLKkFlN3vLkK7WjqZ7CB7lzqk9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770443763; c=relaxed/simple;
	bh=aIB+hSu2O1lISP+Y5do4kdMPm7iiCLTuWH7y2myAPXw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Rr3fAP6oD23MAHvFA8DKkv5qpKnQKrjogPetmWhLvMGj7YzwxMglD8E4kLZtvhssc92ycbVsGLQ1TdfJlxkU7e2YTjcBMLdetFdlPcTgjYAJgkg6A4Whn3BISw/TOCeL9yNWgsH3U/aUZKwaFStW1kGG9G5tk4WMFxoiu2gq86A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [10.59.18.202] (p57a7a819.dip0.t-ipconnect.de [87.167.168.25])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id CB5BB4C442FA4F;
	Sat, 07 Feb 2026 06:55:21 +0100 (CET)
Message-ID: <6a83fd12-edd8-4559-b7ba-75b074fa889f@molgen.mpg.de>
Date: Sat, 7 Feb 2026 06:55:17 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: New warning `ath10k_pci 0000:3a:00.0: not found station for peer
 stats`
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>
References: <57671b89-ec9f-4e6c-992c-45eb8e75929c@molgen.mpg.de>
Content-Language: en-US
In-Reply-To: <57671b89-ec9f-4e6c-992c-45eb8e75929c@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

[Cc: +Baochen]

Dear Linux folks,


Am 19.01.26 um 17:41 schrieb Paul Menzel:

> Since January 10th, I have started seeing the warning below in my Linux 
> logs, that reach back to September 24th, 2025:
> 
>      [   37.108902] ath10k_pci 0000:3a:00.0: not found station for peer stats
>      [   37.108906] ath10k_pci 0000:3a:00.0: failed to parse stats info tlv: -22
> 
> It started appearing with 6.19.0-rc4-00282-gb6151c4e60e5, the version 
> running before is 6.19.0-rc4-00003-g3609fa95fb0f, but I do not see 
> anything related in the commit list:
> 
>      git log --oneline 3609fa95fb0f...b6151c4e60e5
> 
> The warning log from `drivers/net/wireless/ath/ath10k/wmi-tlv.c` has 
> also been there since 2021.
> 
> Do you have an idea? Please find the output of `dmesg` attached.

Looking through the commit list from above again, commit a203dbeeca15 
(wifi: mac80211: collect station statistics earlier when disconnect) 
probably introduced the new behavior.


Kind regards,

Paul
