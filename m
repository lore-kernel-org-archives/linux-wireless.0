Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:53537 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764369AbYFFP6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 11:58:00 -0400
Message-ID: <48495E85.9050608@mandriva.org> (sfid-20080606_175826_724213_7B1944A0)
Date: Fri, 06 Jun 2008 18:57:57 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Tomas Winkler <tomasw@gmail.com>, Ian Schram <ischram@telenet.be>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
References: <4848289D.1080205@mandriva.org> <48482BC3.4070402@mandriva.org>	 <4848482C.2080208@mandriva.org> <48485F12.2050908@mandriva.org>	 <48488878.5040708@telenet.be>	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>	 <48494EF6.4020506@mandriva.org>	 <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com> <1212765720.28631.19.camel@localhost.localdomain>
In-Reply-To: <1212765720.28631.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams skrev:
> On Fri, 2008-06-06 at 18:12 +0300, Tomas Winkler wrote:
>> On Fri, Jun 6, 2008 at 5:51 PM, Thomas Backlund <tmb@mandriva.org> w=
rote:
>>> Tomas Winkler skrev:
>>>> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org>=
 wrote:
>>>>> Thomas Backlund skrev:
>>>>>> Tomas Winkler skrev:
>>>>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be>=
 wrote:
>>>>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
>>>>>>>>
>>>>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
>>>>>>>>
>>>>>>>> invalid length of webkey that would/should be handled in mac80=
211?
>>>>>>>>
>>>>>>>> ian
>>>>>>> Yes, it looks like.
>>>>>> Ummm, what has a wep key to do with me trying to access a WPA2-P=
ersonal
>>>>>> encrypted net ?
>>>> Not sure yet, but mac is trying to assign default/static wep key.
>>>>
>>>> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
>>>> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
>>>>
>>>> Try to set the encryption explicitly
>>>> network=3D{
>>>>    psk=3D"*************************"
>>>>    scan_ssid=3D1
>>>>    ssid=3D"dlink"
>>>>    pairwise=3DCCMP
>>>>   group=3DCCMP
>>>>  }
>>>>
>>>>
>>> That didn't help at all...
>>>
>>> What's more it prevented the wifi to work on 2.6.24.7 so I had to r=
emove the
>>> lines again...
>>>
>> So what's your AP configuration TKIP?
>=20
> Yeah, the supplicant log he posted clearly shows that the GTK is TKIP=
=2E
>=20
> =EF=BB=BF> 1212763152.516781: wpa_driver_wext_set_key: alg=3D2 key_id=
x=3D1 set_tx=3D0 seq_len=3D6 key_len=3D32
>> 1212763152.516790: WPA: Key negotiation completed with 00:xx:xx:xx:x=
x:xx [PTK=3DCCMP GTK=3DTKIP]
>=20

The AP is actually set for TKIP+AES

BTW, is that better or worse than a clean AES ?
I'm reading up on it, but I get a lot of conflicting info...

> Dan
>=20
>> Second try also with sw decryption:
>>
>> in /etc/modprobe.conf
>> options iwl4965 swcrypto=3D1
>>
>>
>> Tomas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wire=
less" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Thomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
