Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:37194 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3JRH5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 03:57:17 -0400
Message-ID: <5260E9F4.2070204@openwrt.org> (sfid-20131018_095720_827969_98EA0966)
Date: Fri, 18 Oct 2013 09:57:40 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 00/21] rt2x00: separate rt2800 PCI and SoC driver
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org> <CAGXE3d_HZZrEspONsjoqGrynGKYN9pisX-jgRZdV760uuVq5cQ@mail.gmail.com>
In-Reply-To: <CAGXE3d_HZZrEspONsjoqGrynGKYN9pisX-jgRZdV760uuVq5cQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

> On Thu, Oct 17, 2013 at 9:42 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> The rt2800pci driver supports both PCI and SoC device. To achieve
>> this, the code uses several ifdef statements which makes the code
>> quite ugly. The patch set introduces a shared module, and moves the
>> SoC driver into a separate module to get rid of the mess.
> 
> Nice series. Does this also reduce module size on when building for
> SoC without PCI support?

Nope. On the contrary, there is a small increase due to the new rt2800mmio
module (compiled for RT305x SoCs):

before:
   text    data     bss     dec     hex filename
   7232      96      16    7344    1cb0 rt2800pci.o

after:
   text    data     bss     dec     hex filename
   1934     100      16    2050     802 rt2800soc.o
   5664       0       0    5664    1620 rt2800mmio.o

delta:
   +366      +4       0    +370

-Gabor

