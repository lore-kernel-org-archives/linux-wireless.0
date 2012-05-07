Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51683 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2EGKlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:41:36 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Subject: Re: [PATCH] fix the increment of unicast/multicast counters for forwarded PREQ
References: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com>
	<1336376603.4325.3.camel@jlt3.sipsolutions.net>
	<CAEFj9857DWGCcnF20nKYEDb0_p1K_iYLR1F=oLNAx6NjwPQE9w@mail.gmail.com>
	<1336382462.4325.4.camel@jlt3.sipsolutions.net>
	<CAEFj9855PG1Qv5RBWPJJc5tyKRz5LZZaY8qRU7oAwryH5G8L7A@mail.gmail.com>
Date: Mon, 07 May 2012 13:41:30 +0300
In-Reply-To: <CAEFj9855PG1Qv5RBWPJJc5tyKRz5LZZaY8qRU7oAwryH5G8L7A@mail.gmail.com>
	(Yeoh Chun-Yeow's message of "Mon, 7 May 2012 18:19:50 +0800")
Message-ID: <874nrs9sth.fsf@purkki.adurom.net> (sfid-20120507_124142_104180_EB6B0874)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

> Hi, Johannes
>
>>> >> +             if (da != broadcast_addr)
>>
>> will never be false.
>
> Hmm, but I have a check on this and it works. The previous line will
> set the da either as broadcast addr or unicast addr.

You are comparing pointers, not addresses. If you do that on purpose
then it's very confusing.

-- 
Kalle Valo
