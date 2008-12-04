Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60026 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbYLDDUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 22:20:54 -0500
Message-ID: <49374C8E.6010500@lwfinger.net> (sfid-20081204_042102_072691_CF0BBC77)
Date: Wed, 03 Dec 2008 21:20:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Improve wireless statistics for RTL8187
References: <27385.37285.qm@web23104.mail.ird.yahoo.com>
In-Reply-To: <27385.37285.qm@web23104.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Thu, 4/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>=20
>> The current wireless statistics for the RTL8187 poorly
>> indicate the signal
>> strength and quality. With testing, I found that the AGC
>> value is inversely
>> correlated with the strength as in the RTL8187B. By
>> implementing a similar
>> calculation, much more code becomes common to the two
>> devices.
>>
>> Signed-off-by: Larry Finger
>> <Larry.Finger@lwfinger.net>
>> Tested by: Mart=EDn Ernesto Barreyro
>> <barreyromartin@gmail.com>
>> ---
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>=20
> Acually eveything to do with "quality" can be moved out of the if/the=
n.
>=20
> I mean these 3 lines:
>=20
> +		if (quality > 100)
> +			quality =3D 100;
> +		....
> +		rx_status.qual =3D quality;
>=20
> You have removed "rx_status.qual =3D quality;" from the "then" part, =
but didn't put it back in the common portion afterwards?
>=20
> Also, what happened to "dev->max_signal =3D 65;" at the end?

Thanks for the comments. I'll fix up the code and resubmit.

The dev->max_signal is only needed if the IEEE80211_HW_SIGNAL_UNSPEC fl=
ag is
used. Once we switch to IEEE80211_HW_SIGNAL_DBM, then the maximum is kn=
own.

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
