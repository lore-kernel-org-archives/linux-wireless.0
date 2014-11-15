Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65418 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaKOBAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 20:00:35 -0500
Received: by mail-ie0-f174.google.com with SMTP id x19so19031738ier.33
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2014 17:00:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87389lstst.fsf@kamboji.qca.qualcomm.com>
References: <20140910152136.12610.18499.stgit@potku.adurom.net>
	<87zje528im.fsf@kamboji.qca.qualcomm.com>
	<CAD1M061Gky-a28Rokmgyd-5x_m_h1SNmj9ZxUd4v1fP=bae35g@mail.gmail.com>
	<87389lstst.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 14 Nov 2014 17:00:34 -0800
Message-ID: <CAJ+vNU2WopFqRVNQse96mKYkESsL=5_zjRa9rMfmEYinQBU26w@mail.gmail.com> (sfid-20141115_020116_423334_865AD2D8)
Subject: Re: [PATCH v4 0/2] ath10k: testmode support
From: Tim Harvey <tharvey@gateworks.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Pushpal Sidhu <psidhu@gateworks.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2014 at 7:09 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Pushpal Sidhu <psidhu@gateworks.com> writes:
>
>> On Thu, Sep 11, 2014 at 1:43 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>>
>>>> latest version of my testmode patches. Getting closer, more or less cosmetic
>>>> changes this time :)
>>
>> While looking through this patchset (sorry it took two months), I have
>> to wonder: what's this utf.bin blob? It seems in order to use
>> testmode, we need this binary blob that I can't seem to find (I looked
>> in linux-firmware and https://github.com/kvalo/ath10k-firmware). If,
>> for whatever reason, this binary blob is not releasable, what's the
>> point of adding in testmode to this driver?
>
> testmode is for functionality needed in the factory, it's not meant for
> normal users. That's why all distros should have CONFIG_NL80211_TESTMODE
> disabled.

Kalle,

So what your saying is that 'the factory' (Quallcomm I assume) is
using the ath10k driver with some firmware it deems not publicly
releasable and the rest of us are paying for the extra lines of code
and thrash in the open source driver? This sounds kind of dirty. It
seems to me that QCA should either release the firmware or we should
remove any special handling in the driver for it.

Is this practice used in other Linux wireless drivers? I've cc'd John
to see if he has any comments on that.

Personally, I would rather see QCA document and release the uts
firmware which is likely useful for others rather than removing the
support for it. We have users often as for a continuous transmit mode
switch so that they can get through certification testing. But really,
deep down I would much rather QCA simply open up the firmware so that
developers that are trying really hard to make this a quality driver
can succeed and we can all benefit.

Tim

>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
