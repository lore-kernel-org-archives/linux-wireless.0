Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42896 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3KHNOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 08:14:34 -0500
Received: by mail-lb0-f174.google.com with SMTP id q8so1427164lbi.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 05:14:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMP44s3VRnqw0XJDZTZTym7wBD5-NnfOD56YHbE87OG=3Zan2w@mail.gmail.com>
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
Date: Fri, 8 Nov 2013 07:14:32 -0600
Message-ID: <CAMP44s15W7gb8rXwqum5bdHOSk=A_sadX7ksvtkG0qTOu1RREg@mail.gmail.com> (sfid-20131108_141437_787457_A4038C3D)
Subject: Re: I always need a miracle to connect with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 8, 2013 at 2:35 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Sat, Nov 2, 2013 at 2:05 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>
>> Also one more thing you said N900 uses mac80211 and it has no issues, but as
>> its a embedded device it might running an older kernel where the
>> handling might be
>> different, so we need to try with the same kernel you are facing an
>> issue with the
>> a driver which advertises IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC.
>
> Yes it was running an older kernel, but I just compiled v3.12 and ran
> it on the N900, and still everything works fine.
>
>> (or) if you a have a compilation environment try commenting the advertisement of
>> IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC in the iwlwifi DVM driver and
>> try to reproduce the issue.
>
> After commenting that flag everything works fine :)
>
> What are the next steps?

I tried to add some debugging to see what's going on, and indeed the
beacon packets are lost, I added debugging as low in the chain as I
could (iwlagn_rx_reply_rx()), and I don't see them there. However,
when I enable the monitor mode, I see them. What's going on?

-- 
Felipe Contreras
