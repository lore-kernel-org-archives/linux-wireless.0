Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755AbYE1UKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 16:10:42 -0400
Date: Wed, 28 May 2008 13:10:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?=
	<ariveira@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
In-Reply-To: <20080527124315.131b1343@Varda>
Message-ID: <alpine.LFD.1.10.0805281307150.2958@woody.linux-foundation.org> (sfid-20080528_221047_669541_BE57D5DF)
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527124315.131b1343@Varda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tue, 27 May 2008, Alejandro Riveira Fern=C3=A1ndez wrote:
> =20
>   Compiled and booting into 2.6.26-rc4
>=20
>  1) With splash quiet on grub line it doesn't boot (or i didin't wait=
 long
>     enough)
>  2) without quiet and splash I get into VT X filas becouse i use the =
evil
>     nvidia driver that's expected. But ubuntu failsafe mode (xserver =
with vesa
>     in low res) doesn't show up either *regression*

Can you give more details about where it stops?=20

>  3) i get an oops with network manager

=2E. again, please give the full oops, without that we just know that "=
an=20
oops happened".

>  4) if i try to run some sudo command it gets stuck (Crtl +C doesnt' =
help)
>     "ip route" gets stuck too. User programs i tried wrok fine (only =
ls and
>     htop). Network realted problem?

I assume it's related to the oops above - the oops probably happened wh=
ile=20
holding some mutex or other lock, which is why network-related stuff th=
en=20
blocks on that lock (which will never be released, since the oops kille=
d=20
the process that held it).

I suspect the oops is also why the bootup breaks, so it's likely all th=
e=20
same issue. Please save the dmesg into a file, reboot into a working=20
setup, and send that. Along with hw information (it's likely related to=
=20
your network device driver, since I've not seen an uproar of these kind=
s=20
of problems from everybody else..).

>  5) printk times on dmesg go crazy

More details, please, again.

			Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
