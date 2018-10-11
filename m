Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72542C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 13:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355EF20652
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 13:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 355EF20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbeJKVOV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:14:21 -0400
Received: from mout.gmx.net ([212.227.17.20]:53121 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbeJKVOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 17:14:21 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MEtba-1fugCi0xx4-00G4yS for
 <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 15:47:03 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MEtba-1fugCi0xx4-00G4yS for
 <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 15:47:03 +0200
To:     linux-wireless@vger.kernel.org
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Intel 8265 unstable/asymmetric ping response time (only under Linux)
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
Message-ID: <edaca500-8ae2-aef4-1c9d-b754af7e899f@gmx.com>
Date:   Thu, 11 Oct 2018 21:46:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cdmtXSt99zbWPuJ0b22IRzmfbr0rDbk6l"
X-Provags-ID: V03:K1:A5rCoNLQbR6Fqa8CMQcUHZjzY1JihZ4og8mT/Qwr+alSAOGgZWA
 gAzeq4eIXA1vdzeajQZHO8Ao8JGbR2mJ38loBFf+4dyZB/hbx6r8YZj6+NRAJg7lTd9sThf
 xYXAR6Zas7sJ94ctuxQvhe6c5yrHGHQldDdlsISd9U4ELnL3r+ZAQ9yFONurMN4Owu5RGyI
 judFX45Dg78ezjhYcbDRA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:QmOaLinYTcA=:2V6niIDkqa3BdBbMItcBUv
 lqERffHS1PuKODw+Bxk8NgANsHTL4ZQxeXNlOS3bdPTcGY8L/MG9Dbdbd4wc9FPJlDWMdnHSg
 eaSwhaqFDdP5AbgnR9QBiIrZCGCsY6nfZr/5w60KN8zWeQCp9erfMLhKOl92rgk5dkjd/w+mB
 Ha1fn45RR5+7fT7iXxpCJaVcuKasC8ZSILZFNOmGup6708BrznfdP2YkO9n9+FRpN3ak2uSDD
 Wea8fE40kEhFAdemYR5v/55ZsuIstW0QBij4Z+oPjd2Ce9B+eEZ1MnEZQcujW1UGInxkfPa04
 ljdba3DDAXOKDkW0ibxUASsbOlXWEgyTcAkM+HjYjJ+IHH3j8ZHUKwjYLoANg/B05Mh0EiwGX
 6dqAlSLyjmcajQAh9aCvggjYM4ZCNIijwE58I0RTBvvxAQGg4jQNeWmSMXAXFwuybN9qTvSMW
 SfR7SAesdKyrjyJVB7SkZVQldebFoyvo5L3vBDH/se2qwmgKOFypyH0Xrv0d7l3htFpKjkwNB
 PlZIvfmHlOyu8XA70+DlwK+yl1byN3QWIoDCo+ZCxMaeDHqNG0hrgV1Jp8lznjCryiqxtujst
 GjMTrVFaI1tVTomTIJotJEKixTdGydhmFn9eWdqIcrBS1/RDdVloaS02E5FreCML7UbCVPWTu
 cMLNEpBDR+SeTQ67GEd2K6zN49uqrbVPJlh60mYh2SuAVsKm1+71GQx8ipNFOuexNZo0tphQO
 NnFJ4ERJWlFVwgOs5/mT9e+wc283lKK0xots/I90rWlBaQD9dxBWQ1dvezcNI90DGs8Zb0Tr8
 9RBoEkFkwBZgTb2/UxGo2Fps27tEw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cdmtXSt99zbWPuJ0b22IRzmfbr0rDbk6l
Content-Type: multipart/mixed; boundary="Yirk65MKa8F8QWF13TGp00Zfhto0V5FGs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-wireless@vger.kernel.org
Message-ID: <edaca500-8ae2-aef4-1c9d-b754af7e899f@gmx.com>
Subject: Intel 8265 unstable/asymmetric ping response time (only under Linux)

--Yirk65MKa8F8QWF13TGp00Zfhto0V5FGs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I found one pretty strange behavior for the Intel 8265/8275 wireless
(from ThinkPad X1 carbon)

If I ping *FROM* my router/desktop to the wireless laptop, the response
time is very unstable and slow, like:
------
$ ping -4 thinkpad
PING thinkpad.lan (172.16.0.100) 56(84) bytes of data.
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D1 ttl=3D64 time=3D1=
43 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D2 ttl=3D64 time=3D1=
66 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D3 ttl=3D64 time=3D1=
88 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D4 ttl=3D64 time=3D2=
11 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D5 ttl=3D64 time=3D2=
9.8 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D6 ttl=3D64 time=3D5=
1.7 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D7 ttl=3D64 time=3D7=
2.8 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D8 ttl=3D64 time=3D9=
4.6 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D9 ttl=3D64 time=3D1=
17 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D10 ttl=3D64 time=3D=
140 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D11 ttl=3D64 time=3D=
163 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D12 ttl=3D64 time=3D=
186 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D13 ttl=3D64 time=3D=
207 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D14 ttl=3D64 time=3D=
25.1 ms
64 bytes from thinkpad.lan (172.16.0.100): icmp_seq=3D15 ttl=3D64 time=3D=
47.6 ms
-----

It looks like the response time get increase by 20ms and flipped over
around 200ms.

But when pinging *FROM* the laptop to the router/desktop, it's
completely fine:

------
$ ping openwrt
PING openwrt.lan (172.16.0.1) 56(84) bytes of data.
64 bytes from _gateway (172.16.0.1): icmp_seq=3D1 ttl=3D64 time=3D2.52 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D2 ttl=3D64 time=3D3.59 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D3 ttl=3D64 time=3D2.54 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D4 ttl=3D64 time=3D3.11 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D5 ttl=3D64 time=3D2.93 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D6 ttl=3D64 time=3D2.69 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D7 ttl=3D64 time=3D3.49 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D8 ttl=3D64 time=3D2.58 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D9 ttl=3D64 time=3D2.75 ms=

64 bytes from _gateway (172.16.0.1): icmp_seq=3D10 ttl=3D64 time=3D2.60 m=
s
------

The kernel is 4.18.12-arch1-1-ARCH, so it's pretty new.
The BIOS of the ThinkPad is already updated with fwpud.

BTW, if I boot that thinkpad with Windows, no matter I ping from/to that
laptop, response time is always around 2~3ms.

So is this something wrong with the wireless card or something wrong
with the firmware/powersaving setting of ThinkPad X1 Carbon 6th gen?

Thanks
Qu


--Yirk65MKa8F8QWF13TGp00Zfhto0V5FGs--

--cdmtXSt99zbWPuJ0b22IRzmfbr0rDbk6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu/VFIACgkQwj2R86El
/qgllgf9GRFWgaZa201uuR4HeQ4EwQ4IvvWd1ZGW9FTQdmW1WPDn0aXWO8m1XVlr
+UGyQtMJCj3OAHoDx5i4qWZrGd+AMarUnw4SlJTKT57YlyqsRM898xo8XHkb5Mtu
rg+2AFqtGdLpzL3Llk/uA/HUgYQ4/8FVtHfUS9pyt6U4JP+2F3ELEGUH6i5OjgSC
cwnUTGPAYS2tgnH//Wd9jxYXRcTmsAIQbx7zh2X1kBas+M1bYRkbagtGZ/CcS8Wr
MbSlsaqIM6ZT3KuT6HH47qwZGmaycdN3vuGhrSn/HHRGha8GjRKWRxpP9ksAlhdK
pwtApwrhnst0Ri41vsT9TU4bbfJyrg==
=kfuz
-----END PGP SIGNATURE-----

--cdmtXSt99zbWPuJ0b22IRzmfbr0rDbk6l--
