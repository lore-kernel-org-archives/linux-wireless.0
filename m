Received: from mta0.migadu.com (out-14.mta0.migadu.com [91.218.175.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8900476CD6
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239963; cv=none; b=oO3twY+WFoumiI9gTUlFGzBAUat3HEHvKxoRswyOxiL5UO3gkQO68Dru7zR6wV1QC3TmoUSWjFoNoqsRJ0OkhFZjxCalvK6cncfTlR4Gs8y6L6cZzEOsi49vs7dt6MfxIfIwQ0cds9wJIOZvsucsXE3BWw89ly7avuqpKTWbVTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239963; c=relaxed/simple;
	bh=g6P+i/6SPs0XGOpJWYj66gKutqHe5t9mTwQfRYkSxFE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=LXd1jwNVOV9Zo2FPA0t4j0qnyPQ6IUtWRJ2OUz4Swm4PBDCldjeHIDao232TpPPvqQmkosha3B9LG84gbeQbWdoisooBVxTlG805gHUeizpPpiHfElHljMa8UanjObAmHMHw4xgVz+JdhycqvUF+o1Ty8330R5pBF4RfP+7XfSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WJDG6OAW; arc=none smtp.client-ip=91.218.175.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WJDG6OAW"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=g6P+i/6SPs0XGOpJWYj66gKutqHe5t9mTwQfRYkSxFE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787239958; v=1; x=1787844758;
 b=WJDG6OAWDXkkKAJNn0oBSMMOSQyRIbqhJscZbZjXO0VxnkTZk7OuUkBC7Ge7Umq1aIY45QMl
 NIte+CKXuhevL78+YXf5ZJCI/+ALSmrNWvArVh9+Dhq2ii9rpnaFCzMYp54eedNsk0PGOP/CBP7
 MBwqHVo8M+0N6bmCFqPg94HA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 465dd9c2cf1b79c7;
	Thu, 20 Aug 2026 15:32:38 +0000
X-Mizu-Trace-ID: 465dd9c2cf1b79c7
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 17:32:36 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Peter Robinson <pbrobinson@gmail.com>
CC: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: Re: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
User-Agent: Thunderbird for Android
In-Reply-To: <CALeDE9PtH3dP0gynxzA7jyJEAXjYiGU8+Q_B6Y5ehZ2K5QgjVA@mail.gmail.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev> <6C350314-0529-445E-9324-FD5C21C5B495@linux.dev> <CALeDE9NmBpsBdVHYuzahgrxKtvzxs-ML1netc7OMOEMQ8j5+vg@mail.gmail.com> <A119CD11-ACC4-403E-B2DD-77ED818708F1@linux.dev> <CALeDE9PtH3dP0gynxzA7jyJEAXjYiGU8+Q_B6Y5ehZ2K5QgjVA@mail.gmail.com>
Message-ID: <2C57286A-F86B-4E47-B9A5-E9B762C25674@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 20, 2026 5:11:31 PM GMT+02:00, Peter Robinson
<pbrobinson@gmail=2Ecom> wrote:
>Hi Luka,
>
>> >> v7 follows shortly=2E It is hardware tested: 60 idle pings at 0% los=
s with
>> >> power save on, bidirectional load with no stall, 19=2E6 Mbit/s up an=
d 36=2E8
>> >> down, UDP at 0% loss, three scans, three reconnects and a clean log=
=2E
>> >
>> >I had done some basic testing with v5, and had left a v6 to build
>> >overnight=2E I'll grab this shortly and do a build with v7 and do some
>> >testing=2EIt was generally looking stable on the Pine64+ board I was
>> >using for testing=2E
>> >
>>
>> Thanks a lot for testing=2E In my testing changes in v6 and v7 didn't i=
mpact
>> performance and v7 should be as stable if not more stable then v5 and v=
6=2E
>
>I've literally just booted v7 so it'll take a bit to test it more=2E
>
>In v5/v6 I saw a bunch of these once it was running for a while, it
>seems to be stable though=2E
>
>[ 5594=2E434616] rtw88_8723bs mmc0:0001:1: failed to get tx report from f=
irmware
>[ 5692=2E223363] rtw88_8723bs mmc0:0001:1: failed to get tx report from f=
irmware
>[ 5747=2E389804] rtw88_8723bs mmc0:0001:1: failed to get tx report from f=
irmware
>[ 5767=2E421101] rtw88_8723bs mmc0:0001:1: failed to get tx report from f=
irmware
>

I think these are generic rtw88, not introduced by this driver, but I will
investigate it either way=2E

>Testing on iperf3 I'm getting just over 2Mbits/sec both TX/RX overall=2E
>

Hmm, this seems low, are those speeds on staging driver too, as in my
testing they are around 30-40 down and ~20 up=2E

>> >I think I may also have a device(s) with a 8723cs and/or a 8723ds I
>> >can possibly test with, I'll see if I can remember/find it over the
>> >weekend and get it running for some testing of that too=2E
>>
>> That would be nice, so we can see if other chips are affected, as Ping-=
Ke
>> said=2E
>
>I'll try and work out what I have over the weekend and will do some
>testing against v7 on both devices=2E

Thanks again=2E

>
>Peter

Best regards,
Luka Gejak
