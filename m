Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675130;
	b=nU6WckhgrGHhbuiIbjeKalzbgedtX1ZpivBidpJHDIAnkSeNgPPIKdKQX9Vu6lXaAWbt
	 dZ+QzRawuY8Z/yeTTNkSYGfxqQVU1cl8hdZrx7qpPJg/XtBDryFVy9MPkEQdhm4i3RUPL
	 sLN8V7lhlbjzk6CumubRaD/5nMbNQFUsTrZi3QE3qHgRDOeKMfHJTCS2tQlmzDSrtdEkk
	 0xv3KT8kUlV4pQO2nFKxvoJWdKMPWXB+N5SEcbjLDRt70YDOdvTxQHIG7Q8PvjjWTHCiM
	 izbNEYMLD1al8dMtHKdEQDO/4l4JYr6VFD+7em4w54F1EFvlEQL8zKHvs6s62ZmhBQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675130;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	bh=LPhYEOOQF4rUFJW8wN7ZRT8wYVJsWzCl57fD8LWO0F4=;
	b=QnroVoU3QBEOhbTB53rn10dXou/2fZKXsJfbn6dRU6+h8fgqm084P/m6ym/fDq7o1xQ+
	 uf0HoX1iAXF1TvjIfaHi4YVdrOwh0HroMcE6dJGOzeGmxLoc/pRRlGWaa5X5WzcFXpety
	 kpoO8D+3Hmn+EyY4IjN/PDLopMh4JQIYUuINWwfH7tmYAfyfcyNyPcOxqkYzpv/pmfMor
	 OOWSRvSvpCW0gaum8o+kM41+J1TUDRQRdP18JunlIlTPN1a9SxxqtcBz6/DsFGAlEn3ZP
	 R2WaStpra1rwRlOo62WVzeU+b2ZkBj9EQC6Iza0nQ3p/CfS8tVCwK3cP1RzzXfU/QcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ChrIToJ1;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7E0606D806;
	Tue,  3 Nov 2026 03:05:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E7E0606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ChrIToJ1
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A3353v942689980, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793675104; bh=LPhYEOOQF4rUFJW8wN7ZRT8wYVJsWzCl57fD8LWO0F4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ChrIToJ1lCeLVWn4xvwACPGt8ZzwxDxXs3aZel5FqUUOiQ6UCW3LPQ8uWHzafi8Jf
	 8cEtuHKRPjz1VQB6mRlRWRvGHhnxc9SHJ75VME4cvhfvC+hUEbEPAGQoR+Jk16bbW0
	 7iI36I/cMeGddkybHLJcO9jB8V3j9imRJAzDZC2s2y2IJv6HaSF2zOd3+hA2pvl66o
	 ArjB8HJQUeoq8iDaPXVgznkpE6Dm9TRb3Gjwcmb0hMZpekSj2WxrFwMPxYIM4+fJoY
	 O2F5G3zv65yGt5hqyYgEHvkGAD/h+nxaiUSaMq2HIdo9EHgeqQBoFzzuFkQ+Nqj7nC
	 KmyaV+ik2tKTA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A3353v942689980
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:05:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:04:51 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 11:04:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>, Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723b: don't set channel_invalid in query_phy_status()
In-Reply-To: <20261009155838.169058-1-luka.gejak@linux.dev>
References: <20261009155838.169058-1-luka.gejak@linux.dev>
Message-ID: <3541a65a-6f56-4933-b86d-02c34506451c@RTKEXHMBS06.realtek.com.tw>
Date: Tue, 3 Nov 2026 11:04:46 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Luka Gejak <luka.gejak@linux.dev> wrote:

> rtw8723b_query_phy_status() sets pkt_stat->channel_invalid, which makes
> rtw_update_rx_freq_for_invalid() call rtw_update_rx_freq_from_ie() and
> overwrite rx_status->freq with rtwdev->hal.current_channel.
> rtw_update_channel() keeps the center channel in that field, not the
> primary one, so on a 40 MHz connection mac80211 is handed a frequency it
> rejects in ieee80211_rx_beacon_freq_valid() and reports beacon loss for
> beacons the driver did receive. Only beacons go through that check, so
> data traffic is unaffected.
> 
> Remove it now, so that the non-SDIO members of the 8723B family do not
> report beacon loss once they are supported. SDIO is unaffected, because
> rtw_sdio_rx_skb() copies the status into the skb before the update runs.
> 
> Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

1cca8775c2e5 wifi: rtw88: 8723b: don't set channel_invalid in query_phy_status()

---
https://github.com/pkshih/rtw.git

