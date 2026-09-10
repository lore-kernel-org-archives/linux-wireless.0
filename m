Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608C82E542C;
	Thu, 10 Sep 2026 01:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789003563; cv=none; b=DSJ1vPpjIQmsk0upPs/7WrrqlxoMUBzODyBP/vZaROUV9ed4NQ/I8+b//WM1XfXvvlJLaTGbZazArIHoOu3CASuGwhAtwz0cCFGviXiVM1KZ1pMBwI3xgGum71SexvnEUhN8LFdncebyl6Y+fEZ3kA4yNrDNE0Jn5F7SQ34laG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789003563; c=relaxed/simple;
	bh=jhd0Va++Xq+KrLfkFa1hwh08URWnVLrQy+H/dD6sweM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hekmO7owPDjVlX7ymrRsvQHpQnYADReCg/j2/cZsCgxXaibiivSxCy0YMKY35W97XAgRCgiejyn4JWpk5kGf7ruej3DO0M62CQEuvbVzdke63gNZp1fI78bLw6r3qzU27k5xoaOuQqK1D2teR0D2NRpjmKotRkyHxycUD2XtvLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HUHnuyrq; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HUHnuyrq"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68A1PqxP61085891, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789003553; bh=W4/U71XnEyMf+c/VGUJo6wp/e96rKbiInByRRbFXArk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HUHnuyrqy0CVsicANrHbKaULdReJS2qcyjnN7sCk9WQPBD3oxa07zDqFGvBoGhqA5
	 zhy0WzLmYIQxN/5xoOS1Q2vrbk2fjSmcfCYWb3mSJzqpiA+TxRoLggdEV1U7UT/How
	 lY4yPDk3ZGuXuIYR+exzsjQBNLBBAVWydTO9N2sbF7nzzTcfRjVSAkXlwNNPDDaHKk
	 nh9A9gmNwin5T1xNS3b8ZxddXw2j69fxXvfZqrkJ7HcbhM44an7IaQYLjZfp3TQT8k
	 NxTdNxm6mPZTZV+qzZQCLebzz8fQuMKCsdgI1bKzfzew8LxQpyZywsUqUj36qNVj4l
	 W/We7jt5r9xfw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68A1PqxP61085891
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 09:25:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 10 Sep 2026 09:25:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 10 Sep 2026 09:25:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 10 Sep 2026 09:25:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v2 2/3] wifi: rtw88: usb: only let the frames a
 dozing station needs use the after-DTIM queue
Thread-Topic: [PATCH rtw-next v2 2/3] wifi: rtw88: usb: only let the frames a
 dozing station needs use the after-DTIM queue
Thread-Index: AQHdPvxc4sLTU/QLPUKNh+As03ZVoLbHCBGw
Date: Thu, 10 Sep 2026 01:25:47 +0000
Message-ID: <9a3e0b3521304f54bc07d78a614583f8@realtek.com>
References: <20260907190901.1056945-1-mehmet.fide@gmail.com>
 <20260907190901.1056945-3-mehmet.fide@gmail.com>
In-Reply-To: <20260907190901.1056945-3-mehmet.fide@gmail.com>
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
> +static bool rtw_usb_bmc_needs_dtim(struct sk_buff *skb)
> +{
> +       struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> +       struct udphdr *udphdr;
> +
> +       if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
> +               return true;
> +
> +       if (skb->protocol =3D=3D htons(ETH_P_ARP))
> +               return true;
> +
> +       if (skb->protocol !=3D htons(ETH_P_IP) ||
> +           ip_hdr(skb)->protocol !=3D IPPROTO_UDP)

Prefer to list them in positive way.

	if (skb->protocol =3D=3D htons(ETH_P_IP) &&
	    ip_hdr(skb)->protocol =3D=3D IPPROTO_UDP) {
		udphdr =3D udp_hdr(skb);

		return udphdr->dest =3D=3D htons(67) || udphdr->dest =3D=3D htons(68);
	}

	return false;=09

> +               return false;
> +
> +       udphdr =3D udp_hdr(skb);
> +
> +       return udphdr->dest =3D=3D htons(67) || udphdr->dest =3D=3D htons=
(68);
> +}
> +



