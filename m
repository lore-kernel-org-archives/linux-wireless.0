Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37049 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbCELka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 06:40:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>, Jim Davis <jim.epost@gmail.com>,
	Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Subject: Re: [PATCH] bcma: Kconfig: Let it depend on PCI
References: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
	<CACna6rw03OfforxrV5nWLYTUW64BQ-vvH9TuZqK2q9__2Y0edA@mail.gmail.com>
Date: Thu, 05 Mar 2015 13:40:23 +0200
In-Reply-To: <CACna6rw03OfforxrV5nWLYTUW64BQ-vvH9TuZqK2q9__2Y0edA@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Wed, 4 Mar 2015
 23:23:32 +0100")
Message-ID: <87r3t365aw.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_124048_704728_C5EC91E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Kalle, I guess the recent discussion and work on this problem could be
> confusing, so let me try to sum it up it a bit.
>
> First of all, please note there are 3 awaiting bcma patches that
> should be applied independently of what we decide to do with this
> patch. They are of course inspired by the recent building problems.
> List of these patches:
> [PATCH next] bcma: make bcma_host_pci_(up|down) calls safe for every config
> [PATCH next] bcma: move internal function declarations to private header
> [PATCH next] bcma: prepare Kconfig symbol for PCI driver
>
> Now, the building problem is obviously caused by me, my work on
> driver_pcie2.c and using pcie_set_readrq there without making sure
> that is PCI available. I'm sorry for that.
>
> All 3 above patches are moving us toward the the most optimal solution
> of this problem. Depending on PCI only when it's really required.
> There is still one more change missing that I'm working on. It'll take
> me about 2 more days to get the last patch.
> On the other way, patch proposed by Chen fixes building problem right
> now. It's much simpler but bumps bcma requirements a bit too high.
> bcma doesn't really have to depend on PCI.

Thanks for the good summary, it clarified things for me.

> So you have 2 options there and I'll be happy with whatever you choose to do:
> 1) Pick Chen patch now and in ~2 days apply my final fix + revert Chen
> patch.

I'll prefer this option so that we can quickly solve the build problem.
Also once your final fix is ready, please remember that you need to
revert Chen's patch within the same patch.

-- 
Kalle Valo
