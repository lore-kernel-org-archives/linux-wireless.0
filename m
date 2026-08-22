Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9739F27EC7C
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787417530; cv=none; b=JayTXaZULAF0HOeTxUnfMthjNeVGue9WoJf8bdGie6nj7C5ZXBJHw/lXBeIncGjHHp8a3pw1eHDiBFD3Ip9CJRHYvggODBLg2UzlsrxtXeut0oHUeefpJoGzznj8zKQxmHaXIRJnylKjUCg52mBXD0Fgr/FKnuayPqQvS7sLzZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787417530; c=relaxed/simple;
	bh=wASOUdAJ+jefl6Fr5xINEmNRMBrFX2FNpFik+JXYll0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=kCmbUSD6plFo7bBKW7HO0oEuyJkkS9cPkdpqHSmGgB34OJxwwuQtzTOtKweILAOzZ4Wol3xJjI0OveNqvCnvMp/kCPuXV/BzV7BUrmjmBovsNyR718w7rQxYim8fcd4ZyxEvyoqa9U9IjuZmxGD87MmRXdLw2rr3LIruTs8BQXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i9/D2WNG; arc=none smtp.client-ip=91.218.175.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i9/D2WNG"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wASOUdAJ+jefl6Fr5xINEmNRMBrFX2FNpFik+JXYll0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787417524; v=1; x=1788022324;
 b=i9/D2WNGtTwPbHkauECpBDGk4mpRd0Quu7VLu8oyoCB/XRnU1Qo/Nfz2aGd5rh+e0EuWGrEc
 Gm/ZB6+nVeWzzjdbk8f91ukPqF3BIS9xOB/40kl2Gc6/FdQvCQhV0gJSA95jARi35RUV4MmZMGs
 cZ8vaRpShrT+T9a23Kp5SJLM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (2a06:63c5:9b00:3900:6849:2575:4516:d712)
	by smtp.migadu.com with ESMTPS id 643f7c8164119db2;
	Sat, 22 Aug 2026 16:52:04 +0000
X-Mizu-Trace-ID: 643f7c8164119db2
X-Migadu-Flow: FLOW_OUT
Date: Sat, 22 Aug 2026 18:51:59 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: Re: [PATCH v7 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
User-Agent: Thunderbird for Android
In-Reply-To: <20260820090412.19574-1-luka.gejak@linux.dev>
References: <20260820090412.19574-1-luka.gejak@linux.dev>
Message-ID: <44120736-F50E-4AD0-A380-3CEBB6A2F7F4@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 20, 2026 11:04:06 AM GMT+02:00, luka=2Egejak@linux=2Edev wrote:
>From: Luka Gejak <luka=2Egejak@linux=2Edev>
>
>This is the first of two series adding support for the Realtek RTL8723B
>802=2E11n chipset and its RTL8723BS SDIO variant to rtw88=2E It contains
>only the changes to the shared rtw88 core that the chip driver depends
>on=2E The chip itself, the build glue and the MAINTAINERS entry are a
>second series=2E
>

=2E=2E=2E

>Known limitation
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>After a long idle period the firmware intermittently fails to leave LPS,
>which rtw88 reports as "firmware failed to leave lps state"=2E That check
>is the REG_TCR poll in __rtw_fw_leave_lps_check_reg()=2E On one occurrenc=
e
>here the warning was followed fourteen seconds later by a full
>reauthentication, so it is not only log noise=2E
>
>Power save is enabled on my test machine and it reproduces there,
>roughly once per day of mostly idle uptime, and the occurrences cluster=
=2E
>It was first reported on ARM SDIO boards, but it is not specific to slow
>hosts=2E
>
>Instrumenting the poll shows the wake is never immediate on this board=2E
>Over a run of a hundred consecutive wakes the bit was still set on the
>first read every time and cleared on the next 20 ms poll; logging only
>the outliers after that, the occasional wake takes two polls=2E So the
>budget is five polls and the ordinary cost is one, which also means
>every wake costs at least 20 ms here=2E A failure is then the far tail of
>that distribution, which leaves open whether the budget is simply too
>small=2E I would rather keep measuring than guess at a fix=2E
>
>It is not caused by anything in this series, and it needs the chip
>driver from the second series to be reachable at all, but it is open and
>I am chasing it=2E
>

=2E=2E=2E
Hi Ping-Ke,

A correction to the "Known limitation" section of the cover letter=2E I wr=
ote
that a failure looks like the far tail of the wake time distribution,
leaving open whether the poll budget is too small=2E I have since debugged=
 it
and that turns out not to be the case=2E

With a local debug patch logging REG_TCR on every poll of
__rtw_fw_leave_lps_check_reg(), I caught three failures=2E In every one
BIT_PWRMGT_HWDATA_EN was still set after 600 ms, six times the budget=2E A=
nd
there is no tail=2E Counting how many polls each successful wake needed, a=
t
the third failure:

        poll0=3D25 poll1=3D27610 poll2=3D9 poll3=3D0 poll4=3D0 fails=3D3

No wake in roughly 27600 ever took three or four polls, yet failures happe=
n=2E
The firmware either finishes within 40 ms or not at all=2E

A larger LEAVE_LPS_TRY_CNT would not help=2E This is firmware side, and th=
e
existing code already does the sensible thing: give up, clear the bit, war=
n=2E
Nothing in this series changes=2E The rate is about one in 9200 wakes=2E

Best regards,
Luka Gejak
