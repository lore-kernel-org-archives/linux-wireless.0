Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56076 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2LaHsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 02:48:38 -0500
Received: by mail-wg0-f50.google.com with SMTP id es5so5561890wgb.17
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2012 23:48:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50D04EC9.2040805@neratec.com>
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<20121213140753.GA26868@pandem0nium>
	<50D04EC9.2040805@neratec.com>
Date: Sun, 30 Dec 2012 23:48:36 -0800
Message-ID: <CAJ-Vmom8FRrHB0ts1infzgWuXFJjkpvqkB2LyxdZFsP_Vq=4WA@mail.gmail.com> (sfid-20121231_084851_284542_89976051)
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
From: Adrian Chadd <adrian@freebsd.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, jonbither@gmail.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Simon - I've reviewed your code a bit.

You're not (yet) shifting the magnitude values over as needed before
trying to extract the channel power out of it all.

Specifically:

* each bin has a 7 bit value;
* the bin value is scaled by max_exp;
* there's a max magnitude value which I don't think you need for
spectral FFT reports; only radar FFT reports (since in radar FFT
reports, the reported FFT bins are between 0..7/8ths of the maximum
magnitude value)

You're not scaling the data by max_exp in your FFT dump program, so
the values aren't entirely correct.
Are you doing it in the kernel code?

I've just finished my first pass at this and plotting whatever values
I get from the spectral data frames. I'll post more updates as I
find/fix more bugs.

Thanks,



Adrian
