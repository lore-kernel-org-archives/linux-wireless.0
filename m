Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D173236402C
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2026 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951362; cv=none; b=HIM+pIlBV4OzHS19NS8uP67iSKuikB/MK7H7bJ1R8US2hJoLwFeCHdk64JKpGQsH1ZGmliWV7gZtIb90nxipBU4QX5N1ind4sub4+Y9P6ISie1UmC5DYLo7Phu8ez/MoiD9YhrInXkNWXjf9lSKxf8sTc4in7BguyA99WKBL734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951362; c=relaxed/simple;
	bh=tgRQ0U25nWj3S5HBM1P7hi6jLwXtBR7O9gWUGOXhHxg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R+b0chDvxGR2wuSOd0krOfgEM6MsMQxRae1k4lpKlE66Vml1EfiWIjvDDiybErrQJviv/HiNQ5O2C2bhQkT9ZGJcucdgbIuRwApQtnpKewjQt5UJaO/rjRmtbIHJLLmZG4TpOnV7/3C7QM3AXXV3o4sUrTW95T0B30mwUJ8mQMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=s9950PKE; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="s9950PKE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=JUA2xBrMwgjxizEd5FMOWlQ8/O1DyXLl0e6CJAyLL2I=;
	t=1771951360; x=1773160960; b=s9950PKEC8NJOoEmjDPcpSJDjHHqN+STNhAWTzc5wlOEL9o
	XAwg6V4i9UIRvzszfI+BNiH9i9MMf7KVKLWNI3KamIYBJDbOr6HSny/1vXjcYmXhxN9NZO9CBtaTb
	mkGqg00G9HRyWduR5lZekTYP722wQt5ei9KiGWB9yPBYsNP97dRUqn3IqmF+478xkoW72zuuP7HmZ
	5nwiV0vOGZzHq+U3NQWsbr+R+6zZyr3MmksIMFmT5D8ovwTwComnmqJqeUqnjAz6HsbzcAwgdc/3z
	sevM0Y+ey631+LnNSHnshQIlnFugluQ4kPJO1zTJKOJO3rux6F6YcxonL35vmRbw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vuvUa-00000000aIt-2UK8;
	Tue, 24 Feb 2026 17:42:36 +0100
Message-ID: <c71a84fe19a632ccd748d0f1fded1a8b1277e0b1.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v4 1/2] wifi: UHR: define DPS/DBE/P-EDCA
 elements and fix size parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org
Date: Tue, 24 Feb 2026 17:42:36 +0100
In-Reply-To: <20260217054731.3667600-2-karthikeyan.kathirvel@oss.qualcomm.com>
References: 
	<20260217054731.3667600-1-karthikeyan.kathirvel@oss.qualcomm.com>
	 <20260217054731.3667600-2-karthikeyan.kathirvel@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Oh, another thing

> + * @dbe_params:
> + *	B0-B2 - DBE Bandwidth field is set to indicate
> + *	expanded bandwidth for DBE mode
> + *	Value 0 is reserved.
> + *	Set to 1 to indicate 40 MHz DBE bandwidth.
> + *	Set to 2 to indicate 80 MHz DBE bandwidth.
> + *	Set to 3 to indicate 160 MHz DBE bandwidth.
> + *	Set to 4 to indicate 320-1 MHz DBE bandwidth.
> + *	Set to 5 to indicate 320-2 MHz DBE bandwidth.
> + *	Values 6 to 7 are reserved.
> + *	B3 - DBE Disabled Subchannel Bitmap Present.

Seems we should have an enum for the possible bandwidth values?


And also, it's confusing:

> +/**
> + * enum ieee80211_dbe_bandwidth - DBE Bandwidth

because this one is just "DBE Bandwidth" - I think you should rename
this to "DBE Maximum Supported Bandwidth" or something related, and add
the operational, since there's a 4/5 difference with 320 vs. 320-1/320-2
(the latter in UHR operation)

johannes
