Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58980 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab2GBRpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 13:45:05 -0400
Message-ID: <4FF1DE19.4070304@hauke-m.de> (sfid-20120702_194510_169239_B6A7DB28)
Date: Mon, 02 Jul 2012 19:44:57 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Dominique Martinet <asmadeus@codewreck.org>
CC: Julian Calaby <julian.calaby@gmail.com>, linville@tuxdriver.com,
	arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 11/18] brcmsmac: remove some unnessessacry casts and
 void pointer
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de> <1341062181-28071-12-git-send-email-hauke@hauke-m.de> <CAGRGNgU3=WoGBrSBsuiGhTs2tx3iZMt_fjqYaxLk7rSAMw8jHQ@mail.gmail.com> <20120702075450.GB18990@nautica>
In-Reply-To: <20120702075450.GB18990@nautica>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/02/2012 09:54 AM, Dominique Martinet wrote:
> Julian Calaby wrote on Mon, Jul 02, 2012 :
>> On Sat, Jun 30, 2012 at 11:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>> index 478b374..8bad8b6 100644
>>> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>> @@ -4241,10 +4240,8 @@ static void brcms_b_watchdog(void *arg)
>>>  }
>>>
>>>  /* common watchdog code */
>>> -static void brcms_c_watchdog(void *arg)
>>> +static void brcms_c_watchdog(struct brcms_c_info *wlc)
>>>  {
>>> -       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
>>> -
>>>         BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
>>>
>>>         if (!wlc->pub->up)
>>> @@ -4284,7 +4281,9 @@ static void brcms_c_watchdog(void *arg)
>>>
>>>  static void brcms_c_watchdog_by_timer(void *arg)
>>>  {
>>> -       brcms_c_watchdog(arg);
>>> +       struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
>>> +
>>> +       brcms_c_watchdog(wlc);
>>
>> You remove 2 cases of this pattern in your patch then add one. Why?
> 
> I'm not Hauke :) but as far as I understand, brcms_c_watchdog_by_timer
> is used by brcms_init_timer which expects a void (*fn) (void *); and
> which is also used with brcms_c_radio_timer
> Admitedly, brcms_c_radio_timer also uses a struct brcms_c_info* as
> argument, so everything could be change this way, but I think it's not
> completely insane to keep callbacks as void* :)
> 
> I also see the point of removing this "pattern" since it makes it easier
> to understand with the proper type information.
> 
> Regards,
> 
Yes Dominique is right, that's the reason. I wanted to eliminate some of
the void *args. I left the void *args when it was called by a callback
function.

Hauke
