Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792553715;
	b=T9j8bSAnYN3KgU5Tenhn3avii22VmHQJM9yilXv5EfywrwsZdl4ddNHhrgc1tc1qtP1z
	 6KZFukx3xRH0y4w/Td8fxBMeBLjFOD3SggrnW7n4j6z9y7OHxrRXuQwif3FiRQZqPc0Rd
	 UY/WIFVhy3kk4pGNrcK8oTI66EA20pBauQVLF0Q2NCaTQRv+dhILFW7Nlv/c15tX/YvYf
	 DaK6DGDnUf0dkW9/5xq+SWkDZamLbD8+QzFLqwlB/dDXv9zYbr8BmKsnNn01/Nus3tu7i
	 39Yz6V4RiA1NU8P4wZQT4gw2krKZa9/0APrA9AkFQm9vLXWroTT3Lf77I1gbK2IuMWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792553715;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=MD0CiyIwKoZdpWZGqUBydtzwkOb7WcLRSgRiGKInNhs=;
	b=m7+ZpgwI7I3xQuYXpeY37BZgdwWkIK4mCzh6j/8nLWd9p9nneVSZfrqSJjLjtVtB0md9
	 P8iMB6J/Ur3Zscao4+B1TSbe0oy5W7Gles7MpDduj9HDQqomKDicre6xVI+93lOg3QJUv
	 c7PQdXvoWpX6mygogzl67mTNlW4bc9dqsEPw9lZKIkzPUY1RZeNiFe74em9FkkHQZMeRS
	 f12uKvKEDNEv4BLX7u7ShK1pHvB2lbnX9zcPaeTSwzB/Ljmq/6PnAJVNpxjb9SsBsLpE6
	 L3ZHaer7mI01CXefd6eU7XTc9sFHCHOS4nyZKzjaDWLl2sfYA/QbtHN1WG8U12vQE3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=RWmoeuja;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EA5606A320;
	Wed, 21 Oct 2026 03:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1EA5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=RWmoeuja
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69L3Z4wI43664481, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792553704; bh=MD0CiyIwKoZdpWZGqUBydtzwkOb7WcLRSgRiGKInNhs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=RWmoeujaU8hUzf8V/DyNEX6TqgX13WIOVsRIhH4yFbfI723XTlZXqvUvO5G8FXDlF
	 ulWatLXdpGKF9hYTQ6IjmSGKuhi1S33cFLELNvVRiYtnRA3sNqE8YRlWMtpHHk1PjC
	 F4dHNIIaBKJHQCVRt0BZ64BltrnYnrfKIQW0e6MiRujlRrihIP5ekhVoQlRFQXZVxu
	 GaHBAQr+ZkM98qIljkpjZiTa6EOS235HCOrIjz9m1kTB2In/Dg2SpgBZky3xrCTAKb
	 ES8EpofLdIoECYLC33zpP2qstt3Q4DfBgl9B5qqQgaQlNTQYatLOCUhSqatEdldSxm
	 aFwFdSKS4YnnQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69L3Z4wI43664481
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Oct 2026 11:35:04 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:35:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 11:35:04 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 21 Oct 2026 11:35:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v7 3/3] wifi: rtw88: time the countdown downloads
 from the TBTT
Thread-Topic: [PATCH rtw-next v7 3/3] wifi: rtw88: time the countdown
 downloads from the TBTT
Thread-Index: AQHdYNQ1myp/Ong7VE6fzH/GjV6vILcHTQBA
Date: Wed, 21 Oct 2026 03:35:03 +0000
Message-ID: <f61cfbcd59cd441da59a16db52512897@realtek.com>
References: <20261020204712.3252023-1-mehmet.fide@gmail.com>
 <20261020204712.3252023-4-mehmet.fide@gmail.com>
In-Reply-To: <20261020204712.3252023-4-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:
+/* the beaconing interface is always on port 0 */

Move into function? Or just mention this in commit message.

+static u64 rtw_fw_read_tsf(struct rtw_dev *rtwdev)
+{
+       u32 hi, lo;
+
+       do {
+               hi =3D rtw_read32(rtwdev, REG_TSFTR + 4);
+               lo =3D rtw_read32(rtwdev, REG_TSFTR);
+       } while (hi !=3D rtw_read32(rtwdev, REG_TSFTR + 4));

How about setting a retry limit? Consider if hardware goes wrong
suddenly returning random number, I'm afraid it becomes infinite
loop. As my thought, at most it needs one time retry.

+
+       return ((u64)hi << 32) | lo;
+}
+
>  static void rtw_fw_csa_queue(struct rtw_dev *rtwdev, struct ieee80211_vi=
f *vif)
>  {
>         u32 interval =3D ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
> +       u64 tsf =3D rtw_fw_read_tsf(rtwdev);
>         s64 delay;
> +       u32 rem;
>=20
> -       rtwdev->csa_due =3D ktime_add_us(rtwdev->csa_due, interval);
> -       delay =3D ktime_us_delta(rtwdev->csa_due, ktime_get());
> +       rtwdev->csa_tbtt +=3D interval;
> +       delay =3D rtwdev->csa_tbtt + RTW_CSA_TBTT_MARGIN_US - tsf;
> +       if (delay > interval + RTW_CSA_TBTT_MARGIN_US ||
> +           delay < -(s64)interval) {
> +               /* the TSF jumped: restart from the next TBTT */
> +               div_u64_rem(tsf, interval, &rem);
> +               rtwdev->csa_tbtt =3D tsf - rem + interval;
> +               delay =3D rtwdev->csa_tbtt + RTW_CSA_TBTT_MARGIN_US - tsf=
;
> +       }

an empty line

>         ieee80211_queue_delayed_work(rtwdev->hw, &rtwdev->csa_beacon_work=
,
>                                      usecs_to_jiffies(max(delay, 0)));
>  }
>=20
>  void rtw_fw_csa_start(struct rtw_dev *rtwdev, struct ieee80211_vif *vif)
>  {
> +       u32 interval =3D ieee80211_tu_to_usec(vif->bss_conf.beacon_int);
> +       u32 rem;
> +
>         lockdep_assert_held(&rtwdev->mutex);
>=20
>         if (rtwdev->csa_vif =3D=3D vif)
>                 return;
>=20
>         rtwdev->csa_vif =3D vif;

an empty line

> -       rtwdev->csa_due =3D ktime_get();
> +       rtwdev->csa_tbtt =3D rtw_fw_read_tsf(rtwdev);
> +       div_u64_rem(rtwdev->csa_tbtt, interval, &rem);
> +       rtwdev->csa_tbtt -=3D rem;
> +       /* a TBTT that just passed may have sent the first count already =
*/
> +       if (rem < RTW_CSA_TBTT_MARGIN_US)
> +               rtwdev->csa_tbtt -=3D interval;

an empty line

>         rtw_fw_csa_queue(rtwdev, vif);

The csa_tbtt is just read from register and adjusted to what you want,
but in rtw_fw_csa_queue() it reads again and adjust. Can you reduce it?
How about adding an argument to tell rtw_fw_csa_queue() that this is first
time to initialize csa_tbtt (like the restart case)?

>  }



