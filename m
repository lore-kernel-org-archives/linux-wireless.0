Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53488 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1FJLRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 07:17:24 -0400
Received: by qwk3 with SMTP id 3so1164133qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 04:17:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF1E973.1030709@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
 <1307630701-9170-13-git-send-email-rvossen@broadcom.com> <BANLkTi=GGsW4eja0QunMAc5vqqFkmvNxNA@mail.gmail.com>
 <4DF1E973.1030709@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Fri, 10 Jun 2011 13:17:04 +0200
Message-ID: <BANLkTi=2d+5UjAnQVatapObA_GuHXzpG3A@mail.gmail.com> (sfid-20110610_131727_885667_47B19A27)
Subject: Re: [PATCH 12/21] staging: brcm80211: use __BIG_ENDIAN macro in dma.c
To: Arend van Spriel <arend@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 10 June 2011 11:52, Arend van Spriel <arend@broadcom.com> wrote:
> Hi Jonas,
>
> You are right as with previous mips related patches. Consider this a first
> step which does not change functionality but aims to use the proper linux
> provided macros instead of our own incarnations.

Actually as far as I can tell this changes (non-)functionality: With
the broken big endiness check the driver probably just doesn't work
properly on MIPS BE systems, because some endianess conversion is
missing*. With the endianess check fixed, the special handling for the
Broadcom MIPS get's enabled, potentially crashing the system (or
changing random registers), thus making it *more* broken for non BMIPS
systems. Therefore I'd rather consider this a regression. Especially
since (AFAIK) the BMIPS systems that can take advantage of this aren't
supported in Linux (yet).

If it were just making things less efficient, I wouldn't be
complaining (at least not that much ;-). If you can say that this is a
code path that isn't taken anyway, then my point is moot (for now). I
don't know the driver enough to tell that.

Jonas

*assuming brcm80211 depends on this on BE systems and it isn't just an
optimization
