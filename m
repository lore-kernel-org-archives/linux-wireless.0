Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:37223 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZCEQiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 11:38:50 -0500
Message-ID: <49B00011.1030001@openwrt.org> (sfid-20090305_173853_185886_D835D493)
Date: Thu, 05 Mar 2009 17:38:41 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH] ath9k: create a common debugfs_root for
 all	device instances
References: <1236268518-31873-1-git-send-email-juhosg@openwrt.org> <18863.64330.683644.463962@gargle.gargle.HOWL>
In-Reply-To: <18863.64330.683644.463962@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> The driver are trying to create an 'ath9k' directory in debugfs for =
each
>> device currently. If there are more than one device in the system, t=
he
>> second try will always fail.
>=20
> Looks good. Thanks.

Thank you for the review.

>=20
> Also, reading 'rcstat' when the interface is down would cause a NULL
> pointer dereference.=20

Indeed. :)

root@OpenWrt:/# cat /tmp/debug/ath9k/phy0/rcstat
CPU 0 Unable to handle kernel paging request at virtual address 0000000=
0, epc =3D=3D
c02886c8, ra =3D=3D c0288674
Oops[#1]:
Cpu 0
$ 0   : 00000000 fffffff8 00000000 00000000
$ 4   : ffffffff 00000200 c02a0000 00000005
$ 8   : 00000000 80000008 ffffffff 00000000
$12   : 82d8d080 00000000 2ab935ac 00404995
$16   : 00000017 82f30ae0 82f30ae0 00000000
$20   : 00000000 7fc3d130 00001000 82d9bf18
$24   : 00000166 c028853c
$28   : 82d9a000 82d9bab0 00000003 c0288674
Hi    : 0000025b
Lo    : 000001df
epc   : c02886c8 0xc02886c8
    Not tainted
ra    : c0288674 0xc0288674
Status: 1000f403    KERNEL EXL IE
Cause : 00800008
BadVA : 00000000
PrId  : 00019374 (MIPS 24Kc)
Modules linked in: leds_gpio nf_nat_tftp nf_conntrack_tftp nf_nat_irc
nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp ipt_MASQUi
Process cat (pid: 852, threadinfo=3D82d9a000, task=3D82ddba18, tls=3D00=
000000)
Stack : 8027809c 00000000 c029b96c c029b974 83889f48 00000001 80278098 =
00000200
        00000000 2aaed0d8 20202052 61746520 20202020 20205375 63636573 =
730a0a00
        00000001 00000044 00000000 2aaed0d8 00000000 001200d2 81065c60 =
8284b2a8
        82897528 82897528 00000001 00000200 81065c60 00000000 800bee0c =
800bee0c
        82897528 82897528 82e904b4 00000000 00000001 00000005 2aaed000 =
81065c60
        ...

> Will send out a patch fixing this.

Superb.

Gabor
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
