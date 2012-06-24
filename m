Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38700 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2FXENR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 00:13:17 -0400
Received: by dady13 with SMTP id y13so3937096dad.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jun 2012 21:13:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <48EC4E8D43A28947B1AB2639FA97CDB901524A5F@nasanexd02a.na.qualcomm.com>
References: <1330343526-5335-1-git-send-email-zefir.kurtisi@neratec.com>
	<48EC4E8D43A28947B1AB2639FA97CDB901524852@nasanexd02a.na.qualcomm.com>
	<4F4CC111.7040909@neratec.com>
	<48EC4E8D43A28947B1AB2639FA97CDB901524A5F@nasanexd02a.na.qualcomm.com>
Date: Sat, 23 Jun 2012 21:13:17 -0700
Message-ID: <CAJ-Vmok2dnt8n0L7ouEzYX7479p8_-MMoXU4p4ce0PYc7ggrxg@mail.gmail.com> (sfid-20120624_061354_589114_499CD8F0)
Subject: Re: [PATCH] ath9k: decouple RX error checking for DFS
From: Adrian Chadd <adrian@freebsd.org>
To: "Chadd, Adrian" <achadd@qca.qualcomm.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2012 07:59, Chadd, Adrian <achadd@qca.qualcomm.com> wrote:
> Hi,
>
> That's interesting. I have found the AR9280 to do the same. I hadn't gone digging into it though, I've been busy with other things but it was on my todo list. So thankyou for finding it. :-)

Well, now I've looked at it. :-)

>
> Specifically (and this is all under BSD):
>
> * I'd start rx'ing radar errors;
> * then they'd become crc errors;
> * after some indeterminate amount of time, they'd drift back to being radar errors.

I see this exact behaviour on the AR5416. I'll test on the AR9130,
AR9160 and AR9280 next week.

I'll chat with you next week about extending it to generate the chirp
pulses and random interval PRI pulses. (And fixes to make it compile
on FreeBSD rather than Linux; I have it running on FreeBSD, but it
required some "fixes" to the source and Makefile.)

Thanks for doing the legwork on the USRP radar pulse generation stuff!



Adrian
