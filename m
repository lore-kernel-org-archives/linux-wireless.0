Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36933 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab3FLSwT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 14:52:19 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: Re: [PATCH] mwifiex: Add module parameter for regdomain
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com>
	<877ghz3il6.fsf@purkki.adurom.net>
	<477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com>
Date: Wed, 12 Jun 2013 21:52:16 +0300
In-Reply-To: <477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com>
	(Bing Zhao's message of "Wed, 12 Jun 2013 10:43:19 -0700")
Message-ID: <8738sn2mcf.fsf@purkki.adurom.net> (sfid-20130612_205223_491923_CF361C15)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing Zhao <bzhao@marvell.com> writes:

> Hi Kalle,
>
>> > From: Avinash Patil <patila@marvell.com>
>> >
>> > Allow a regulatory domain country code to be specified at boot
>> > using a module argument.  This overrides the firmware regulatory
>> > mode.
>> >
>> > This patch also enables uAP to operate in 11a mode with hostapd.
>> >
>> > Signed-off-by: Avinash Patil <patila@marvell.com>
>> > Signed-off-by: Paul Stewart <pstew@chromium.org>
>> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
>> 
>> This looks ugly. Why can't you use the proper nl80211 interface and
>> instead want to add a driver specific hack?
>
> "iw reg set XX" or "country_code=XX" in hostapd.conf is a *user* hint.
>
> What we need here is a *driver* hint. Furthermore, with a driver
> regulatory hint, the passive-scan and no-ibss flags are cleared so we
> can start AP with hostapd on 5G band.

So it's a driver hint which is coming from user space via a module
parameter. IMHO you are abusing interfaces here. Is there any better way
to solve your problem?

-- 
Kalle Valo
