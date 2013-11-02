Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38923 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3KBUGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 16:06:00 -0400
Received: by mail-wi0-f173.google.com with SMTP id ey11so2343097wid.6
        for <linux-wireless@vger.kernel.org>; Sat, 02 Nov 2013 13:05:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLDHP5gyeTL8HR=6uJDLptaUGEnNGSFLMkxKqi-JaBVYQ@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <526E20EA.9090203@rempel-privat.de> <CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
 <CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
 <CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
 <CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com>
 <CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
 <CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com>
 <CAMP44s3uRF=jNn5ZHZ=QOcvuMoXxsfkxU=VOq3K02Q0qOspEdA@mail.gmail.com>
 <CABPxzYJbNjAwymwUq0pN=YyuCBGy2qz_BKafatHTWK+yH8PbkA@mail.gmail.com>
 <CAMP44s1NOS2p9pKeMLhR7616CzHeHJVJEzcF1tP6tsKfcPhSOQ@mail.gmail.com>
 <CABPxzY+RL+ikbSff3a7qb20ExxcSTx6U2xcL5CFr-BgVSOr61A@mail.gmail.com>
 <CAMP44s384vOcMc4vE82gAdVf37YUZfegmPHUSeobPO=gK6ErAw@mail.gmail.com> <CABPxzYLDHP5gyeTL8HR=6uJDLptaUGEnNGSFLMkxKqi-JaBVYQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 3 Nov 2013 01:35:39 +0530
Message-ID: <CABPxzYJTuV0vGLnhgcQcXbg_9szSm2hH7_vCeP4TOKNxZQx_Gg@mail.gmail.com> (sfid-20131102_210619_771482_0ACBEB34)
Subject: Re: I always need a miracle to connect with iwlwifi
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 3, 2013 at 12:43 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Sat, Nov 2, 2013 at 10:36 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> Sorry for the crappy format (laptop is stuck).
>>
>> If the problem is the firmware why does it start working when I
>> restart the router?
>
> I was referring FW on iwlwifi, not the AP's. May be restarting the router
> triggered some kind of event like Beacon Loss which might have
> helped the STA to connect. Just guessing.
>
>> Plus, I should be seeing this problem with other APs.
>> And what could Windows be doing differently that doesn't exhibit this problem?
>
> Without knowing the root cause it tough to comment these questions :-)

Almost forgot, as mentioned previously if we can figure out why all the
beacons are corrupted (but probes are fine) then that might throw us some
light.

Its messed up in the Extended supported rates and Length of  OBSS Scan
params. Other stations might not have a problem but linux might have it.

Can you also capture the beacons using some other wireless card
just to make sure corruption is not happening on the AP side?

Failure Case:

As we can see in the Link#1, in the first case we haven't received a beacon
so association didn't went through (need_beacon =1)

Successful Case:

but after associating with IBSS and disconnecting we started Rx beacons
 (even though they are corrupted) the connection went through.
(need_beacon =0 and have_beacon=1)

The problems appears to be with reception of the beacons which in turn
 might depend on the corruption issue.

If they are no beacons Rx after auth and before assoc we return with
association timeout.

    if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started &&
        time_after(jiffies, ifmgd->assoc_data->timeout)) {
        if ((ifmgd->assoc_data->need_beacon &&
             !ifmgd->assoc_data->have_beacon) ||
            ieee80211_do_assoc(sdata)) {
            u8 bssid[ETH_ALEN];

            memcpy(bssid, ifmgd->assoc_data->bss->bssid, ETH_ALEN);

            ieee80211_destroy_assoc_data(sdata, false);

            mutex_unlock(&ifmgd->mtx);
            cfg80211_send_assoc_timeout(sdata->dev, bssid);
            mutex_lock(&ifmgd->mtx);
        }
    }


Also one more thing you said N900 uses mac80211 and it has no issues, but as
its a embedded device it might running an older kernel where the
handling might be
different, so we need to try with the same kernel you are facing an
issue with the
a driver which advertises IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC.

(or) if you a have a compilation environment try commenting the advertisement of
IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC in the iwlwifi DVM driver and
try to reproduce the issue.

Lets see what results you get :-).
