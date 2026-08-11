Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7EF429004
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 09:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786440675; cv=none; b=Hj00Zv4UEwdfQ05G2CA4qmzcV3xgNFjA2yasorxuNCufQnYzKHw4fDhzqaD1b9zikDDLEaZWLEaXJ3hs+DC6fBNpxbxog2Yus4UpqP9s6RGFdJgm/ZqoDiC6r7cdhaE3wCrkugRuzv+U3AYoxhrY5y8quMnncojO9LHVImSRpXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786440675; c=relaxed/simple;
	bh=lTLfQ2+7YQZMVhArPRawsAeg1cubWYo6378A4AW1ckc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=oZ/98rScmD7nzHtcu0Rpj99V2nVOFM3VrY6/xbu6ABm2D4j3CYEFf0j8nAs9MO/yUs87YjW6rXyYitKNe6Rm056kOyMzNhEEn/j02ocddnY8m9/8k0/VwDxRwq3Xuxbq7F0km56WfQoPsoMSphwuJdan8e5/FsfIGyEfxT0fb8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hfQwpHN6; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hfQwpHN6"
Date: Tue, 11 Aug 2026 11:30:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786440660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vemvAGxSfLmFtcxyqC5XKJiJygYV/nrt6AxlOvWZiwQ=;
	b=hfQwpHN60L7AjYcBlZ1Gaer8gAUmLFL1FLN2muXZhl9UnpEwr4FS4b6IkNp8mDRuVPEL6B
	wKzBwlmktQrGeTblXzfs8PBCrhJRhiC/I4ExJf29T4vsdHSf3NbSumF6lCzS8I8VXGcEI3
	V3aHS84gtfHzcYYBr/F2o0/DItr5MRQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: Re: [PATCH v3 0/5] wifi: rtw88: preparations for RTL8723B/RTL8723BS
In-Reply-To: <20260804065425.17364-1-luka.gejak@linux.dev>
References: <20260804065425.17364-1-luka.gejak@linux.dev>
Message-ID: <A850D677-5DD9-4626-9DAB-1C62F20E292F@linux.dev>
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

On August 4, 2026 8:54:20 AM GMT+02:00, luka=2Egejak@linux=2Edev wrote:
>From: Luka Gejak <luka=2Egejak@linux=2Edev>
>
>This is the first of two series adding support for the Realtek RTL8723B
>802=2E11n chipset and its RTL8723BS SDIO variant to rtw88=2E It contains
>only the changes to the shared rtw88 core that the chip driver depends
>on=2E The chip itself, the build glue and the MAINTAINERS entry are a
>second series=2E
>
>v1 had 19 patches, v2 had 11, this has 5=2E
>

=2E=2E=2E

Hi Ping-Ke,

I have sent a v4 that supersedes this series, before you review v3, so
you do not spend time on this one=2E As you suggested, I am noting it here
on the v3 cover=2E

v4 re-adds two patches that were dropped in v2, both on the TX report and
leave-LPS paths=2E Testing on slower ARM SDIO hosts, Peter Robinson on the
RFC and another tester on a Rockchip RK3288 board, reproduced "failed to
get tx report from firmware" and "firmware failed to leave lps state",
which my faster x86 host never hit=2E One of the two simply extends the
timeout from commit c80788f7c5ae ("wifi: rtw88: increase TX report
timeout to fix race condition"), which you already acked for the
RTL8723DU, to the RTL8723BS, since they hit the same off-channel-scan
race=2E The other routes the vendor firmware's management TX report
events so the LPS leave check is left alone=2E=20

Other patches from v3 remain unchanged=2E

v4:
  https://lore=2Ekernel=2Eorg/all/20260811091203=2E26841-1-luka=2Egejak@li=
nux=2Edev/

Best regards,
Luka Gejak
