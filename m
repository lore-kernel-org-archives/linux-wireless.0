Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E4F52E058
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 13:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790687530; cv=none; b=El1VU4W2klfv3M3Sws8M2LSeENcgxR/D6jUSWV8TAsk+ijJS9gjF8+pIzHufBuPT/FAQ6AwBSpxx0BezvvZvq2N/fROH+C0WwhTClN2GivJxMj5sorDOmkjZB9OalRnPghKhTxl+tdO2SCfyDm1KL3u9eBqgRTaRdHBELbMrSQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790687530; c=relaxed/simple;
	bh=RJewHKHWTGIvvzKy6VHcmN7s5hJlcSDdnhblbFQtaYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BpqK7iDShYHPlaHXMwaVgL+UxLRM2tiTiUDWt8Jgo/pFVeLr1qQqOPNojdpVJP4/O+FJ9EdD1DgAQA2Yz9QtOJ5q2c8KRyThXMM9AkLosGszHApv/AUB8lDL/aP0TxfC/+wEnmEPAo9lE4I1Ac9CM++OwPVuKQU1XZ60mJf7D8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr; spf=pass smtp.mailfrom=green-communications.fr; arc=none smtp.client-ip=212.227.126.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=green-communications.fr
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue010
 [213.165.67.103]) with ESMTPSA (Nemesis) id 1Mr8vG-1wPVp738NS-00g5OF; Tue, 29
 Sep 2026 15:12:03 +0200
Message-ID: <a50e85f8-a13b-4943-b035-0a0fd1202f60@green-communications.fr>
Date: Tue, 29 Sep 2026 15:12:02 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 2/5] wifi: cfg80211: Add helper to pack
 station-level STA_INFO
To: P Praneesh <praneesh.p@oss.qualcomm.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20260614051739.3979947-1-praneesh.p@oss.qualcomm.com>
 <20260614051739.3979947-3-praneesh.p@oss.qualcomm.com>
Content-Language: en-US, fr
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
In-Reply-To: <20260614051739.3979947-3-praneesh.p@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:2RVFtgRlPb8FbYctliR+DHq6Al5w6NSu1sLdcnaY1U7QIkq0TZ3
 q0L/mZQVdw1FZPc/beH4n1sROz4WqhBW0e211lApkAUNjgRPNQcWRcwWU0Mer5BPRtHbU3/
 TjCwZZT/aluUVCR9V+IQyuauX2gngbvaUHtq/gZVO46bH0mHf5VS4ET+1FXmOFDzXrzsv24
 ZaRiwcDeWR2sDEz6GFFlw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rtqe17K/dPw=;U1+0RhtVLw6wl3gzp2I7LyFIPmo
 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
 BFLvCrKalkj4YVf7RD2/s=

Le 14/06/2026 à 07:17, P Praneesh a écrit :
> -	sinfoattr = nla_nest_start_noflag(msg, NL80211_ATTR_STA_INFO);
> +	sinfoattr = nla_nest_start(msg, NL80211_ATTR_STA_INFO);

This change was not part of v1 and it applies to regular non-fragmented 
dumps too, the type is changed from NL80211_ATTR_STA_INFO to 
NL80211_ATTR_STA_INFO|NLA_F_NESTED.

At least iw, iwd, wpasupplicant and hostapd do not care, haven't checked 
anything else.
