Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59686 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2GPFT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 01:19:58 -0400
Received: by obbuo13 with SMTP id uo13so8973136obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jul 2012 22:19:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANugF34NThUR1KkDHX8tiO7RC8uJLfbGLU=0=fFd2OQcBnAwAw@mail.gmail.com>
References: <CANugF35YQzs7gi4htrgCUKrTDp_ia0RUo9g_HNJ=CzfnOCkO2g@mail.gmail.com>
	<CANugF37dDx1mvNJ-Y3is6OaeVFD1KwH=yh8Xef2BrN=YQPsiZQ@mail.gmail.com>
	<1341558944.4462.9.camel@jlt3.sipsolutions.net>
	<CANugF35qjKLdhBprQviNJaAPfM910wFCSbyEvdcCRj_UoKLqPQ@mail.gmail.com>
	<CANugF34NThUR1KkDHX8tiO7RC8uJLfbGLU=0=fFd2OQcBnAwAw@mail.gmail.com>
Date: Mon, 16 Jul 2012 10:49:57 +0530
Message-ID: <CAD2nsn1xxNBnBB6S-6e3+-exW=NZhgsDiyuQQmFM8Om4U1pnAg@mail.gmail.com> (sfid-20120716_072002_375228_AA8EB0D3)
Subject: Re: v3.4.4 ath9k: kernel NULL pointer dereference in skb_dequeue
 during heavy udp xmit
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Andrew Chant <andrew.chant@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2012 at 12:05 PM, Andrew Chant <andrew.chant@gmail.com> wrote:
> Any QCA people get a chance to take a look?  This is completely
> reproducible for me on 3.4.4, sometimes within a few minutes but
> occasionally requires up to an hour.  Do you qca folks have any tests
> where you continuously transmit as many UDP packets as you possibly
> can to another host?

please check whether the following patch helps.
http://comments.gmane.org/gmane.linux.kernel.wireless.general/93723
Could please help whether it happens with wireless-testing tree ?
http://linuxwireless.org/en/developers/Documentation/git-guide#Cloning_latest_wireless-testing

>
> On Fri, Jul 6, 2012 at 12:46 AM, Andrew Chant <andrew.chant@gmail.com> wrote:
>> I was able to reproduce this on a boot shortly afterwards without
>> changing the frequencies.
>> Exact same stack trace w/ exception of slightly different values for
>> RBX & R15, and R10 had 0x7f instead of 0x80.  I have not been able to
>> reproduce since despite trying quite hard :)  I have a picture of the
>> second oops if that helps.
>> PCI ID is 168c:0030 (AR9300 Wireless LAN adaptor (rev 01))
>> -Andrew
>>
>> On Fri, Jul 6, 2012 at 12:15 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> -John
>>> +QCA folks
>>>
>>> On Thu, 2012-07-05 at 21:36 -0700, Andrew Chant wrote:
>>>
>>>>  while performance testing ath9k -> ath9k performance in 3.4.4, I got
>>>> a nasty kernel panic.  My performance testing involved filling the air
>>>> with 1410-byte UDP packets between the machines, and switching the
>>>> frequencies of the two cards to see how frequency affected
>>>> performance.  I had switched between channels 36, 40, 44, and 48.
>>>> Oops was on the transmitting machine, which was acting as the AP.
>>>>
>>>> Very clear screen image of the oops is at
>>>> https://picasaweb.google.com/lh/photo/CjBdHLZH0up5PrnmCySJidMTjNZETYmyPJy0liipFm0?feat=directlink
>>>
>>> I briefly looked at this, but I don't see a bug in mac80211. It seems
>>> likely that ath9k hands back a corrupted SKB, or frees one it no longer
>>> owns, or such. The skb->next/prev pointers seem corrupted (rcx is NULL)
>>> in one of the SKBs on the list, but mac80211 can't do that afaict.
>>>
>>> johannes
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
