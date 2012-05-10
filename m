Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64105 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab2EJUDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 16:03:54 -0400
Received: by vbbff1 with SMTP id ff1so1928370vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 13:03:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120510130711.GA15533@shaftnet.org>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
	<CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
	<CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com>
	<20120509203730.GE17416@shaftnet.org>
	<CABF+-6VUMoueQTA5_JUEOjiya5eQY=bAzt=cnr23HJ=ssedQSw@mail.gmail.com>
	<20120510130711.GA15533@shaftnet.org>
Date: Thu, 10 May 2012 16:03:53 -0400
Message-ID: <CABF+-6Uymww9qK4o1=XP_MLcvpa-rpugW6SMLaXUBr21z=dkBg@mail.gmail.com> (sfid-20120510_220358_685876_D4C751FC)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Solomon,

> I don't believe it will cause any problems, as the bluetooth pins aren't
> hooked up on the SG901-1091 module.  That said, the PTA record on the
> current Sagrad SDD files for the 1091/1098 modules specifies that BT
> coexistence is disabled (ePTA mode = 0), so it should be functionally
> equivalent to no PTA record being present.

It is good to know the Sagrad SDD file is disabling PTA in the
hardware even though there is a PTA record present.

Although, at least with the driver Dmitry posted on this mailing list,
the driver is taking action simply on the presence of the PTA record.
I can easily disable this for my testing.

I wonder if the parsing of the SDD file in the driver could be a
little smarter to detect that the PTA record is actually disabling PTA
and not assume the existence of a PTA record means PTA is being used.


Kevin
