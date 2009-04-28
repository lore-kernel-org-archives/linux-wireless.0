Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:40298 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZD1U2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 16:28:06 -0400
Received: by yx-out-2324.google.com with SMTP id 3so441485yxj.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2009 13:28:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890904280853y419b9dcfw13722345892fa9b4@mail.gmail.com>
References: <30715795.1255391240909093356.JavaMail.coremail@bj163app124.163.com>
	 <43e72e890904280853y419b9dcfw13722345892fa9b4@mail.gmail.com>
Date: Tue, 28 Apr 2009 13:28:04 -0700
Message-ID: <45e8e6c40904281328u23c983b0r22b38d345ce0f2a1@mail.gmail.com> (sfid-20090428_222812_421730_99539D5A)
Subject: Re: Question about 802.11s(mesh)
From: Andrey Yurovsky <andrey@cozybit.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: =?GB2312?B?y9Ww18H6?= <subailong@163.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 28, 2009 at 8:53 AM, Luis R. Rodriguez
<mcgrof@winlab.rutgers.edu> wrote:
> 2009/4/28 =CB=D5=B0=D7=C1=FA <subailong@163.com>:
>>      My question is:"Can all of the wireless networking cards run in=
 mesh
>> mode?" I think they all can. But  why some can not as it is describe=
d in the
>> web page http://linuxwireless.org/en/users/Drivers? Please give  me =
the
>> detailed reasons.

Each driver must support several things as listed on this page under "M=
ESH":
http://wireless.kernel.org/en/developers/Documentation/mac80211/API
in order to support mac80211's draft-802.11s mesh.  Basically it must
allow a mesh-mode interface, support mesh beaconing, and support
certain RX filters.  So drives do this and have been tested (for
example, ath5k, b43, and zd1211rw).  Others do use the mac80211 stack
but either haven't been tested or don't support something that mesh
mode requires.  Any mac80211 driver that supports beaconing (at least
for AP or IBSS) should be able to support mesh mode after making the
changes listed in the API document.

--=20
Andrey Yurovsky
cozybit Inc.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
