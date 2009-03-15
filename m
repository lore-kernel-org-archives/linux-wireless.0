Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f164.google.com ([209.85.219.164]:57692 "EHLO
	mail-ew0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZCOUoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 16:44:18 -0400
Received: by ewy8 with SMTP id 8so1598320ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2009 13:44:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BD65D2.1040608@gmail.com>
References: <20090315201704.GB5246@makis> <49BD65D2.1040608@gmail.com>
Date: Sun, 15 Mar 2009 22:44:15 +0200
Message-ID: <40f31dec0903151344x5a7ddfacwd5c267a7609ff9f5@mail.gmail.com> (sfid-20090315_214422_139520_CB9336E5)
Subject: Re: [PATCH 2/3] ath5k: Convert chip specific calibration data to a
	generic format
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/15 Jiri Slaby <jirislaby@gmail.com>:
> On 15.3.2009 21:17, Nick Kossifidis wrote:
>>
>> +ath5k_get_pcdac_intercepts(struct ath5k_hw *ah, u8 min, u8 max, u8 =
*vp)
>> +{
>> + =C2=A0 =C2=A0 =C2=A0 const static u16 intercepts3[] =3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 { 0, 5, 10, 20, 3=
0, 50, 70, 85, 90, 95, 100 };
>> + =C2=A0 =C2=A0 =C2=A0 const static u16 intercepts3_2[] =3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 { 0, 10, 20, 30, =
40, 50, 60, 70, 80, 90, 100 };
>
> Just for future, C99 section 6.11.5 says:
> Storage-class specifiers
> =C2=A0The placement of a storage-class specifier other than at the
> =C2=A0beginning of the declaration specifiers in a declaration is
> =C2=A0an obsolescent feature.
>
> It means we should use 'static const' instead of 'const static'.
>

ACK i think we should do a cleanup patch and deal with such issues all
over ath5k

> Otherwise it looks good, thanks.

Do you want me to resend or is it ok by you ?




--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
