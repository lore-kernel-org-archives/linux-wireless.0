Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:55827 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LaOrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 09:47:19 -0500
Received: by mail-we0-f176.google.com with SMTP id r5so5810568wey.7
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2012 06:47:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121231084639.GB23038@pandem0nium>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50D04EC9.2040805@neratec.com>
	<CAJ-VmonRjawqBY+F_-in3sSTpen=KaW9FNrG=140q38NtFCJbw@mail.gmail.com>
	<20121231084639.GB23038@pandem0nium>
Date: Mon, 31 Dec 2012 06:38:58 -0800
Message-ID: <CAJ-VmokLkUY5Gc2AOHssFzEcAzEuF99EwZr5Hpz3QecytPPJBQ@mail.gmail.com> (sfid-20121231_154724_180803_8CB68C4E)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, jonbither@gmail.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 December 2012 00:46, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:

>> Your frame length logic is OK for the short spectral scan reports, but
>> not useful for the longer aggregate reports (short_rpt=0 IIRC.)
>
> Yeah, I've always used short_rpt=1 AFAIR.
>>
>> Here there's >1 FFT report in a frame, _and_ it could be corrupted,
>> _and_ it could be short.
>
> That sounds like a lot of fun :P

Yeah. Ew.

> Before asking questions, I'll wait for your userland lib and see what
> it does. I've seen some longer frames as well occasionally when starting
> to play with spectral, but didn't care too much as I didn't know how to
> handle it. Anyway, I prefer hiding the corrupt and messy part and only
> pass "clean data" to userspace, at least with the Linux implementation.

I'm taking the opposite approach - I'll pass the PHY error frames up
to userland untouched (and with extra radiotap vendor info like
per-chain RSSI/NF calibration values) and do the fixups in userland.

The only fixups I'd do in kernel is stuff that requires register
hackery to do. Otherwise I have to replace the driver each time I want
to change/extend/fix something.

I'm doing the same with radar pulse handling - it's exposed via
bpf/radiotap the same way that any other frame is. Userland can then
just see what kind of packet it is by inspecting the radiotap header
and do what it needs to.

> If you have some code handling and/or correct these long dataframes, I'd
> be happy to integrate it if possible.

Well right now I'm just trying to finish writing a thin layer to
decode (and make sure I'm decoding the correct data!) before I worry
about finding/fixing corrupted frames.
I'll try to commit what I have thus far to FreeBSD today/tomorrow but
I also have real work to get done.

I've taken your code and broken it out a bit to support multiple data
sources, rather than just a hard-coded single data source from a file.
That way I can (in theory) just add a FreeBSD data source and
represent data as you need.

Also, yes - I'm using whatever your FFT_eval code in userland is. :-)



Adrian
