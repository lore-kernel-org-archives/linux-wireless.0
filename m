Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52262 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab1FXQXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 12:23:04 -0400
Received: by wwe5 with SMTP id 5so3034394wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 09:23:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=zUKqmCiMkQQsf3QjuyQH33O06iQ@mail.gmail.com>
References: <BANLkTikB3OS+=w5qO6sb2jABhUSeGh86Tg@mail.gmail.com>
	<BANLkTikkYuENv4CSNxb_NcT2ga0PqHwR2Q@mail.gmail.com>
	<BANLkTi=zUKqmCiMkQQsf3QjuyQH33O06iQ@mail.gmail.com>
Date: Fri, 24 Jun 2011 21:53:02 +0530
Message-ID: <BANLkTi=3E14QJotwU63xHYnz-hCd2gefcw@mail.gmail.com> (sfid-20110624_182308_740593_B6964612)
Subject: Re: cfg80211 'iw reg set' no longer works after trying to set invalid
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Laura Nayman <lnayman@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 24, 2011 at 9:49 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Fri, Jun 24, 2011 at 9:43 PM, Mohammed Shafi
> <shafi.wireless@gmail.com> wrote:
>> On Fri, Jun 24, 2011 at 8:13 PM, Laura Nayman <lnayman@gmail.com> wrote:
>>> cfg80211 'iw reg set' no longer works after trying to set invalid country
>>> code
>>>
>>> You can change the wireless region by using 'iw set reg'. Normally you can
>>> switch back and forth just fine...
>>>
>>> # iw reg set US
>>> # iw reg get | grep country
>>> country US:
>>> # iw reg set JP
>>> # iw reg get | grep country
>>> country JP:
>>> # iw reg set US
>>> # iw reg get | grep country
>>> country US:
>>>
>>>
>>> However, if we try to use an invalid country code, such as XX:
>>> # iw reg set XX
>>> # iw reg get | grep country
>>> country US:
>>> ... it doesn't take. Okay, no big deal. Let's try setting it back to JP:
>>> # iw reg set JP
>>> # iw reg get | grep country
>>> country US:
>>>
>>> We're now stuck at the country code we were at before we put the invalid one
>>> in.
>>>
>>> In dmesg, this exchange looks like:
>>> # dmesg | grep cfg80211
>>> cfg80211: Calling CRDA to update world regulatory domain
>>> cfg80211: World regulatory domain updated:
>>> cfg80211: Calling CRDA for country: US
>>> cfg80211: Regulatory domain changed to country: US
>>> cfg80211: Calling CRDA for country: JP
>>> cfg80211: Regulatory domain changed to country: JP
>>> cfg80211: Calling CRDA for country: US
>>> cfg80211: Regulatory domain changed to country: US
>>> cfg80211: Calling CRDA for country: XX
>>> ... and we're stuck there.
>>>
>>> What looks to be happening is that the kernel uses udev to call /sbin/crda
>>> with a new COUNTRY= setting, but /sbin/crda bails out with -1 because of 'No
>>> country match in regulatory database', and never sends a netlink message
>>> back to the kernel to give it the regulatory information for that country.
>>> The kernel then seems to be stuck waiting for a message that will never
>>> come.
>>>
>>> The only way I can figure to unstick it is to reboot.
>>
>> true you may be using old wireless-testing/compat wireless, i too got
>> this issue in Jan compat wireless
>>
>> does this happens with the latest compat wireless. please check?
>> http://wireless.kernel.org/download/compat-wireless-2.6/
>>
>>
>> this would have fixed it
>>
>> commit c989bb15e95a93e20fc86783264f6298116e8651
>> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>> Date:   Mon Apr 25 18:35:48 2011 -0700
>>
>>    cfg80211: fix regresion on reg user timeout
>>
>>    The patch "cfg80211: add a timer for invalid user reg hints"
>>    introduced a regression for the case where a secondary identical
>>    regulatory hint from a user is sent. What would happen is the
>>    second hint would schedule delayed work in to catch a timeout
>>    but since we are never processing it given that the hint was already
>>    applied we'd always hit the timeout and and restore regulatory
>>    settings back to world regulatory domain. This is fixed by simply
>>    avoiding sheduling work if the hint was already applied.
>>
>>    Tested-by: Felix Fietkau <nbd@openwrt.org>
>>    Reported-by: Felix Fietkau <nbd@openwrt.org>
>>    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 2714379..8982053 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -1455,7 +1455,8 @@ static void reg_process_hint(struct
>> regulatory_request *reg_request)
>>         * We only time out user hints, given that they should be the only
>>         * source of bogus requests.
>>         */
>> -       if (reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
>> +       if (r != -EALREADY &&
>> +           reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
>>                schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
>>  }
>>
> sorry that does not seems the commit that fixed it , i will point the
> correct one.
>


got it and got a but entry too, please upgrade to latest
compat/wireless-testing because this commit introduced a regression,
which is fixed later with the commit i told before

mmit a90c7a313a1c5b4fc99f987a2ae8f92ab0ae35c7
Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Tue Apr 5 10:49:04 2011 -0700

    cfg80211: add a timer for invalid user reg hints

    We have no other option but to inform userspace that we
    have queued up their regulatory hint request when we are
    given one given that nl80211 operates atomically on user
    requests. The best we can do is accept the request, and
    add a delayed work item for processing failure and cancel it
    if we succeeed. Upon failure we restore the regulatory
    settings and ignore the user input.

    This fixes this reported bug:

    https://bugzilla.kernel.org/show_bug.cgi?id=28112

    Reported-by: gregoryx.alagnou@intel.com
    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> --
>> shafi
>>
>
>
>
> --
> shafi
>



-- 
shafi
