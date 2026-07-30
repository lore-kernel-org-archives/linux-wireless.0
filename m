Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1264740926C;
	Thu, 30 Jul 2026 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421733; cv=none; b=O30jNOB3XppSN5xy4csCzSUNSsCnn6sUJkH5rA20N8r0i8nKoy6T148OuHjDAWunm4SMj3d87Ks1YRPeZYBKpTSGliPdOf7/qIu+c7HDDwZf3/14IzkMJx7gqH8SxNAzmR0Vj/hVBrtbZmY/Sd8LK+AvRKL8aGowH4y+hHddnpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421733; c=relaxed/simple;
	bh=aAV9wRqARtaWoP89gto4xpqPvKZzd/4dtVDg2+yRjXg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=dQLRRNy2OJKmR61R3qul4/nvgiOeD3vL5NQBZMnuoND6uT09yEiOq9n5OAANrS7xdKj56CnWv/srIXZbVBIufolWmqYu5lVYaL/lBylGKlrBhy9LUplp/2xlSEMqYlloJ2iI7WlWo+D12FflUn0J+OoPhSz5u9oZ+4u2y5Nxfb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mv9Umw/i; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mv9Umw/i"
Date: Thu, 30 Jul 2026 16:28:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785421730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YQgsKXoP3pMbRdGfcjamYsUScERKdJ+qUdS6Y9CW7E=;
	b=mv9Umw/i6/p51CAfbLuQhByC+5efUIwVhfWD+mLQAjQ+PzobomvCIMiY5jqP0CwPl1Awhg
	lJn4OMaAS8oOGI/iZfnmeYWasHXsgHsceeNIyjQoZOBK/3QBjxlOCc5G3FNOR4i6ivjkIQ
	+fUS4zQqhHfYsqv3onOk9raxj4XtcSA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v2_01/11=5D_wifi=3A_rtw88=3A_add_?=
 =?US-ASCII?Q?the_RTL8723B_chip_type_and_SDIO_helper?=
In-Reply-To: <6c2d5972971f48548a58dc3fba890793@realtek.com>
References: <774407603bef4fd38290f6b5d4b4a26c@realtek.com> <20260730074504.19725-1-luka.gejak@linux.dev> <6c2d5972971f48548a58dc3fba890793@realtek.com>
Message-ID: <6872BF49-855E-42A5-A06F-98C4602B2C25@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On July 30, 2026 11:17:41 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom>=
 wrote:
>luka=2Egejak@linux=2Edev <luka=2Egejak@linux=2Edev> wrote:
>> it would be four callbacks (free page check, page
>> accounting, output queue wait, transfer sizing) and I did not want to
>> introduce that structure without asking first=2E
> If these are called from sdio=2Ec, just check chip ID in sdio=2Ec=2E

That is what v3 already does, so nothing changes there=2E All four are
reached from sdio=2Ec only=2E

> If they are used by common flow like coex=2Ec, I prefer to implement
> them by chip_ops=2E

Let me list them all so you can rule on all of them at once rather than
a file at a time=2E

Two go regardless of your answer: the chip test inside
rtw8723bs_apply_basic_rates() and rtw8723bs_apply_bss_cap() is
redundant, both callers already establish the chip=2E In the second one
the NL80211_IFTYPE_STATION half of the same guard is still needed, so
only the chip half goes there=2E

That leaves the following outside sdio=2Ec=2E

coex=2Ec, 2 sites:

  rtw_coex_scan_notify()    -> rtw_coex_8723bs_scan_notify()
  rtw_coex_connect_notify() -> rtw_coex_8723bs_connect_notify()

  Each tests the chip and bt_disabled once and returns true when it has
  handled the notification; everything below them assumes both=2E

mac80211=2Ec, 6 sites in rtw_ops_bss_info_changed(): the receive filter
on assoc and on disassoc, BSSID change bookkeeping, and the
BSS_CHANGED_ERP_PREAMBLE and BSS_CHANGED_ERP_SLOT handlers=2E

mac80211=2Ec, 2 sites in rtw_ops_set_key(): enabling and disabling
default key search for group keys=2E

rx=2Ec, 1 site in rtw_rx_fill_rx_status(), the zero length packet test=2E
This one runs per received frame, so an indirect call there looks like
the wrong trade to me=2E I would keep it inline unless you disagree=2E

fw=2Ec, 1 site in rtw_fw_write_data_rsvd_page(), two register
save/restore blocks interleaved with the generic ones=2E I do not see how
to lift those into an op without restructuring the whole function, so I
would keep that inline too=2E

For coex=2Ec and the two mac80211=2Ec callbacks I am happy to add ops=2E O=
ne
constraint on coex=2Ec: the 8723BS code calls rtw_coex_set_ant_path() and
rtw_coex_set_table(), which are static in coex=2Ec=2E Implementing the ops
in rtw8723b=2Ec would mean making those two non-static, which seems worse
than the chip test it replaces=2E What I had in mind is leaving the
functions in coex=2Ec, declaring them in coex=2Eh, and having rtw8723b=2Ec
point the ops at them, the same shape as the chip_ops::prepare_tx that
v3 adds for the association sequence=2E The generic helpers stay static
that way=2E

Tell me which of those you want as ops and I will do it=2E

The comment on mod_delayed_work() is already in v3=2E

Best regards,
Luka Gejak
