Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D43C28CF8
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 01:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CF2820835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 01:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CF2820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbeJLJEd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 05:04:33 -0400
Received: from mout.gmx.net ([212.227.17.20]:47129 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbeJLJEd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 05:04:33 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MLzXM-1g33eG49jo-007o56; Fri, 12
 Oct 2018 03:34:34 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MLzXM-1g33eG49jo-007o56; Fri, 12
 Oct 2018 03:34:34 +0200
Subject: Re: Intel 8265 unstable/asymmetric ping response time (only under
 Linux)
To:     =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <edaca500-8ae2-aef4-1c9d-b754af7e899f@gmx.com>
 <CABvG-CUJNAq=4XWf3bVYw_EF4W8zmmL7fvc=nt+Zae82Wn7yug@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <ca5a768b-3d81-6bc3-dc28-b0b737e1a7cb@gmx.com>
Date:   Fri, 12 Oct 2018 09:34:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CABvG-CUJNAq=4XWf3bVYw_EF4W8zmmL7fvc=nt+Zae82Wn7yug@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1XGZjXOCWyPeVVJey2u1KTTzz0RCrOPhM"
X-Provags-ID: V03:K1:j5gdQKZGsWg0A3646yH6ISpqWfxIuUQlF/4KWLo6u5dPui1IRUO
 tBUt53hUvmcy56foAixyuJqrUiD38bS3DdB9/Gp24wSxm6Uhy9VQxwYYBYUpSzEtXBmO+R/
 vhBgBc31lq3fphWzdPMIInYYMz17/6iOnj8y27TnQ9u0/rGgHBI+ae2jNc2gxohHWdHm+RZ
 KfXzYh8MNcTI62TvLii8Q==
X-UI-Out-Filterresults: notjunk:1;V01:K0:cV12giIdXmo=:FOnFeV1CHhAOv2/FzJUzcE
 GonNnjn1deQ8HPw3PGIPVltfk4/V5rrLIn1PV3cpCNWbhR2C2BiTXjUQSaz3jWcYaBZ5M0TOU
 ZB+bnqY+3le6GMV5wECJWxKgQYZtG2RRmLWT0W6IKp+vsJFBnRHXwqXIp246vDqeL7zigx2jz
 k4ItR4LGcwrFbbk2+a+JiZpeB0gLd2OvL6nthhVJW8OXMT44Y5ayolgIcM5ZHB6gBEUiPelyO
 pnh9meTGC/GFKvoG++/mLyN8VfMZGXv2qk+hsdi1KOkMYos7wmOgNmbKWIb96vAurgxvt05vs
 mVXE/rJm1qjvHVemGeCx8C02wA93soXNV2NgQkBvX6fBWICrt1tRjHaLvASgCMX9tkoNFAxCn
 RSGpRzVMCl1WOIIP1EZPLPbe6pRKZdEdEQFEmE7b5JG+NLb7hpeAIUeAedOi+/HXVa9ZzoT4U
 lA5qHQgii0TLwCQO1VIr4ii/bqdZv4fG6M2I5xkdYhILSaIexCeSp2wuwA8k6BtaSPkvbsmaY
 YVWAN7V8StFawdjvsoJj+uRXtodAO068g/oEjPWjk1ZkSvFFTyZ6pPv6LfZzP4XcCRsFi85Ww
 WDQoMxtUM+Zgs8V/U/qQiGDfp9bA535HJfMo5FGixa8la+4U3JU+tbg3cBtHBxnqINNt3RiqM
 Bq7fSrvVlQhfnK8xG55YFz+sI7FEku6cpt484pWCC5Hp2CXA9MD13JSmJGyiB+8MAQ63KX0GR
 cZkgyrRbB3/d6EpnmVecPobtV+AO09/QviUT+KHdbo6khHWFJw8iYMpFBrUrxI05NqTlspOs0
 LFQM+Kp7oBsLGyFgIGkh0JbsxQuKQ==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1XGZjXOCWyPeVVJey2u1KTTzz0RCrOPhM
Content-Type: multipart/mixed; boundary="aDlUQQ03cJvMHvk3YoRYwSgYbxMjeETQL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <ca5a768b-3d81-6bc3-dc28-b0b737e1a7cb@gmx.com>
Subject: Re: Intel 8265 unstable/asymmetric ping response time (only under
 Linux)
References: <edaca500-8ae2-aef4-1c9d-b754af7e899f@gmx.com>
 <CABvG-CUJNAq=4XWf3bVYw_EF4W8zmmL7fvc=nt+Zae82Wn7yug@mail.gmail.com>
In-Reply-To: <CABvG-CUJNAq=4XWf3bVYw_EF4W8zmmL7fvc=nt+Zae82Wn7yug@mail.gmail.com>

--aDlUQQ03cJvMHvk3YoRYwSgYbxMjeETQL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/12 =E4=B8=8A=E5=8D=883:30, Micha=C5=82 Kazior wrote:
> On Thu, 11 Oct 2018 at 15:56, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:=

>>
>> Hi,
>>
>> I found one pretty strange behavior for the Intel 8265/8275 wireless
>> (from ThinkPad X1 carbon)
>>
>> If I ping *FROM* my router/desktop to the wireless laptop, the respons=
e
>> time is very unstable and slow, like:
>> ------
>> $ ping -4 thinkpad
>> PING thinkpad.lan (172.16.0.100) 56(84) bytes of data.
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D1 ttl=3D64 time=3D=
143 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D2 ttl=3D64 time=3D=
166 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D3 ttl=3D64 time=3D=
188 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D4 ttl=3D64 time=3D=
211 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D5 ttl=3D64 time=3D=
29.8 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D6 ttl=3D64 time=3D=
51.7 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D7 ttl=3D64 time=3D=
72.8 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D8 ttl=3D64 time=3D=
94.6 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D9 ttl=3D64 time=3D=
117 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D10 ttl=3D64 time=
=3D140 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D11 ttl=3D64 time=
=3D163 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D12 ttl=3D64 time=
=3D186 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D13 ttl=3D64 time=
=3D207 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D14 ttl=3D64 time=
=3D25.1 ms
>> 64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D15 ttl=3D64 time=
=3D47.6 ms
>> -----
>>
>> It looks like the response time get increase by 20ms and flipped over
>> around 200ms.
> [...]
>> So is this something wrong with the wireless card or something wrong
>> with the firmware/powersaving setting of ThinkPad X1 Carbon 6th gen?
>=20
> What you're seeing here is powersave.
>=20
> When you ping your laptop its wifi card may be in powersave so AP will
> store those icmp requests in a queue. The AP will start advertising
> that fact in the next beacon frame (which it broadcasts regularily).
> The wifi client can then see that there's traffic queued up for it,
> wake up, receive it and possibly reply (with icmp response in your
> case). The interval between each ping is long enough for the wifi
> client to re-enter powersave due to "nothing more to do" every time
> causing the same sequence (sleep, queue, advertise, wake, txrx).

Thanks for your detailed explanation, this really helps me to understand
the problem.

>=20
> The time drift comes from the fact beacon interval tends to be
> slightly off from your ping interval. The fact it wraps around at
> ~200msec for you means your AP's beacon interval is roughly that long
> as well which you can probably confirm with your AP/wifi router
> settings. Most APs tend to run 100 or 200msec (or TU, actually, which
> is 1024/1000 of msec) by default.
>=20
> If you run more traffic the lag will go away. I find this sort of
> behavior behavior annoying for mostly idle systems where I want to do
> remoting with ssh (or any other bursty and interactive work).

Yeah, completely the same case.

>=20
> You can try disabling powersave with:
>   iw wlan0 set power_save off
>=20
> You might need to replace wlan0 with wlpXsY depending on your system.
> You'll need root privileges to do it, e.g. via sudo, or su.

Works like a charm.

>=20
> Keep in mind it'll cause more power to be outputted and e.g. leave you
> with slightly shorter battery runtime. On intel compute sticks
> disabling wifi powersave can cause its fan to kick in more often due
> to thermal impact and unfortunate fan trip points.

Not a problem for Thinkpad with better thermal paste and extra tweaked
CPU parameters.

>=20
> Wifi powersave might be disabled in Windows for some reason. Maybe it
> does that disable it when AC is plugged in, and if you were to plug it
> out and run off of battery only, it'd enable it and show similar
> (laggy) behavior?

On battery, windows behaves exactly the same as Linux.

I only need to add some hook for AC/battery switch for Linux.

Thanks for your help!
Qu

>=20
>=20
> Micha=C5=82
>=20


--aDlUQQ03cJvMHvk3YoRYwSgYbxMjeETQL--

--1XGZjXOCWyPeVVJey2u1KTTzz0RCrOPhM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu/+iUACgkQwj2R86El
/qgvygf9FmGj9l+PyWqZy8C/Hxepm9qameargTKf//X8vLfI7ft+Wi4tFWsIX68F
3RskzaYrFDZaiqtVkQ4uyDNaeo8+YVM9SofD9upxnaaifa1rAXip1TB46ttgXrSK
BKHlgualU2Tv2xcOqGCnUsCGMsVzfs20dWLl9icxZq/2sMSO03dBSnM3qAaUAU4f
i+h7HrErowfv7qMogp2xCIvHKZ4GQUSGmGhY/Q35MhAiz5wnWlMcHMr3SxdBmka1
tK7ui/4AtM+TGvTGNUcZA01WTavcFBcdS+HgyYyTX8V/kWKBjbeh44l7y9a/uIYb
Y0LOS8EGL8vSj64LGeEANDnM+pfMjw==
=DxLR
-----END PGP SIGNATURE-----

--1XGZjXOCWyPeVVJey2u1KTTzz0RCrOPhM--
