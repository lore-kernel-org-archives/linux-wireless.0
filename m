Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55312 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3KIQwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Nov 2013 11:52:20 -0500
Received: by mail-lb0-f174.google.com with SMTP id p9so357836lbv.33
        for <linux-wireless@vger.kernel.org>; Sat, 09 Nov 2013 08:52:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYKPpL7p0gexV3udgsWYZ_zVYxT6vrz-n-rN36D2AgBCgg@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
	<526E20EA.9090203@rempel-privat.de>
	<CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
	<CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
	<CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
	<CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
	<CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
	<CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com>
	<CAMP44s3uRF=jNn5ZHZ=QOcvuMoXxsfkxU=VOq3K02Q0qOspEdA@mail.gmail.com>
	<CABPxzYJbNjAwymwUq0pN=YyuCBGy2qz_BKafatHTWK+yH8PbkA@mail.gmail.com>
	<CAMP44s1NOS2p9pKeMLhR7616CzHeHJVJEzcF1tP6tsKfcPhSOQ@mail.gmail.com>
	<CABPxzY+RL+ikbSff3a7qb20ExxcSTx6U2xcL5CFr-BgVSOr61A@mail.gmail.com>
	<CAMP44s384vOcMc4vE82gAdVf37YUZfegmPHUSeobPO=gK6ErAw@mail.gmail.com>
	<CABPxzYLDHP5gyeTL8HR=6uJDLptaUGEnNGSFLMkxKqi-JaBVYQ@mail.gmail.com>
	<CABPxzYJTuV0vGLnhgcQcXbg_9szSm2hH7_vCeP4TOKNxZQx_Gg@mail.gmail.com>
	<CAMP44s3VRnqw0XJDZTZTym7wBD5-NnfOD56YHbE87OG=3Zan2w@mail.gmail.com>
	<CAMP44s15W7gb8rXwqum5bdHOSk=A_sadX7ksvtkG0qTOu1RREg@mail.gmail.com>
	<CABPxzYLtbs1s-_T+hk+N1hOEuCi_Yq+CGxG7Xx0hPRmiyQM0Jg@mail.gmail.com>
	<CAMP44s0h836BZ+g9-g_t78bKuV_m_xAuvPYRCHaFdJ58eTKthw@mail.gmail.com>
	<CABPxzYJsLqJbJQzr8+2GujQsbJpo922v9ouVWWPbTFL11-UV5g@mail.gmail.com>
	<CAMP44s1ZtTyfKmgy4174ukQU1dwx1Fw=AngNQ=g2Dv2wm4t2-g@mail.gmail.com>
	<CABPxzYKPpL7p0gexV3udgsWYZ_zVYxT6vrz-n-rN36D2AgBCgg@mail.gmail.com>
Date: Sat, 9 Nov 2013 10:52:18 -0600
Message-ID: <CAMP44s1vwEMRYost99JgLxvXJkFwhgnn9jnYR5RxLPDm-Qj7ug@mail.gmail.com> (sfid-20131109_175237_523508_2C650CA3)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 9, 2013 at 7:10 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Sat, Nov 9, 2013 at 2:22 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Fri, Nov 8, 2013 at 2:30 PM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:

>>>> But we are receiving 0 beacons, waiting for more than 1 won't help.
>>>> BTW, why NEED_DTIM_BEFORE_ASSOC if the device doesn't *need* the DTIM
>>>> before the association?
>>>>
> This is not just for your case but rather on a generic note. Regarding
> the flag even i am not
> too sure but i guess some hardware need to know the DTIM to set the
> wakeup schedule
> after the association?

But not this hardware? Because everything works fine.

>>> Oops...you just missed, Right after your print there is a check to
>>> drop frames with BAD CRC :-).
>>
>> That's why I put the print before that check. Since I don't see the
>> print, that means the check was never executed. iwlagn_rx_reply_rx()
>> was never called for the beacon frame.
>>
> Ok. So when we disable advertising of that flag in the driver you said things
> are working fine.

Yes, everything works perfectly.

> So in that scenario after the connection are you
> seeing the beacons?

No, there are no beacons ever, at least from this AP.

It seems to me all the beacon frames are dropped by the firmware
before passing them to the driver, so the driver cannot parse them and
do something sensible even though they are corrupted, the driver never
gets them.

> Just want to understand the problem is throughout or just before association.
> If the driver itself it not getting the beacons then our debugging ends there,
> some one from intel should guide you through the FW debugging.

Not really, part of the debugging ends there, but we can still do something.

What is the meaning of NEED_DTIM_BEFORE_ASSOC, if the driver doesn't
*need* this? Why fail the association completely, if we don't need to?

Also, I realized that after rebooting the router, the beacon frames
are not corrupted any more, so it's a compound problem, yet even in
the corrupted case, the driver can work just fine, if only it didn't
*require* the DTIM unnecessarily, as apparently all hardware and even
other OS'es on this hardware do.

Cheers.

-- 
Felipe Contreras
