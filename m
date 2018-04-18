Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40579 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752632AbeDROz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 10:55:57 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Bernhard Gabler <Bernhard_Gabler@web.de>,
        Linux-Wireless mailing list <linux-wireless@vger.kernel.org>
Subject: Re: ath confusing log message "country IE"
In-Reply-To: <660b1538-0ccb-8f1a-ebe0-632b0e14a46b@web.de>
References: <660b1538-0ccb-8f1a-ebe0-632b0e14a46b@web.de>
Date: Wed, 18 Apr 2018 16:55:55 +0200
Message-ID: <87o9ig1s3o.fsf@toke.dk> (sfid-20180418_165601_687010_B40C35D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bernhard Gabler <Bernhard_Gabler@web.de> writes:

> Dear all,
>
> would it be possible to re-write the log message from
>  =C2=A0=C2=A0 "regdomain ... dynamically updated by country IE"
> in a less ambiguous way, e.g. to:
>  =C2=A0=C2=A0 "regdomain ... dynamically updated by country-IE"
>  =C2=A0=C2=A0 "regdomain ... dynamically updated by country information e=
lement"
> , please?
>
> To the occasional reader, the following system log messages seem to=20
> convey that
>  =C2=A0-=C2=A0 "DE" (Germany) was intended to be used, but
>  =C2=A0-=C2=A0 "IE" (Ireland) was configured as regdomain.
>
>  =C2=A0=C2=A0=C2=A0 [ 2723.739071] ath: EEPROM regdomain: 0x8114
>  =C2=A0=C2=A0=C2=A0 [ 2723.739072] ath: EEPROM indicates we should expect=
 a country code
>  =C2=A0=C2=A0=C2=A0 [ 2723.739073] ath: doing EEPROM country->regdmn map =
search
>  =C2=A0=C2=A0=C2=A0 [ 2723.739074] ath: country maps to regdmn code: 0x37
>  =C2=A0=C2=A0=C2=A0 [ 2723.739075] ath: Country alpha2 being used: DE
>  =C2=A0=C2=A0=C2=A0 [ 2723.739076] ath: Regpair used: 0x37
>  =C2=A0=C2=A0=C2=A0 [ 2723.739077] ath: regdomain 0x8114 dynamically upda=
ted by country IE
>
> Only after intense googling, I now know that IE stands for "information=20
> element", not for Ireland. But this is not obvious at. To prevent others=
=20
> from confusion and wasting time on a non-problem, could please someone=20
> rewrite the log message?

Heh, that is a good point, I think. The patch below should fix it; but I
worry that the log lines become quite long, then? Maybe better to use
"country-IE", but that could also be confused. "country inf.elem"
perhaps?

Ah, the bike-shedding possibilities are endless! :)

-Toke


diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7b42f0bacfd8..7f432734dbe9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1464,7 +1464,7 @@ const char *reg_initiator_name(enum nl80211_reg_initi=
ator initiator)
        case NL80211_REGDOM_SET_BY_DRIVER:
                return "driver";
        case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-               return "country IE";
+               return "country information element";
        default:
                WARN_ON(1);
                return "bug";
