Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48127 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaDNT6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 15:58:07 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so8675369wgh.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 12:58:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <433601888.20140412204929@eikelenboom.it>
References: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com>
	<2710039777.20140411192110@eikelenboom.it>
	<CAFED-jkPtXU8moGrb4XiriU-c7WokgSiXq6g0jCLOhk3dJnoLg@mail.gmail.com>
	<433601888.20140412204929@eikelenboom.it>
Date: Mon, 14 Apr 2014 12:58:04 -0700
Message-ID: <CANrMYP6pCQ666+p6wa7TtKBgHGmp5VuRGAThq6h+tqZfEaF7WA@mail.gmail.com> (sfid-20140414_215820_472310_139F377F)
Subject: Re: [RFC/RFT] cfg80211: reg: track crda request
From: Colleen T <colleen@cozybit.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>, collen@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 12, 2014 at 11:49 AM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
>
> Friday, April 11, 2014, 9:55:50 PM, you wrote:
>
>> 2014-04-11 19:21 GMT+02:00 Sander Eikelenboom <linux@eikelenboom.it>:
>>>
>>> Friday, April 11, 2014, 2:29:34 PM, you wrote:
>>>
>>>
>>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>>> ---
>>>> This is instead of:
>>>> cfg80211: fix processing world regdomain when non modular
>>>
>>>> @Sander @Colleen - could you chec this one?
>
>>> <big snip>
>>>
>
>> Thanks for test :)
>> Are you using CONFIG_CFG80211_INTERNAL_REGDB?
>> I will check this option also (could be I miss cancel timeout in case
>> of internal regdb or 00 wasn't set correctly in db.txt).
>> Could you also send db.txt from net/wireless if INTERNAL_REGDB?
>
>> In case you don't use internal regdb, are you sure you choose/install
>> crda from menuconfig? It looks like you don't have /(s)bin/crda? Could
>> you confirm you have crda command installed and could be executed (I
>> could reproduce exactly same messages when remove +x from crda).
>
> Ok you were right .. i was testing this on another openwrt router image that
> seems to be half baked (this has been dragging on for quite a while .. so it was
> a long time ago i played with this) .. and indeed it didn't had the crda package installed.
>
> Now that the crda packages is installed the patch seems to work well and it
> fixes my initial problem :-)
> Hope it works for Collen as well ...

Yes, it does.  I applied this to mac80211-next and tested.  No crashes
or problems on our test framework.  I can load mac80211_hwsim reliably
with my reg domain in /etc/default/crda (debian qemu).

So either this or Arik's patch on top of Luis' work for me.

Feel free to add:
Tested-by: Colleen Twitty <colleen@cozybit.com>

Thanks,
Colleen

> So you can stick on a:
>
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
>
> Thanks !
>
> --
> Sander
>
>
>> In case you don't use internal_regdb + db.txt nor crda I think Luis
>> patch could just hide problem while remove "Pending regulatory ..."
>> print.
>
>> With Luis patch what you see after:
>> iw reg set PL
>> iw reg get
>
>> BR
>> Janusz
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
