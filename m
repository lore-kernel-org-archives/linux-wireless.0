Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C679726FDBF;
	Mon, 19 Oct 2026 01:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373160; cv=none; b=Vh4eNZ9zB7RvgbBJFusK3aze6lPGVh6Bt/VsAMnnN2n8WVcWkcEygQLDqDZTReii4lWYMIEl3B4w3Tp3GqOIoq0FBeaFfvLlVj+QaLpAjRtwDyPB5MWvK4b0UMEL1uUEH/hyV9kGmgz89NxoPYK2/gpVWnRREF64dgmdqtZuaZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373160; c=relaxed/simple;
	bh=bROhtMvICKL3hfiSKkrSAw855A7WDYmtaX8yDyr3/B0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NZaej/xWy1vngdz6xJVCGWyARFYq9RRa9ylKjTYdtlfLyB0EebGTaAwRfxnGuBLZakFSOE1M+NiOU3ejtir5U05OaCPQbQ0z+WyZuz7LTTwcIzkWlIpfjx3gOr2KP9MMtJqDx/w+YT5s0Lp8IKAWey1mfP90VZ5CU+ub/nTuqyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HhLS85gj; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HhLS85gj"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69J1Psc761428680, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792373154; bh=RI+S/nok2XyXDnpGx6fYLdQRSStzfNLeAEil/Ots+kE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=HhLS85gjIok0uTzVpLYcXWDWdfTi05jxkt+JUNekr57IXt+KjD/pj99EFBdPKO6yc
	 FWQasPdPqYAMKLHpdu6UTef8OouNBnkrJhgMKzFJYrPqwvCh9nVHMTkNYYBfOK+Vx6
	 YKAnP5B/AQG0MOQ8UGheFvkfGo5sqLJQ+4od4Cd+84WAKY7/ql0PF3v76vum2ZWnc6
	 lEGnrhKRd190sjGbPfW4SlR38xWZjBaMWw5IYvQkBKY/LN9m5Otzzqa8Tl9fbJvmnA
	 +JM5kyqd4PO/JZ+3yOVX5T4nPoY5kSQDEEqM4t75RjLUbFSsL3n9SmpH6WluBmBX0V
	 51MVfx045bdqg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69J1Psc761428680
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 09:25:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 09:25:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 19 Oct 2026 09:25:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the
 rings are reset
Thread-Topic: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when
 the rings are reset
Thread-Index: AQHdWO4MPV0dG/pKrEyzZWvhd4YBNrb5eb7AgAINFoCAAMEoQIAEANAAgAPLA9A=
Date: Mon, 19 Oct 2026 01:25:54 +0000
Message-ID: <3c588aeae8f74a8caa39aa2852bce437@realtek.com>
References: <c15cbcb38aed477ab8d4c06ce30b174d@realtek.com>
 <20261016224756.20687-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261016224756.20687-1-abdurrahmankaradag19@gmail.com>
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

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> > I re-think ring->queue_stopped and restart work. I feel the flow
> > should be [...]
> > I'll discuss above flow internally, and give back to you.

I discussed internally, and we suggest to add ieee80211_wake_queues() and
clear queue_stopped flags in rtw_pci_start().

This can resolve two cases -- restart_hw and interface down/up while
queue_stopped is flagging. Just like initialize or reset to variables.=20

No need 3 steps I mentioned. (So I'd not reply your trace.)

> Your other two questions were in the bug thread; bringing them here as
> you asked.
>=20
> > could you describe how you resolve the stuck (by the method of your
> > previous patch, maybe v1)?
>=20
> Nothing the driver did on its own. Over the five events, power save off:
>=20
>   rewrite the TXBD host index   0/3   read index never moved
>   ip neigh flush                0/4
>   iwd reconnect, new PTK        2/4   cleared 08-28 20:32, 09-06 03:17
>   ip link set wlan0 down/up     1/2   cleared 09-14 17:48
>   reboot                              always

So there is no solution for now. Since 3th and 4th events will stop/start
pci, if the cause to fail to recovery is flagged queue_stopped, our above
idea will be helpful.=20

Another test is to remove/insert driver ko. It will reset queue states.

(I suppose you did these tests without changing any behavior as was).

[...]

> One thing I should flag before you read the dumps. My ladder pokes
> debugfs fw_crash anyway, so nine of the captures print
> "rtw_fw_recovery() tetikleniyor" - Turkish for "being triggered" - six
> on 27 September, two on 14 October, and one where the knob was not
> writable. Eight of them follow it with "fw_crash ->
> ieee80211_restart_hw: 100% packet loss". Both strings are labels my
> script prints for that rung, not anything the driver reported.
> rtw_debugfs_set_fw_crash() never calls rtw_fw_recovery(): it leaves deep
> LPS, sets RTW_FLAG_RESTART_TRIGGERING and writes REG_HRCV_MSG, and
> recovery is entered only through the C2H path I described on 3 October,
> which matches your point that the knob only takes effect on 8822C. So
> nothing was triggered and nothing was tested at that rung. Section 4 of
> the six September dumps also reads fw_crash as 1 before that dump's own
> write, because the file prints RTW_FLAG_RESTART_TRIGGERING and only
> __fw_recovery_work() clears it; all six are the same boot. The two
> October ones are later boots and read 0.

I need your help to summarize the dumps. I don't have much time to analyze=
=20
them. Sorry.=20


