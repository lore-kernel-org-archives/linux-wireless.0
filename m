Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:34118 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbeHFMql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 08:46:41 -0400
Subject: Re: [PATCH v3 00/11] NFC: A bunch of cleanups for st95hf
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, colin.king@canonical.com,
        shikha.singh@st.com
References: <20180724095941.25777-1-daniel@zonque.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <2b5303c6-d9b6-de58-690b-9508c139e7d6@zonque.org> (sfid-20180806_123817_745444_0B88636D)
Date: Mon, 6 Aug 2018 12:38:12 +0200
MIME-Version: 1.0
In-Reply-To: <20180724095941.25777-1-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

On Tuesday, July 24, 2018 11:59 AM, Daniel Mack wrote:
> This v3 of a series of patches for the ST95HF driver.
> 
> Patch #1 reverts a change that I have submitted earlier and which is
> sitting in nfc-next already. Given that the tree hasn't been sent out
> for being merged yet, it could also still be removed with rebasing, in
> which case #1 is not necessary of course.
> 
> The changes are all rather simple and are explained in their individual
> commit logs.
> 
> Note that this series builds upon the patch titled "nfc: st95hf: remove
> redundant pointers 'dev' and 'nfcddev'" that Colin posted the other day.

Could you still apply this set for 4.19?

At least #1 should go in, or commit c99f996b2ba49 ("NFC: st95hf: drop 
illegal kfree_skb()") which is already in your tree should be removed 
with a rebase.

For the rest, I'm in no hurry. I just want to prevent a regression in 4.19.


Thanks,
Daniel



> 
> 
> Thanks,
> Daniel
> 
> Changelog:
> 
> v1 → v2:
> 
>   * Improved commit logs, identical patch content.
> 
> 
> v2 → v3:
> 
>   * Added another patch titled "NFC: st95hf: ignore spurious interrupts"
> 
> 
> Daniel Mack (11):
>    Revert "NFC: st95hf: drop illegal kfree_skb()"
>    NFC: st95hf: drop nfcdev_free
>    NFC: st95hf: drop illegal kfree_skb() in IRQ handler
>    NFC: st95hf: remove logging from spi functions
>    NFC: st95hf: remove exchange_lock
>    NFC: st95hf: move skb allocation to ISR
>    NFC: st95hf: ignore spurious interrupts
>    NFC: st95hf: re-order command defines
>    NFC: st95hf: unify sync/async flags
>    NFC: st95hf: two small style nits
>    NFC: st95hf: add of match table
> 
>   drivers/nfc/st95hf/core.c | 154 ++++++++++++++------------------------
>   drivers/nfc/st95hf/spi.c  |  31 +++-----
>   drivers/nfc/st95hf/spi.h  |   8 +-
>   3 files changed, 66 insertions(+), 127 deletions(-)
> 
