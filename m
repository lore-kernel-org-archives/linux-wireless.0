Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:47473 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbaDLStf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Apr 2014 14:49:35 -0400
Date: Sat, 12 Apr 2014 20:49:29 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <433601888.20140412204929@eikelenboom.it> (sfid-20140412_204939_927767_0054E18C)
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
CC: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <collen@cozybit.com>
Subject: Re: [RFC/RFT] cfg80211: reg: track crda request
In-Reply-To: <CAFED-jkPtXU8moGrb4XiriU-c7WokgSiXq6g0jCLOhk3dJnoLg@mail.gmail.com>
References: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com> <2710039777.20140411192110@eikelenboom.it> <CAFED-jkPtXU8moGrb4XiriU-c7WokgSiXq6g0jCLOhk3dJnoLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Friday, April 11, 2014, 9:55:50 PM, you wrote:

> 2014-04-11 19:21 GMT+02:00 Sander Eikelenboom <linux@eikelenboom.it>:
>>
>> Friday, April 11, 2014, 2:29:34 PM, you wrote:
>>
>>
>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>> ---
>>> This is instead of:
>>> cfg80211: fix processing world regdomain when non modular
>>
>>> @Sander @Colleen - could you chec this one?

>> <big snip>
>>

> Thanks for test :)
> Are you using CONFIG_CFG80211_INTERNAL_REGDB?
> I will check this option also (could be I miss cancel timeout in case
> of internal regdb or 00 wasn't set correctly in db.txt).
> Could you also send db.txt from net/wireless if INTERNAL_REGDB?

> In case you don't use internal regdb, are you sure you choose/install
> crda from menuconfig? It looks like you don't have /(s)bin/crda? Could
> you confirm you have crda command installed and could be executed (I
> could reproduce exactly same messages when remove +x from crda).

Ok you were right .. i was testing this on another openwrt router image that
seems to be half baked (this has been dragging on for quite a while .. so it was
a long time ago i played with this) .. and indeed it didn't had the crda package installed.

Now that the crda packages is installed the patch seems to work well and it 
fixes my initial problem :-)
Hope it works for Collen as well ...

So you can stick on a:

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Tested-by: Sander Eikelenboom <linux@eikelenboom.it>

Thanks !

--
Sander


> In case you don't use internal_regdb + db.txt nor crda I think Luis
> patch could just hide problem while remove "Pending regulatory ..."
> print.

> With Luis patch what you see after:
> iw reg set PL
> iw reg get

> BR
> Janusz


