Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:40344 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbeHSUk4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Aug 2018 16:40:56 -0400
Received: by mail-oi0-f53.google.com with SMTP id w126-v6so21991571oie.7
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2018 10:28:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD7cUuC6v5y_OH0CnhODk6c-6Fi2C+m0cdA2_0u=7XYA7KmgOA@mail.gmail.com>
References: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
 <20180813084123.GA18180@redhat.com> <87tvnycw2b.fsf@purkki.adurom.net>
 <CAD7cUuD8b_b3riHPTEXROW64HCF8S0F2_XHgikz1J_seq-QxXQ@mail.gmail.com>
 <20180814051448.GA2400@redhat.com> <CAD7cUuC6v5y_OH0CnhODk6c-6Fi2C+m0cdA2_0u=7XYA7KmgOA@mail.gmail.com>
From: =?UTF-8?Q?Grzegorz_Duszy=C5=84ski?= <gfduszynski@gmail.com>
Date: Sun, 19 Aug 2018 19:28:42 +0200
Message-ID: <CAD7cUuC2V50eRE8erOusxgi_XmbSrR39sx4an7RvOehB+jAvzg@mail.gmail.com> (sfid-20180819_192846_777404_AFC18989)
Subject: Re: Cpu stall caused by hostapd running two interfaces
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dmesg for 4.18.1

https://pastebin.com/uPqRvU0F

2018-08-19 18:09 GMT+02:00 Grzegorz Duszy=C5=84ski <gfduszynski@gmail.com>:
> Hi,
>
> I've updated the kernel to 4.18.1 and then followed the instructions
> (I've checked and 0x6e did not changed)
> Here is the gdb output:
>
> (gdb) l *(ieee80211_regulatory_limit_wmm_params+0x6e)
> 0x110e is in ieee80211_regulatory_limit_wmm_params (net/mac80211/util.c:1=
151).
> 1146
> 1147            if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP)
> 1148                    wmm_ac =3D &rrule->wmm_rule->ap[ac];
> 1149            else
> 1150                    wmm_ac =3D &rrule->wmm_rule->client[ac];
> 1151            qparam->cw_min =3D max_t(u16, qparam->cw_min, wmm_ac->cw_=
min);
> 1152            qparam->cw_max =3D max_t(u16, qparam->cw_max, wmm_ac->cw_=
max);
> 1153            qparam->aifs =3D max_t(u8, qparam->aifs, wmm_ac->aifsn);
> 1154            qparam->txop =3D !qparam->txop ? wmm_ac->cot / 32 :
> 1155                    min_t(u16, qparam->txop, wmm_ac->cot / 32);
> (gdb)
>
> 2018-08-14 7:14 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
>> On Mon, Aug 13, 2018 at 08:48:17PM +0200, Grzegorz Duszy=C5=84ski wrote:
>>> Can I help you somehow with this ?
>>
>> Enable CONFIG_DEBUG_INFO=3Dy in .config if not done already.
>> Then do:
>>
>> make net/mac80211/util.o
>> gdb net/mac80211/util.o
>> l *(ieee80211_regulatory_limit_wmm_params+0x6e)
>>
>> and provide output of gdb l command, this should show code
>> line number where oops occurs.
>>
>> Thanks
>> Stanislaw
