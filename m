Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51982 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3ANMuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 07:50:06 -0500
Received: by mail-wi0-f179.google.com with SMTP id o1so1211712wic.12
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2013 04:50:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXBNSRTK+zjaxg5eD-zDv6OE_S_iU7Gb3v5W=M_92qdrg@mail.gmail.com>
References: <CAMvjH0A69ZBCZc5qjm_cUYj3bDzSmneaz1u9CsPcJEm2T0Q1iw@mail.gmail.com>
	<87txqkz0yk.fsf@purkki.adurom.net>
	<CAMvjH0BkRS0HpjqHQyFOmnqmQs4AR9HGWh07FSz2yh3TiTBy6w@mail.gmail.com>
	<CAGRGNgXBNSRTK+zjaxg5eD-zDv6OE_S_iU7Gb3v5W=M_92qdrg@mail.gmail.com>
Date: Mon, 14 Jan 2013 14:50:04 +0200
Message-ID: <CAMvjH0CG3fL-o=HkSeDkXE7KoVo-UEahkYRGqPok-Gpw09YaUw@mail.gmail.com> (sfid-20130114_135011_826786_310EA63D)
Subject: Re: Custom commands for cfg80211 based driver (like iwpriv)
From: Eugene <wifi.mailing.list@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/1/14 Julian Calaby <julian.calaby@gmail.com>:
> Hi Eugene,
>
> On Mon, Jan 14, 2013 at 9:01 PM, Eugene <wifi.mailing.list@gmail.com> wrote:
>> 2013/1/14 Kalle Valo <kvalo@adurom.com>:
>>> Eugene <wifi.mailing.list@gmail.com> writes:
>>>
>>>> How to add custom configuration command for cfg80211 based driver.
>>>>
>>>> For WEXT was private IOCtls (iwpriv).
>>>>
>>>> What the recommended way for nl80211/cfg80211?
>>>
>>> Luckily private commands are now banned, it was such a mess. Now you add
>>> a new generic command to nl80211/cfg80211 so that all drivers can use
>>> it. The benefit is that the driver can be changed without any
>>> modifications to user space.
>>
>> That's really good benefit.
>> But as a disadvantage for that approach required changes for kernel,
>> which cannot be done real-time (insmod for example).
>
> How so? If you have some new mode or feature, you implement support
> for it in cfg80211 and (if needed) mac80211, tell userspace about it
> through nl80211, build a driver that indicates that it has support for
> this feature, then add or patch user-space utilities to make use of
> it.

Sure, at any time I can patch the framework {nl,cfg}80211.
But that is useful for feature, which can be reused by other drivers.
And for sure I'll go by that way if so.

>
>>> Only exceptions are NL80211_CMD_TESTMODE for low level factory/RF tests
>>> and debugfs for developer debugging purposes.
>>>
>>
>> Hmm...
>> That's good point for testing, but still unusable for production.
>
> debugfs is for exposing internal state which would be useful for
> debugging, e.g. register values, low level statistics, etc.
>
>> Why kernel do not support custom commands, like TESTMODE?
>
> The goal, as I understand it, is to work out a framework for how
> TESTMODE could be implemented in a unified manner across all the
> drivers for all hardware which supports it. I'm not sure that any real
> progress has been made.
>
>> The reason is to unify all drivers?
>
> Precisely. User space shouldn't have to do anything "special" for any
> particular driver.
>
> I should be able to swap from an Atheros card to an Intel card and,
> providing the Intel card supports the features I'm using, userspace
> should continue on without any significant configuration changes.
>

That is explain a lot.

>> But what about new (or proprietary) features, use kernel patches only?
>
> New features should be written into the wireless stack as I described above.
>
> Proprietary features ... well that's a tricky one. Unless there's a
> real compelling reason to do so, they're most likely going to be
> ignored unless other chipsets implement compatible features and a
> unified interface for utilising them can be figured out.
>
> Exactly what features are you wanting to implement?

Can be a lot... like custom bridging.
Of course each of them should be individually investigated.

But currently my question is common.
And I think, that I got all the answers.

Thanks to everybody.

>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
