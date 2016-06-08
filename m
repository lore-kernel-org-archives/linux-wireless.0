Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38056 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424457AbcFHOq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 10:46:57 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to remove
 wireless core warns
Date: Wed, 8 Jun 2016 14:46:47 +0000
Message-ID: <87porrkaax.fsf@kamboji.qca.qualcomm.com> (sfid-20160608_164935_290745_74BBAD00)
References: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com>
	<87wplzkbd9.fsf@kamboji.qca.qualcomm.com>
	<CAEO8o4=DnEfXQAnAOxugC9TngbhvgV9DXz0HOVHNLk0B2fAXQA@mail.gmail.com>
In-Reply-To: <CAEO8o4=DnEfXQAnAOxugC9TngbhvgV9DXz0HOVHNLk0B2fAXQA@mail.gmail.com>	(Prasun
 Maiti's message of "Wed, 8 Jun 2016 20:05:15 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prasun Maiti <prasunmaiti87@gmail.com> writes:

> No. I did not any test for that case.
> This driver create a new wiphy for use with cfg80211 through
> "wiphy_new_nm" api, but in this api, I found that more warnings for
> inconsistent ops are added there. e.g; "WARN_ON(ops->set_antenna &&
> !ops->get_antenna);"
> So, warning comes during creation of a new wiphy. That's why It is needed.

I'm confused. Are you really saying that you added a new firmware
command (WMI_SET_ANTENNA_CMDID) to ath6kl but you didn't test it in any
way? How do you know that it works then?

-- 
Kalle Valo