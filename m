Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50882 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1ENKQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 06:16:54 -0400
Received: by qyg14 with SMTP id 14so1847265qyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 03:16:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305280792-9475-4-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com> <1305280792-9475-4-git-send-email-arend@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Sat, 14 May 2011 12:16:31 +0200
Message-ID: <BANLkTimEX7Mrg6HTdQdJDStyc9ZTpd7nKw@mail.gmail.com> (sfid-20110514_121658_033847_AFFA7C98)
Subject: Re: [PATCH 04/32] staging: brcm80211: got rid of #ifdef __mips__
 sections in hnddma.c
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 May 2011 11:59, Arend van Spriel <arend@broadcom.com> wrote:
> From: Roland Vossen <rvossen@broadcom.com>
>
> Code cleanup. Broadcom MIPS chips in big endian mode have a memory window
> in which sdram contents is byte swapped. Code in hnddmac.c makes use of
> this window. Reworked code so the #ifdef __mips__ is moved from .c to
> .h file.

Shouldn't this be guarded with e.g. CONFIG_BCM63XX instead of
__mips__? Not every big endian mips is a broadcom ;-). I don't know if
there are further Broadcom ones, the only other I know is bcm47xx and
that one is little endian.

Regards
Jonas
