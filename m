Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:43106 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbYLOUB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 15:01:26 -0500
Message-ID: <4946B78F.30006@lwfinger.net> (sfid-20081215_210130_394358_1BCFA053)
Date: Mon, 15 Dec 2008 14:01:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Improve wireless statistics for RTL8187
References: <27385.37285.qm@web23104.mail.ird.yahoo.com> <49374C8E.6010500@lwfinger.net> <20081215193549.GD3519@tuxdriver.com>
In-Reply-To: <20081215193549.GD3519@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Dec 03, 2008 at 09:20:46PM -0600, Larry Finger wrote:
>> Hin-Tak Leung wrote:
>>> --- On Thu, 4/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote=
:
>>>
>>>> The current wireless statistics for the RTL8187 poorly
>>>> indicate the signal
>>>> strength and quality. With testing, I found that the AGC
>>>> value is inversely
>>>> correlated with the strength as in the RTL8187B. By
>>>> implementing a similar
>>>> calculation, much more code becomes common to the two
>>>> devices.
>>>>
>>>> Signed-off-by: Larry Finger
>>>> <Larry.Finger@lwfinger.net>
>>>> Tested by: Mart=EDn Ernesto Barreyro
>>>> <barreyromartin@gmail.com>
>>>> ---
>>> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>>>
>>> Acually eveything to do with "quality" can be moved out of the if/t=
hen.
>>>
>>> I mean these 3 lines:
>>>
>>> +		if (quality > 100)
>>> +			quality =3D 100;
>>> +		....
>>> +		rx_status.qual =3D quality;
>>>
>>> You have removed "rx_status.qual =3D quality;" from the "then" part=
, but didn't put it back in the common portion afterwards?
>>>
>>> Also, what happened to "dev->max_signal =3D 65;" at the end?
>> Thanks for the comments. I'll fix up the code and resubmit.
>>
>> The dev->max_signal is only needed if the IEEE80211_HW_SIGNAL_UNSPEC=
 flag is
>> used. Once we switch to IEEE80211_HW_SIGNAL_DBM, then the maximum is=
 known.
>=20
> I'm dropping this patch from my mailbox.  Is a new version of this
> still coming?

It is already in wireless-testing as commit b95e4bc3da1167bba718bc5. It=
 was sent
to you as "[PATCH V2] rtl8187: Improve wireless statistics for RTL8187"=
 on Dec
3. The original should be dropped.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
