Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51084 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbcDBOyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2016 10:54:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Erez\, Maya" <merez@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>,
	Maya Erez <qca_merez@qca.qualcomm.com>,
	Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 2/2] wil6210: add module parameter for alternate interface name
References: <1458590472-677-1-git-send-email-qca_merez@qca.qualcomm.com>
	<1458590472-677-3-git-send-email-qca_merez@qca.qualcomm.com>
	<87y499dxjf.fsf@kamboji.qca.qualcomm.com>
	<56F3BBB4.6030104@codeaurora.org>
	<87wpok9n9g.fsf@kamboji.qca.qualcomm.com>
	<56FFA3D0.7080603@codeaurora.org>
Date: Sat, 02 Apr 2016 17:54:27 +0300
In-Reply-To: <56FFA3D0.7080603@codeaurora.org> (Maya Erez's message of "Sat, 2
	Apr 2016 13:49:52 +0300")
Message-ID: <87fuv4gixo.fsf@kamboji.qca.qualcomm.com> (sfid-20160402_165437_473373_50AACFC9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Erez, Maya" <merez@codeaurora.org> writes:

> On 3/30/2016 3:13 PM, Kalle Valo wrote:
>
>     Lior David <liord@codeaurora.org> writes:
>
>
>         As I see it, it is an issue of classification. Network drivers use a
>
>     default
>
>         interface name prefix depending on the device type. Ethernet drivers get
>
>     "eth%d",
>
>         wireless drivers get "wlan%d" and so on. There are even existing drivers
>         that give different prefixes based on other conditions, for example see
>         drivers/s390/net/ctcm_main.c, ctcm_init_netdevice.
>         For our 11ad device, in many platforms it is used as a wifi replacement,
>
>     so
>
>         the wlan%d name is appropriate, in other platforms it is used as
>         a different wireless device for different purposes, so the default
>
>     "wigig%d"
>
>         prefix seems appropriate.
>
>     Every platform works differently, even systemd even has it's own weird
>     naming scheme:
>
>     https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterf
>     aceNames/
>
>     I really don't think that we should start working around interface
>     naming problems by selecting the name with module parameters. But having
>     "wigig%d" as the default sounds like a good idea to me.
>
>
> Thanks, Kalle. We will check your suggestion to change the interface name to
> "wigig%d".
>
> Can you drop this patch for now?

Ok, patch 2 dropped. Patch 1 is still on my queue and will be applied
"really soon now" :)

-- 
Kalle Valo
