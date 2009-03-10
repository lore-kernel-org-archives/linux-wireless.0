Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:35875 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbZCJRdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 13:33:31 -0400
Received: by ey-out-2122.google.com with SMTP id 25so429326eya.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 10:33:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49B66170.5000103@gmail.com>
References: <20090310103735.GD3341@makis> <49B66170.5000103@gmail.com>
Date: Tue, 10 Mar 2009 19:33:28 +0200
Message-ID: <40f31dec0903101033m42a889feq1a7361289adc4b4d@mail.gmail.com> (sfid-20090310_183335_096561_5CE53A5D)
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/10 Jiri Slaby <jirislaby@gmail.com>:
> On 10.3.2009 11:37, Nick Kossifidis wrote:
>>
>> =C2=A0* Add tx power calibration support
>> =C2=A0* Add a few tx power limits
>> =C2=A0* Hardcode default power to 12.5dB
>> =C2=A0* Disable TPC for now
>
> ...
>>
>> diff --git a/drivers/net/wireless/ath5k/base.c
>> b/drivers/net/wireless/ath5k/base.c
>> index f7c424d..d9f483b 100644
>> --- a/drivers/net/wireless/ath5k/base.c
>> +++ b/drivers/net/wireless/ath5k/base.c
>> @@ -521,6 +521,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
IEEE80211_HW_NOISE_DBM;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0hw->wiphy->interface_modes =3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BIT(NL80211_IFTYP=
E_AP)|
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BIT(NL80211_I=
=46TYPE_STATION) |
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BIT(NL80211_I=
=46TYPE_ADHOC) |
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BIT(NL80211_I=
=46TYPE_MESH_POINT);
>
> Is this a typo or wrongly amended commit :)?

I wanted to do some basic testing for this on a spectrum analyzer so i
had to switch it to AP mode and watch the beacons coming out, of
course i forgot to remove it :P

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
