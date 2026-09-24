Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F94B379988
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 05:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229525; cv=none; b=NqiaeqfF4eR90MfvN1fC6KXfwuKQdghma/iC5B151oadvwJqRI31QrbXSKOOsypwWF5Pp570gPtu30JA7p8OpqvsJAF0+qHUG3QYF0J1IHbN2M5Q98RfB6iIRvcM/1Wz1b3uhBJVEwrvEjfqX7e8sLY7MAeG/UaXmSnb28AV9xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229525; c=relaxed/simple;
	bh=HXc6oqjzAuU/UrjmqfAtyQVrndHemXKxHSkJX6ryL1w=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=gqY7BOVONY9ArXpVrP8AFKhd1kC3ww1+S5a8jPAvH54npCMfwOJZLP3oyE/4vffK7HDWhN5mgq8iw4zZAjhSR3k17liAjbV1YlNwldrUDTXiosXkoGDvIsaUEuoRdnc8ab2I8LRoqR5veNQbSUtEUZpGJd2dEty357j4fZmg3OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n+/0eqTe; arc=none smtp.client-ip=95.215.58.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n+/0eqTe"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HXc6oqjzAuU/UrjmqfAtyQVrndHemXKxHSkJX6ryL1w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790229521; v=1; x=1790834321;
 b=n+/0eqTepV3TfH6SeW4jDp1wJmSNfpG6rg9BHtayR0I3hFkjvpgqe9vfLqwnp1XtHtElggxI
 u8wU3VDEcFuDtdrAY8jf1OC+I12bhW4pnfWnToNTpgQWBHnB5A073jEky7bS0AtY4cHb5Klwj30
 uCcrIN27Wn93WBrWnb/I9h3U=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d0fe7acf4a06a29c;
	Thu, 24 Sep 2026 05:58:41 +0000
X-Mizu-Trace-ID: d0fe7acf4a06a29c
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 07:58:33 +0200
Message-Id: <DLNBECY70VGJ.DRSBNB6M66U8@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v4 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak" <luka.gejak@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-7-luka.gejak@linux.dev>
 <afb044e0aef8425880ddb24add9340ab@realtek.com>
In-Reply-To: <afb044e0aef8425880ddb24add9340ab@realtek.com>

On Thu Sep 24, 2026 at 3:24 AM CEST, Ping-Ke Shih wrote:
> Luka Gejak <luka.gejak@linux.dev> wrote:

[...]

>> +REALTEK RTL8723B WIRELESS DRIVER (rtw88)
>> +M:     Luka Gejak <luka.gejak@linux.dev>
>> +L:     linux-wireless@vger.kernel.org
>> +S:     Maintained
>> +F:     drivers/net/wireless/realtek/rtw88/rtw8723b*.c
>> +F:     drivers/net/wireless/realtek/rtw88/rtw8723b*.h
>> +
>
> I think no need this entry.
>
> Just with below 'R', the ./scripts/get_maintainer.pl with rtw88 patch can
> output your name, no?
>
>>  REALTEK WIRELESS DRIVER (rtw88)
>>  M:     Ping-Ke Shih <pkshih@realtek.com>
>> +R:     Luka Gejak <luka.gejak@linux.dev>
>>  L:     linux-wireless@vger.kernel.org
>>  S:     Maintained
>>  T:     git https://github.com/pkshih/rtw.git
>> --
>> 2.55.0
>
> By the way, your patch should tag rtw-next (i.e. [PATCH v5 rtw-next]).
> Otherwise, NIPA test your patches on wireless-next tree, reporting
> errors [1].
>
> I don't know if someone is reading your patches. I'd skip v4.
> Please wait a while and send v5.
>
> [1] https://patchwork.kernel.org/user/todo/linux-wireless/?series=3D11725=
92

Thank you. I will hold and send v5 tagged [PATCH v5 rtw-next], and I am
reading the list in the meantime.

On the entry: it is a maintainer entry for one driver, which is not the
same thing as the reviewer line. The file's legend:

        M: *Mail* patches to: FullName <address@domain>
        R: Designated *Reviewer*: FullName <address@domain>
           These reviewers should be CCed on patches.

The names it reports them under are "maintainer:" and "reviewer:":
get_maintainer gives the M: role the first and pushes R: entries as the
second. With R: alone the entry says my name should be CCed on RTL8723B
patches, which is correct, and I have kept that line, but it does not
say that anyone is expected to look after the chip.

Documentation/maintainer/feature-and-driver-maintainers.rst covers
exactly this case, a maintainer for one driver inside a larger
subsystem:

  - "The term maintainer spans a very wide range of levels of
    engagement ... to people responsible for a small feature or a
    driver";
  - "Drivers and alike most often do not have their own mailing lists
    and git trees but instead send and review patches on the list of a
    larger subsystem" - which is why the entry deliberately has no T:
    line and patches keep going through rtw-next;
  - "Maintainers must review *all* patches touching exclusively their
    drivers, no matter how trivial" and "an Acked-by or Reviewed-by tag
    ... from a single maintainer is enough to satisfy this
    requirement" - an Acked-by on the list for 8723b patches is the
    role I am asking for, not a tree of my own;
  - "Most natural and common choice of a maintainer is the author of
    the code", and the file "is not a list of credits ... it is a list
    of those who will actively help with the code".

I know that least one person(with my help) is working on an RTL8723BE (PCIe=
)
build and I expect an RTL8723BU (USB) to be added eventually. rtw8723b*.c a=
nd
rtw8723b*.h already cover all three variants, so the family has one named
owner as it grows, and those patches do not all have to reach you first.

It is not a claim on rtw88. The patterns cover rtw8723b*.c and
rtw8723b*.h only. Nothing else in the directory changes: get_maintainer
on reg.h returns you as maintainer and me as reviewer whether the
section is present or not, and the R: line you suggested is what puts me
on those patches.

The nesting is not new: the ath family keeps separate entries for ath5k,
ath9k, ath10k and carl9170 inside ATHEROS ATH GENERIC UTILITIES, whose
F: is drivers/net/wireless/ath/* and whose M: is Jeff Johnson, and ath5k
and carl9170 carry M: with no T: line, as this one would.

This is about the one chip I have the hardware for, not a proposal to
split the other rtw88 chips out of your entry.

checkpatch --strict on the MAINTAINERS patch is 0 errors, 0 warnings.

If you would still rather keep it to the R: line, say so and the
section goes, it is one patch, and it should not hold up the series,
but please take these points into account.

Best regards,
Luka Gejak
