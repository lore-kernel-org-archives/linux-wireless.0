Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302E8439909
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 06:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789108873; cv=none; b=V2xFD/m/XaN2f8hLxYE+L0XBjnogsWEoYLaIVe5duiV3+QNNv2sP3cjWSWkY9u58oJ1YB2OKbngqMu5I2/CM0w9w0rh0ZgSbPgFbAX7jskR2afYFsuvV5ro9GGz9JWbdaPWP1+oS1lC7CNIFO0H6TrDkwHr3uxfGk4r3seMZwB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789108873; c=relaxed/simple;
	bh=ExOsGl2j4nMlAou7DL7hm0Ih5Hfn8Z4OdLD7D7iXx/g=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=HfAta9wujdW12oZmg1bzfEFHtaQBHgymxKVFwupiJpWImAG3awOsXqyCdzNrL9GYyQ3DhnhDxpO3AAAUfTkA2P+Ud0G5YuCcYJNY3ELsxkXK2I2kyqyEnZDV4zWjyEMiaWSND63dEAWHoyWiH7d3Z/MTMo/ojEVgkjGBtoowYN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hzhX8wi7; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hzhX8wi7"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ExOsGl2j4nMlAou7DL7hm0Ih5Hfn8Z4OdLD7D7iXx/g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789108861; v=1; x=1789713661;
 b=hzhX8wi7czmdIH7/JaMa0S5TzkjJZY4gwY5uSktT5YYpndJu/sAex8VltPsbJJEScxnhfb1s
 YYWI4tYYhwgBYSpEHc5rlTR6bSXK1fp5U+Vsqd97r7vAgjogL1L132R6tcMlt5LJjPboyLhUqH3
 oUCRrRFw84/0NRfPsU84sVwA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c00feb8a6972bf63;
	Fri, 11 Sep 2026 06:41:01 +0000
X-Mizu-Trace-ID: c00feb8a6972bf63
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Sep 2026 08:41:00 +0200
Message-Id: <DLCA5RRJUQKI.37EVVUC379JC4@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak" <luka.gejak@linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>
 <f139980a5614454cac50517a5b602cd5@realtek.com>
In-Reply-To: <f139980a5614454cac50517a5b602cd5@realtek.com>

On Fri Sep 11, 2026 at 2:30 AM CEST, Ping-Ke Shih wrote:
> Luka Gejak <luka.gejak@linux.dev>
>>=20
>> One thing to decide, though. The commit message says the padding "costs
>> nothing observable", which is too strong given the numbers in that same
>> paragraph. Do you think it needs rewording? If so, would you be willing
>> to amend it yourself when applying? That seems better than a resend of
>> seven patches for one line.
>
> I can amend it myself as
>
> "... padding the transfer costs about 2% observable over transfer."
>
> Or you can help to reword the paragraph. I can copy & paste it.
>
> Ping-Ke

Please amend it yourself, that is much better than a resend. Here is the
change:
 =20
  "padding the transfer costs nothing observable:" to "padding the transfer=
=20
  costs about 2% observable over transfer:"

Leave the rest as is, after semicolons there are numbers to explain that 2%=
.

Best regards,
Luka Gejak
