Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53687 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1JOKBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 06:01:39 -0400
Received: by gyb13 with SMTP id 13so1817931gyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 03:01:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111015093902.GA23520@ecki>
References: <CAJ-Vmok8FvrYtT2QwXY0NowLSogfkZYNbGLFbVR8Uzv507FrdA@mail.gmail.com>
	<CAD2nsn0Z2J4r4tN_fLjx5bbvz2bg6NVcQ8vppJbbNcgOF8pFew@mail.gmail.com>
	<CAJ-VmokcM4KmzV7Rn9PA68iEiTJiPw=ffYgNFLDAHShxD0HNAg@mail.gmail.com>
	<20111003084823.GA1521@ecki.lan>
	<CAJ-Vmo=sE4KeOp1CKAR5v+Rzm1bm0R=ZvtMvJaE_8Sjn1dOdsw@mail.gmail.com>
	<20111004181534.GA1502@ecki>
	<CAJ-Vmo=5z6EEZBtb2_7e6wvU39ZvLSmAxEPKwP_MDQCzdkPGyA@mail.gmail.com>
	<20111005062528.GA1403@ecki>
	<CAJ-Vmok4v2+ZEpAmVaj2pQ5U2StWxxD8f20u2Ln87o4+C_ST0g@mail.gmail.com>
	<CAD2nsn1S7r2o0bqnNgzuHBd9XWYdA7uZgtmtFDTePk0SwybuCQ@mail.gmail.com>
	<20111015093902.GA23520@ecki>
Date: Sat, 15 Oct 2011 18:01:38 +0800
Message-ID: <CAJ-VmokQBcXyDByWgMfGRFvW_z_9YU4oPUrXJpfPY9J4riEuBQ@mail.gmail.com> (sfid-20111015_120150_089631_1D33BDDF)
Subject: Re: ath9k: irq storm after suspend/resume
From: Adrian Chadd <adrian@freebsd.org>
To: Clemens Buchacher <drizzd@aon.at>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've found some perhaps relevant bits of code here which force the
chip into and out of reset/sleep states.

It's possible that your BIOS doesn't fully reset the NIC upon startup.
It's also possible there are issues with the ath9k power save/resume
code. It's also possible they're all compounding to make things worse.
Are you able to completely and utterly disable any/all power saving on
ath9k, including APSM if you have it enabled?

Unfortunately the information I have is a bit sketchy. I'll do some
further digging (and hope I don't bug Atheros people too much :) to
see if I can extract out some more information about what's going on.

Thanks,


Adrian
