Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47910 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3LPPxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:53:38 -0500
Received: by mail-ie0-f181.google.com with SMTP id e14so6314670iej.26
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 07:53:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52AF1E57.2040300@rempel-privat.de>
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
	<1387197416.4665.15.camel@jlt4.sipsolutions.net>
	<CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>
	<1387201528.2057.1.camel@jlt4.sipsolutions.net>
	<CANq1E4TJWCgM4yCFC25b3ssQEvFv+hEhW6jP3_mQKxQCw-QtUQ@mail.gmail.com>
	<52AF14EC.9010803@rempel-privat.de>
	<CANq1E4S+u6UZf15fU9aO6JvY4OTE+RnOKGL0K16T9A_4vr+C6A@mail.gmail.com>
	<1387206912.2057.25.camel@jlt4.sipsolutions.net>
	<52AF1BBE.5020602@rempel-privat.de>
	<1387207795.2057.29.camel@jlt4.sipsolutions.net>
	<52AF1E57.2040300@rempel-privat.de>
Date: Mon, 16 Dec 2013 16:53:37 +0100
Message-ID: <CANq1E4Q_+FwGjZr7yKudc=RYQPmJW9oUFUoTgg0U8vn5us3Bww@mail.gmail.com> (sfid-20131216_165341_617921_6FBCE31A)
Subject: Re: [BUG] P2P setup timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Dec 16, 2013 at 4:37 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 16.12.2013 16:29, schrieb Johannes Berg:
>> On Mon, 2013-12-16 at 16:26 +0100, Oleksij Rempel wrote:
>>> Am 16.12.2013 16:15, schrieb Johannes Berg:
>>>> On Mon, 2013-12-16 at 16:09 +0100, David Herrmann wrote:
>>>>
>>>>> Thanks, I tracked down the ENETDOWN. I'm not entirely sure but I think it's:
>>>>
>>>> Obviously :)
>>>>
>>>>> @Oleksij, I actually have three ath9k-htc devices so I'd like to get
>>>>> this working, and the devices are really nice apart from this bug. I
>>>>> will keep you up to date, but if you have any hints where to continue
>>>>> digging, lemme know. Until it's fixed, I'll just work on
>>>>> wired-displays via ethernet instead of wifi-displays..
>>>>
>>>> Based on what Oleksij said, these issues are likely not even related -
>>>> maybe ath9k_htc can't even set the rates to exclude CCK, so even if that
>>>> call were to succeed it wouldn't work?
>>>
>>> Hmm.. WMI_BITRATE_MASK should do it.
>>> ieee80211_ops->set_bitrate_mask is set, so theoretically we should be
>>> able to exclude CCK. Today i won't be able to check it.
>>
>> There are two things:
>>  * the issue at hand, which is only for some certain management frames
>> that I
>>    believe are sent over the normal wlan0 netdev/vif, but still must not
>> use CCK
>>    even though wlan0 allows CCK
>>  * the issue about the set tx-rate on the p2p netdev/vif, which is how I
>> noticed
>>    this, but which is actually not related to the current bug
>>
>> It sounds to me like only the latter can be solved with WMI_BITRATE_MASK
>> since you can't generally disable CCK on wlan0 when doing P2P (you might
>> be connected to an 11b AP at the same time)
>>
>> For the latter issue, you really need a per-frame "disable CCK" flag in
>> the firmware, or you need to use a P2P_DEVICE vif.
>
> Ah.. there is comment which clarify the situation with
> ieee80211_ops->set_bitrate_mask in ath9k_htc:
> /*
>  * Currently, this is used only for selecting the minimum rate
>  * for management frames, rate selection for data frames remain
>  * unaffected.
>  */

Yeah, I read that, but couldn't really understand it's meaning.. So it
seems unless we add fw-support to ignore CCK rates for p2p mgmt
frames, I'm screwed? Wouldn't it work to set >11mbits as lowest rate
which should exclude CCK, right? I'm fine with breaking other stuff if
I can get this running for a test environment. Or would it help trying
p2p on 5ghz? Not sure which rates are used there, though..

I will try to look into the ath9k-htc firmware. But given the
complexity, I guess I won't be able to do that in <1month. And my
80211 knowledge is not that comprehensive.. Maybe I'll find time for
it during my next semester.

Thanks!
David
