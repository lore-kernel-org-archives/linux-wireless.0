Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45158 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab3IIUBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 16:01:02 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: regulatory will stuck when cfg80211 is built-in
References: <CAFSJ42bTQkQO+yugN7BBjygQd7LY9H0bPBoPfoH7yyfyMzuGqA@mail.gmail.com>
Date: Mon, 09 Sep 2013 23:01:00 +0300
In-Reply-To: <CAFSJ42bTQkQO+yugN7BBjygQd7LY9H0bPBoPfoH7yyfyMzuGqA@mail.gmail.com>
	(Eugene Krasnikov's message of "Mon, 9 Sep 2013 08:16:47 +0200")
Message-ID: <87ppshu5mr.fsf@purkki.adurom.net> (sfid-20130909_220105_685476_1F91499F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eugene Krasnikov <k.eugene.e@gmail.com> writes:

> There is a problem with regulatory part of cfg80211 when cfg80211 is
> built-in the kernel. On regulatory init cfg80211 will try to notify
> user space about changing current domain to world regulatory but at
> that time user space is not up and running yet and uevent message will
> be lost. So what will happen is that cfg80211 will wait for the
> response from user space and all requests to set current regulatory
> will be dropped with the following error: “Pending regulatory request,
> waiting for it to be processed...”.

Does CONFIG_CFG80211_INTERNAL_REGDB help?

-- 
Kalle Valo
