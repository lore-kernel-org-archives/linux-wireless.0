Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF624302E7
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 07:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785830296; cv=none; b=nkDKNkhuLqiZDzf+Alvte02VqtP4gXGn+GQZBAb4YQYWeAF7XOFICondwkkrckSIUIWFZWlmUTU3urGrkApKYT40peNIChdGAV+YbIeTuZ/ZVGHLzSxN+WaPJoVRftvDK0WLVYGWxt3gCW25RFDRFrd7B6lFrnGNqM9xDghhK5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785830296; c=relaxed/simple;
	bh=1JR1yFP9Xy/3B4Z20X876If/gOWI0vJvUBDJja6xxsQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=c/L22p8mvBT4GWHeeOA/JcwrBYIrx/0nGcEwsfJGBRTvMZRwi74s+uwO+A4/dKtKMIkVgPpN9AVRuusOBKAbVcWeqjl1/v+jKwoNQAhaTNZA9HyqDRqU+jnmicCJMLyfrAWoTQ27apUm+eytlXCecRNuqYvihaWppXDf6UxtF+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PJBD7iNE; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PJBD7iNE"
Date: Tue, 04 Aug 2026 09:57:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785830290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1JR1yFP9Xy/3B4Z20X876If/gOWI0vJvUBDJja6xxsQ=;
	b=PJBD7iNENMeNXq+tvXHCHVWi7NZ+GAXgSEc0eQulBjkhtmG116rjBS0VnnW3Fxt5/8tu7w
	y+tsSiLP9y4V6rvdz6ZPVB7siIb2eKimzSujHlVEeQ93DR1zmV3dk7h10SjS3nI2nlh7Kw
	BDHxQYd/f2oPotamVr56oliQAlVP11c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Peter Robinson <pbrobinson@gmail.com>
CC: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: Re: [PATCH v3 0/5] wifi: rtw88: preparations for RTL8723B/RTL8723BS
In-Reply-To: <CALeDE9MjtFthMsA6w5=6vhMT+C959Wi0zh5knwLoQfy6_A0TmQ@mail.gmail.com>
References: <20260804065425.17364-1-luka.gejak@linux.dev> <CALeDE9MjtFthMsA6w5=6vhMT+C959Wi0zh5knwLoQfy6_A0TmQ@mail.gmail.com>
Message-ID: <D4AD2676-E4F3-4D36-9EC1-ABDA13E07FF1@linux.dev>
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

On August 4, 2026 9:18:59 AM GMT+02:00, Peter Robinson <pbrobinson@gmail=2E=
com> wrote:
>Hi Luka,
>
>Is there a branch somewhere that has the remaining patches to be able
>to test the full stack?
>
>Might be useful to reference that in the cover letter in future
>versions as well so people can find it if they wish to test the whole
>driver end game=2E
>
>Peter
>
>On Tue, 4 Aug 2026 at 07:55, <luka=2Egejak@linux=2Edev> wrote:
>>
>> From: Luka Gejak <luka=2Egejak@linux=2Edev>
>>
>> This is the first of two series adding support for the Realtek RTL8723B
>> 802=2E11n chipset and its RTL8723BS SDIO variant to rtw88=2E It contain=
s
>> only the changes to the shared rtw88 core that the chip driver depends
>> on=2E The chip itself, the build glue and the MAINTAINERS entry are a
>> second series=2E

Hi Peter,

Indeed there is a branch on my github fork of rtw repo and I will=20
include it in cover letter of v4, if such exists in the future:

https://github=2Ecom/MocLG/rtw/tree/8723bs-v3

Also one thing, please avoid top posting so the conversation flows in=20
chronological order=2E

Best regards,
Luka Gejak
