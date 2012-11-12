Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60148 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2KLRWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 12:22:24 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210
References: <20121108193010.GC3354@lenteja.do-not-panic.com>
	<1647271.ZFHae4zFan@lx-vladimir>
Date: Mon, 12 Nov 2012 19:22:19 +0200
In-Reply-To: <1647271.ZFHae4zFan@lx-vladimir> (Vladimir Kondratiev's message
	of "Sun, 11 Nov 2012 18:15:05 +0200")
Message-ID: <87txsuybw4.fsf@purkki.adurom.net> (sfid-20121112_182228_490772_3DBAC386)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

>> Please see
>> ath6kl's struct wmi_begin_scan_cmd on wmi.h for an example
>> of how to specify endianess to ensure that you can use this
>> driver on big or little endian. So although its great you
>> managed to successfully use sparse with -D__CHECK_ENDIAN__
>> endianess may be broken on this command and all over your
>> wmi.h. I won't even review that file then.
>
> I know about __le16 etc., but I have no big endian host to check it with. 
> Thus, I'd prefer to mention that code is not ready for big endian platform 
> rather then submit untested code. If there is a way to check endiannes without 
> having big endian host, I'd be happy to know.
> Also, is there a good way to check in Kconfig we are on Little endian?

I think this is wrong aproach. The endian support doesn't need to be
perfect, especially if you don't have any hardware to test with. Just
add endian annotations to all the fields you know of, run sparse and fix
the warnings. This should only take few hours and is much better than
refusing to compile on big endian machines.

You will get very close to a working code with that method, and it means
that all future code will have endian support "automatically" (as the
code will follow the style already used in the driver). And whenever
someone will try the driver in a big endian machine there's less to
debug and fix, with very good luck (and careful review!) it might even
work out of box :)

-- 
Kalle Valo
