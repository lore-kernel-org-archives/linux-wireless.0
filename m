Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53946 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab1FIXxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 19:53:34 -0400
Received: by qyk7 with SMTP id 7so2782067qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2011 16:53:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307630701-9170-13-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com> <1307630701-9170-13-git-send-email-rvossen@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Fri, 10 Jun 2011 01:53:14 +0200
Message-ID: <BANLkTi=GGsW4eja0QunMAc5vqqFkmvNxNA@mail.gmail.com> (sfid-20110610_015338_791860_053D3A36)
Subject: Re: [PATCH 12/21] staging: brcm80211: use __BIG_ENDIAN macro in dma.c
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 June 2011 16:44, Roland Vossen <rvossen@broadcom.com> wrote:
> From: Arend van Spriel <arend@broadcom.com>
>
> The source file dma.c used a macro definition that indicated a big endian
> platform. The linux tree has its own macro determined by architecture and/or
> kernel configuration. This byteorder macro is __BIG_ENDIAN. This is now used
> in dma.c.

While this replacement is technically correct, the check itself is
wrong and should be fixed instead. Currently it assumes that __mips__
means Broadcom MIPS; but if it isn't, then there's likely no
SI_SDRAM_SWAPPED and any access there will in best case do nothing
(but more like hang the system).

Use either CONFIG_BCM47XX or CONFIG_BCM63XX to check for the BMIPS
platforms this is probably intended for (I'm not 100% sure if BCM63XX
has the swapped memory space - better check with your xDSL people ;-).


Jonas
