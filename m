Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63EE35F163
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787236609; cv=none; b=k+kQjFza8nhhyckSJmj1mjbXfExQI/Dl2n08Q+izkKYv4zLyLP0PMsWIhdcsiBO1OVdu6/ZH5fqv3MDsXufArDDqlxNdVjiBU1xX+vlQYI0LssVCNX7AdtYwloh2D1yN+PDPV/DLGMVkCLgIGJhKGjd3Di3H+JEkBAH7LWxdqq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787236609; c=relaxed/simple;
	bh=S6AY/DIy25GVpmeBJIq9mYIVtBbuxc4KcD8t4iwe2oE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=h6tkKYf5j/4RnJmqTm+3lGb2EffjNllM7NUjpl1vYnFoPZrxrLJiGbXRhUSdWQKaWm/jjvIyGtvJ2bOX5yJSTQGXmlZ6dsET6ESTwUHNUXWAh1FwZWodQ5R9nMiQRNnyIJM7OffwRsFbUOUpKuO+RzTOBwc/DydLQS0q4gwIlXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hRhR9OW8; arc=none smtp.client-ip=95.215.58.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hRhR9OW8"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=S6AY/DIy25GVpmeBJIq9mYIVtBbuxc4KcD8t4iwe2oE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787236604; v=1; x=1787841404;
 b=hRhR9OW8O6+X3JsTsabAFo+akyEqhey32HWN9lsLUEfYuQ15KspNePBgVEBwsHM+WT76OV+V
 g+9tLNq90fdk+E8ldxbcKSZavDrxAEJJokeJpwnxCBz+wF4/zG11c1dD8VFd/ceTco9eEQwSXvn
 mygf4DWCURq5FNDQqkmMBmCs=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 526fbf4cabd751e0;
	Thu, 20 Aug 2026 14:36:34 +0000
X-Mizu-Trace-ID: 526fbf4cabd751e0
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 16:36:33 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Peter Robinson <pbrobinson@gmail.com>
CC: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: Re: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
User-Agent: Thunderbird for Android
In-Reply-To: <CALeDE9NmBpsBdVHYuzahgrxKtvzxs-ML1netc7OMOEMQ8j5+vg@mail.gmail.com>
References: <20260814105327.6687-1-luka.gejak@linux.dev> <6C350314-0529-445E-9324-FD5C21C5B495@linux.dev> <CALeDE9NmBpsBdVHYuzahgrxKtvzxs-ML1netc7OMOEMQ8j5+vg@mail.gmail.com>
Message-ID: <A119CD11-ACC4-403E-B2DD-77ED818708F1@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On August 20, 2026 1:37:22 PM GMT+02:00, Peter Robinson
<pbrobinson@gmail=2Ecom> wrote:
>Hi Luka,
>
>On Thu, 20 Aug 2026 at 10:02, Luka Gejak <luka=2Egejak@linux=2Edev> wrote=
:
>>
>> On August 14, 2026 12:53:20 PM GMT+02:00, luka=2Egejak@linux=2Edev wrot=
e:
>> >From: Luka Gejak <luka=2Egejak@linux=2Edev>
>> >
>> >This is the first of two series adding support for the Realtek RTL8723=
B
>> >802=2E11n chipset and its RTL8723BS SDIO variant to rtw88=2E It contai=
ns
>> >only the changes to the shared rtw88 core that the chip driver depends
>> >on=2E The chip itself, the build glue and the MAINTAINERS entry are a
>> >second series=2E
>> >
>>
>> =2E=2E=2E
>>
>> Hi Ping-Ke,
>>
>> Please do not apply patches 4 and 6 of v6=2E I found real bugs in both
>> after posting and a v7 is on the way=2E
>>
>> Patch 6 touches the skb after handing it to the TX worker:
>>
>>         skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
>>
>>         rtw_sdio_8723bs_stop_tx_queue(rtwdev, queue,
>>                                       skb_get_queue_mapping(skb));
>>
>> The worker can dequeue, transmit and free that skb before the second
>> statement runs, so reading it there is a use after free=2E v7 reads the
>> queue index into a local before the enqueue=2E
>>
>> Patch 4 concerns you more than me=2E It passed the padded size to
>> rtw_sdio_get_tx_addr(), where upstream passes skb->len=2E That value is
>> encoded into the CMD53 address as the transfer length, so on every othe=
r
>> SDIO chip the encoded length changed whenever sdio_align_size() padded=
=2E
>> For the RTL8723BS both expressions are the same value, so the change
>> bought this chip nothing and only affected the other parts=2E The paddi=
ng
>> itself also ran on the generic path, giving those chips an allocation
>> and an -ENOMEM path they did not have=2E v7 restores skb->len and gates
>> the padding on the chip=2E
>>
>> The other v7 changes, all in patches 4 and 6:
>>
>>   - the free page check, the output queue wait and the accounting are
>>     serialised=2E The TX worker and the H2C path both reach
>>     rtw_sdio_write_port(), and two writers could each pass the checks
>>     and claim the same pages and output queue entry, after which the
>>     chip discards one transfer silently=2E The vendor driver has one
>>     transmit thread and never needed this=2E
>>   - the padding called skb_put_zero() after checking only tailroom, so =
a
>>     cloned skb had its shared buffer written=2E It uses __skb_pad() now=
=2E
>>   - the back-pressure stop could race the drain: the worker could empty
>>     the queue while the stop was still in progress, see the flag clear,
>>     and never wake it, leaving an access category stopped with nothing
>>     left to wake it=2E
>>
>> Patches 1, 2, 3 and 5 are unchanged and keep your acks; patch 5 shifts
>> only by hunk offsets because patch 4 grew above it=2E I dropped your ac=
k
>> from patch 4, since the rework is too substantive to carry it=2E
>>
>> Most of these came from Sashiko's automated review of v6=2E I checked e=
ach
>> against the code before acting on it, and one of its eight findings did
>> not hold up=2E
>>
>> v7 follows shortly=2E It is hardware tested: 60 idle pings at 0% loss w=
ith
>> power save on, bidirectional load with no stall, 19=2E6 Mbit/s up and 3=
6=2E8
>> down, UDP at 0% loss, three scans, three reconnects and a clean log=2E
>
>I had done some basic testing with v5, and had left a v6 to build
>overnight=2E I'll grab this shortly and do a build with v7 and do some
>testing=2EIt was generally looking stable on the Pine64+ board I was
>using for testing=2E
>

Thanks a lot for testing=2E In my testing changes in v6 and v7 didn't impa=
ct
performance and v7 should be as stable if not more stable then v5 and v6=
=2E

>I think I may also have a device(s) with a 8723cs and/or a 8723ds I
>can possibly test with, I'll see if I can remember/find it over the
>weekend and get it running for some testing of that too=2E

That would be nice, so we can see if other chips are affected, as Ping-Ke
said=2E

>
>Peter

Best regards,
Luka Gejak
