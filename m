Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338C1379C35;
	Wed, 30 Sep 2026 03:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790739247; cv=none; b=oBu0ZhU1og+lT47AoeQabSFj6qWutFlxB7G3RfAksTENQI3UiMoWrKkpnjNTxF7JWp+ldGAFjsfUNwsc/JAlK8LFts6Nsl4Iv/JSIwO4+a/XEM9jTAwdWciQIXQwaaUPP4fkQCqv3B17Ev7Zv8/7morQcVrUcZuax6onbaQQVYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790739247; c=relaxed/simple;
	bh=cYDxJBfCZJ9btjtb8K4M+lNPgp1iJuCgBmGq25RIFlE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Scu0lMfXhNOG7nZ5Tjs5W2Ew9oDxTuoX8ciOeu8N9GxRFXNIspeUggeabNj+cqlR6YipXoIcPJxnf91m3cfdUdsHxKDgRbR3ggcTd5tzSuHjEYA6urLaeXUaIGgC/WDTJ/Um+XPVFRD/BI8LgzpUmzCWjA1GkYJqCmpeLL23lgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Ja0UenoS; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Ja0UenoS"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U3XgArA1810770, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790739222; bh=cYDxJBfCZJ9btjtb8K4M+lNPgp1iJuCgBmGq25RIFlE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Ja0UenoS6QW6LuY1/5V78ygzhMbWWkFUKyF1gX253MKdU0luZbPCeBygpfzSORuDy
	 yrvPBwGwV3fzz1g7d4mJnBuXSkZYxOQJb2wVBzf9rCo2angVazdIhLqG1h+vMH7Ako
	 Y9mlNseRcGTqd/u6MyGh2iSjecdbAR1FKShl1wIAGUyInlr+89Qoflo0PDIIfIYXP3
	 4l9NXTx227t3FjuHhJqOBwKTbOAxWZk9ptZ2CH6zJl43NY+wGRcdZqI6RhYxF2596I
	 hYwWD91pReQBd1hTxSWlVzB8xtpudHGKT53s6t0NkT5G5BJMY8CnpMcJUo+wVQkpSu
	 DMEjXt8O8DzEQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U3XgArA1810770
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 30 Sep 2026 11:33:42 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 11:33:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 11:33:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 30 Sep 2026 11:33:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Luka Gejak <luka.gejak@linux.dev>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next 1/2] wifi: rtw88: download the beacon the
 reserved page was built with
Thread-Topic: [PATCH rtw-next 1/2] wifi: rtw88: download the beacon the
 reserved page was built with
Thread-Index: AQHdUBA48OPMXZpqXUiisrFyA+l6VrblZnUAgAAf0ACAAO6eoA==
Date: Wed, 30 Sep 2026 03:33:42 +0000
Message-ID: <fd3beaf9c2e34b03890707e4dc663ef7@realtek.com>
References: <20260929191136.1315-1-luka.gejak@linux.dev>
 <20260929210529.1848479-1-mehmet.fide@gmail.com>
In-Reply-To: <20260929210529.1848479-1-mehmet.fide@gmail.com>
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
> Hi Luka,
>=20
> On 2026-09-29 Luka Gejak wrote:
> > This breaks hardware scan offload while an AP is active.
> >
> > rtw_download_beacon() no longer fetches a beacon of its own. It reads
> > rsvd_pkt->skb, and rtw_fw_download_rsvd_page() clears that skb right
> > before it returns:
> [...]
> > Could the scan path fetch its own beacon, or could the retained skb be
> > released only after the standalone download, with care taken to not
> > advance the CSA countdown twice?
>=20
> Thanks, you are right: I checked the callers of
> rtw_fw_download_rsvd_page() and missed rtw_hw_scan_offload().
>=20
> v2 takes your first option. rtw_build_rsvd_page() hands the page-0
> beacon skb out to rtw_fw_download_rsvd_page(), which passes it to
> rtw_download_beacon() and frees it afterwards, and rtw_download_beacon()
> fetches (and frees) its own beacon when it is called without one, which
> is what the scan path does. So the countdown still advances once per
> page update and the scan keeps its beacon.

If scan request while doing channel switching, we might deny the scan
since peer (STA) might countdown itself and jump to target channel
but no beacon listened causes disconnection.

Therefore, rtw_download_beacon() fetches its own beacon without affecting
countdown (channel switch isn't operating).

Ping-Ke

