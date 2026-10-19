Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8356C448BA1;
	Mon, 19 Oct 2026 03:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792380695; cv=none; b=mxHiiRSynUibr4fd5TrHHOGgJwkrxlYO/KwByvNTVfUOg80+MKEegLFeWe6xL4ptyNi3apXX4/Q6ZVmUse8wpBq/075916R3d7xeMyeatpcsraOzUz4bzewkLOk9PiGQktbzDVj4RzxTNv5lB8L0WaydDEqdd8/44GbaUPUddGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792380695; c=relaxed/simple;
	bh=1jwCY/BOEG5fw56Nev1xRYapDYkK8yu1BgF9QO/jqSs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F+dm0yiEwyG92v70ziPWd0jANEa9ZmllKSyMo3OeU0c/PUxTkp1v8KGkOqyOuqcF0e3DrLh0xpamJv7oQGM9UdFIq5Zb6VTQuSJClCC+V1+H9l/fR1HS8Nrzr6My7kuddRtcfQjw+JM9ENXKv9tlPPlZ9TlvvQ+xPe3V2n7uiRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jMtF8Tte; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jMtF8Tte"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69J3VNCN01532693, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792380683; bh=gV59eG4XuETrLrV9Yg1I0w9LBhbnXmU8IoxmI1gJeg4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=jMtF8TteACLqfM7yXKYXH392K1bRCKF0eLL5T458/9PdJASQg08qfilV+/M5Elols
	 95imnSGxyajye244bZXYcSuqA4vDTF84vmLfYycYjWPo3UFzS9PSUcy82VJ4O56JeG
	 ZM0DJ0kO2Z7zNxGBFby+wKmun/iPOKPO3afm/Qa7ULAyzMKFMFWsE01xzLxk9vnW7k
	 uEnHy9zm02aGIce/blNF1AFVmXdN4WlcxJoKFS+M7NvApKeSCm5mfjle1DKqntPM71
	 ZO3DEM3fd5tMHJD5GYH/vlwIsM3PIaUI5G2osn+fNUrw6jZA2MpZQj3vecPlBfTQi8
	 c55HmL8Jrr1Dw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69J3VNCN01532693
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 11:31:23 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:31:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 11:31:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 19 Oct 2026 11:31:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdWuS02ghpGGHw90yaRSTFSDbFibcEOBOw
Date: Mon, 19 Oct 2026 03:31:23 +0000
Message-ID: <b9bdebf6dac043ce9b3e285e0d12209b@realtek.com>
References: <20261013073010.358756-1-mehmet.fide@gmail.com>
 <20261013073010.358756-3-mehmet.fide@gmail.com>
In-Reply-To: <20261013073010.358756-3-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:

[...]

>     - the downloads are paced from the first one with an absolute due tim=
e:
>       queued after each download, the countdown drifted by about 10 ms pe=
r
>       beacon interval on the ordered mac80211 workqueue, and a station
>       switched ahead of the AP on a count of 50

If you download beacon to firmware twice within a period of beacon_int,
a countdown in the air will not present, no? Like this

t (TU)                       0            100             200           300
download beacon            5                   4      3               2
firmware TX beacon           x            x               x             x
air                          5            5               3             2

The 4 is missing.

> +/* paced from the first download: a late one does not delay the next */
> +static void rtw_fw_csa_queue(struct rtw_dev *rtwdev, struct ieee80211_vi=
f *vif)
> +{
> +       u32 interval =3D ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
> +       s64 delay;
> +
> +       rtwdev->csa_due =3D ktime_add_us(rtwdev->csa_due, interval);
> +       delay =3D ktime_us_delta(rtwdev->csa_due, ktime_get());
> +       ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->csa_beacon_work=
,
> +                                    usecs_to_jiffies(max(delay, 0)));
> +}

Otherwise, looks good to me.=20

