Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39427 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2GBXBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 19:01:44 -0400
Received: by lbbgm6 with SMTP id gm6so8354719lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 16:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF1DE19.4070304@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-12-git-send-email-hauke@hauke-m.de> <CAGRGNgU3=WoGBrSBsuiGhTs2tx3iZMt_fjqYaxLk7rSAMw8jHQ@mail.gmail.com>
 <20120702075450.GB18990@nautica> <4FF1DE19.4070304@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 3 Jul 2012 09:01:22 +1000
Message-ID: <CAGRGNgUDcFW=QfTG=CtFmsoLY2b_F4x9g1tUzSOy7NcFpw8OEA@mail.gmail.com> (sfid-20120703_010149_963916_5779FE22)
Subject: Re: [PATCH v2 11/18] brcmsmac: remove some unnessessacry casts and
 void pointer
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Dominique Martinet <asmadeus@codewreck.org>,
	linville@tuxdriver.com, arend@broadcom.com,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Tue, Jul 3, 2012 at 3:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 07/02/2012 09:54 AM, Dominique Martinet wrote:
>> Julian Calaby wrote on Mon, Jul 02, 2012 :
>>> On Sat, Jun 30, 2012 at 11:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>>> index 478b374..8bad8b6 100644
>>>> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>>> @@ -4241,10 +4240,8 @@ static void brcms_b_watchdog(void *arg)
>>>>  }
>>>>
>>>>  /* common watchdog code */
>>>> -static void brcms_c_watchdog(void *arg)
>>>> +static void brcms_c_watchdog(struct brcms_c_info *wlc)
>>>>  {
>>>> -       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
>>>> -
>>>>         BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
>>>>
>>>>         if (!wlc->pub->up)
>>>> @@ -4284,7 +4281,9 @@ static void brcms_c_watchdog(void *arg)
>>>>
>>>>  static void brcms_c_watchdog_by_timer(void *arg)
>>>>  {
>>>> -       brcms_c_watchdog(arg);
>>>> +       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
>>>> +
>>>> +       brcms_c_watchdog(wlc);
>>>
>>> You remove 2 cases of this pattern in your patch then add one. Why?
>>
>> I'm not Hauke :) but as far as I understand, brcms_c_watchdog_by_timer
>> is used by brcms_init_timer which expects a void (*fn) (void *); and
>> which is also used with brcms_c_radio_timer
>> Admitedly, brcms_c_radio_timer also uses a struct brcms_c_info* as
>> argument, so everything could be change this way, but I think it's not
>> completely insane to keep callbacks as void* :)
>>
>> I also see the point of removing this "pattern" since it makes it easier
>> to understand with the proper type information.
>>
>> Regards,
>>
> Yes Dominique is right, that's the reason. I wanted to eliminate some of
> the void *args. I left the void *args when it was called by a callback
> function.

Fair enough then, it just looked odd next to all the other changes.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
