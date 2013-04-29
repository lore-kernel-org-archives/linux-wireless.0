Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56755 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab3D2TK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 15:10:27 -0400
Date: Mon, 29 Apr 2013 15:10:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.10] NFC pull request
Message-ID: <20130429191020.GB4590@tuxdriver.com> (sfid-20130429_211051_563300_31D20559)
References: <20130426232805.GB8192@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130426232805.GB8192@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 27, 2013 at 01:28:05AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This pull request includes Marcel's Kconfig dependency fix on top of the LLCP
> code move to net/nfc.
> 
> Thanks in advance for pulling these 2 in.
> 
> The following changes since commit b006ed545cbadf1ebd4683719554742d20dbcede:
> 
>   mwifiex: rework round robin scheduling of bss nodes. (2013-04-23 15:18:40 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.10-4
> 
> for you to fetch changes up to c204ea092eead40d2ac577fc3b5c77052ec22a59:
> 
>   NFC: Add missing RFKILL dependency for Kconfig (2013-04-27 01:02:46 +0200)
> 
> ----------------------------------------------------------------
> With this one we have:
> 
> - One patch for moving the LLCP code into net/nfc.
>   It fixes a build annoyance reported by Dave Miller caused by the fact
>   that the LLCP code object targets are not in the same directory as the
>   Makefile trying to build them is. It prevents us from doing e.g.
> 
>         make net/nfc/llcp/sock.o
> 
>   Moving the LLCP code into net/nfc and not making it optional anymore
>   makes sense as LLCP is a fundamental piece of the NFC specifications
>   and thus should be in the core NFC directory.
> 
> - One patch that fixes the missing dependency against RFKILL. Without it NFC
>   fails to properly build when it's builtin and CONFIG_RFKILL=m.

I'm pulling this one now, since it was requested by Dave...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
