Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78043AF670
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 18:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484786; cv=none; b=TVEMofdgdI9ADW6afWcOsz4qEhaOxnQbxszqZ4YZFgwbB1e3jTYIxtlydODZfwvKfl5xBafV7ayHYJs6ef6KivQiIVR19OStcdC7t+WFoCbFgva29VUBhaiHR8vEcgiVJM0qfuHRbTSrbHxHzlQ44t3CK4zywI7FdVX7RMIbb3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484786; c=relaxed/simple;
	bh=dz2jiaE9uJUlIdGJMlRutgkfJN2jgJXVRjON8xoSfPk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=PjB+68xXi4ISXzrw1q1BNhknJf4qJZ906dWeQb3ILE1gA0h0uvQE2mat056d91eRtae9bisVOIb4ltZ7jg4VXQKZH14P71qlATtdth7wTnXartyTFyB7vIYPqedhm8svqe+6Q3PQZyHo6HXk4thfCNqHDxnPpZDo26jSWlCz/e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JdABZpDv; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JdABZpDv"
Date: Sun, 19 Jul 2026 20:12:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784484778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dz2jiaE9uJUlIdGJMlRutgkfJN2jgJXVRjON8xoSfPk=;
	b=JdABZpDvl2eKotEiwI+BBw4PurFlSEGsRNOQq2GM9exv1Pz+L7fhq4K0zjuKRrogV+3MSP
	0N72jdiLKBCqRNorni6bRACn8Or80scqwDmjQ2XEuaukwLxs1O7uSym0lMKKGFkXDyUlJG
	OV08GPnPhP5KsU++TcHvMR5FBTB5VE0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Peter Robinson <pbrobinson@gmail.com>, linux-wireless@vger.kernel.org
CC: pkshih@realtek.com, straube.linux@gmail.com, luka.gejak@linux.dev
Subject: Re: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
In-Reply-To: <CALeDE9PgQmpMfDt1DgfLD4tBFGH0MZ7GncV6RUEOHhHbKF+TdQ@mail.gmail.com>
References: <CALeDE9PgQmpMfDt1DgfLD4tBFGH0MZ7GncV6RUEOHhHbKF+TdQ@mail.gmail.com>
Message-ID: <979BE09C-F694-4135-9BE9-EAD8F787E122@linux.dev>
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

Hi Peter,
Thanks a lot for testing on the Pine64 boards, and for the Tested-by=2E=20
I will carry it on the series in v2=2E

> rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware

I looked into this one=2E The v41 firmware does send the per-frame CCX TX
reports, but on some SDIO hosts they arrive after the 500 ms report
purge window, so the queued entries are dropped and the warning fires=2E
On a faster host here every report matched in time and the warning never
appeared, which matches your slower boards hitting it=2E v2 extends the
longer report timeout already used for 8723D USB to cover 8723BS SDIO,
which should clear these=2E I would appreciate a retest on the Pine64s
once v2 is out, since the race does not reproduce here=2E

> rtw88_8723bs mmc0:0001:1: firmware failed to leave lps state

The leave-LPS path polls REG_TCR for the firmware to finish its
null-packet handshake=2E The v41 firmware does not complete it the way the
poll expects, so it times out and force-clears the bit=2E The end state is
correct (hence no functional impact you saw), but the warning is noise=2E
I am still characterising whether to extend the poll or skip it for this
firmware rather than just silence the message, and will address it
properly=2E

> There's precedent for including the realtek firmware in linux-firmware
> like this, you should include in the notes where you got the firmware
> from and how it was extracted so it's verifiable, as well as cc:ing
> Ping-Ke Shih who will then ACK/review it=2E

Thanks, that is exactly what I needed=2E I have sent a linux-firmware
submission for rtw8723b_fw=2Ebin with the extraction provenance documented
(vendor driver version, source array, and the convert_firmware tool),
with Ping-Ke Shih on CC=2E The v2 cover letter will reference it=2E

> I am happy to see this, I had started to play around with a similar
> patchset but still had a way to go and little time to move it on=2E

Glad it is useful=2E Happy to have you review or test v2 when it lands=2E
Best regards,
Luka Gejak
