Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:11480 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbZBTUIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 15:08:54 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1331986wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 12:08:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c910902201159y1ba18657qdb1517892e6fe352@mail.gmail.com>
References: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
	 <1235109874-3966-2-git-send-email-lrodriguez@atheros.com>
	 <69e28c910902201159y1ba18657qdb1517892e6fe352@mail.gmail.com>
Date: Fri, 20 Feb 2009 12:08:53 -0800
Message-ID: <43e72e890902201208i1ef39d8ey5624a29168c426b8@mail.gmail.com> (sfid-20090220_210924_069008_DC8CED67)
Subject: Re: [PATCH 1/5] cfg80211: enable active-scan / beaconing on Ch 1-11
	for world regdom
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, kalle.valo@nokia.com, kyle@mcmartin.ca,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2009 at 11:59 AM, G=C3=A1bor Stefanik
<netrolller.3d@gmail.com> wrote:
> On Fri, Feb 20, 2009 at 7:04 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> This enables active scan and beaconing on Channels 1 through 11
>> on the static world regulatory domain.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/wireless/reg.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 605299f..8f64575 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -76,9 +76,8 @@ static const struct ieee80211_regdomain world_regd=
om =3D {
>>        .n_reg_rules =3D 1,
>>        .alpha2 =3D  "00",
>>        .reg_rules =3D {
>> -               REG_RULE(2412-10, 2462+10, 40, 6, 20,
>> -                       NL80211_RRF_PASSIVE_SCAN |
>> -                       NL80211_RRF_NO_IBSS),
>> +               /* IEEE 802.11b/g, channels 1..11 */
>> +               REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
>>        }
>>  };
>>
>> --
>> 1.6.0.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wire=
less" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Are you sure there is no area of the world where the allowed range is
> stricter than b/g 1-11?
> Otherwise I am inclined to NACK this.

That is the value of our world regulatory domain in wireless-regdb and
that itself is the product of the intersection of all currently known
regulatory domains, so yes, hence the patch.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
