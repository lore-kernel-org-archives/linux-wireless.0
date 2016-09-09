Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60433 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750833AbcIIO7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 10:59:22 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Benjamin Berg <benjamin@sipsolutions.net>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "Simon Wunderlich" <sw@simonwunderlich.de>,
        "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv3 0/5] ath10k: Allow setting coverage class and rx
 cleanups
Date: Fri, 9 Sep 2016 14:59:08 +0000
Message-ID: <871t0tp1ad.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_165926_418202_B8BF4B79)
References: <20160829144557.11678-1-benjamin@sipsolutions.net>
In-Reply-To: <20160829144557.11678-1-benjamin@sipsolutions.net> (Benjamin
        Berg's message of "Mon, 29 Aug 2016 16:45:52 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Berg <benjamin@sipsolutions.net> writes:

> OK, another revision adding the fast path as suggested by Ben Greear. Onl=
y
> other change is that I am submitting it together with Vasanthakumar's cle=
anup
> patches to allow merging both into ath-next in one go.
>
> Changes in v4:
>  * Only queue register setting work if coverage class is non-zero
>  * Add cleanup patches from Vasanthakumar into series
>
> Changes in v3:
>  * Only update register values if hardware is initialized
>  * Use the SM/MS macros instead of manual bitshifts and masks
>  * Use the hardware phyclk register instead of assuming a clock speed
>  * Force dbglog_mask of ~0 and dbglog_level of at least WARN if active
>  * Only call code for selected WMI events
>
> The last two items are a bit of a guess for me. In particular it looks li=
ke
> the default log level is already WARN, but I suppose that this should be =
good
> enough to get reports for internal chip resets. I have no way of verifyin=
g
> this myself though.
>
>
> Benjamin Berg (1):
>   ath10k: Allow setting coverage class
>
> Vasanthakumar Thiagarajan (4):
>   ath10k: Move ath10k_hw_params definition to hw.h
>   ath10k: Add provision for Rx descriptor abstraction
>   ath10k: Properly remove padding from the start of rx payload
>   ath10k: Remove 4-addr padding related hw_param configuration

There were few conflicts, though easy. Please double check the pending
branch that I didn't make any mistakes, I didn't test these yet.

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/log/?h=3Dpending

Also please CC linux-wireless when submitting ath10k patches, we get
wider review that way. Added it to CC now.

My log of the conflicts:

Applying: ath10k: Move ath10k_hw_params definition to hw.h
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/core.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/core.=
h
Failed to merge in the changes.
Patch failed at 0001 ath10k: Move ath10k_hw_params definition to hw.h

moved: bool sw_decrypt_mcast_mgmt;

Applying: ath10k: Add provision for Rx descriptor abstraction
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/ath/ath10k/hw.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/hw.h
Auto-merging drivers/net/wireless/ath/ath10k/core.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/core.=
c
Failed to merge in the changes.
Patch failed at 0002 ath10k: Add provision for Rx descriptor abstraction

Applying: ath10k: Allow setting coverage class
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath=
10k/core.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ath10k: Allow setting coverage class

  CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/mac=
.c



patching file drivers/net/wireless/ath/ath10k/core.c
Hunk #1 succeeded at 1548 (offset 5 lines).
Hunk #2 succeeded at 2333 with fuzz 2 (offset 73 lines).
patching file drivers/net/wireless/ath/ath10k/core.h
Hunk #1 succeeded at 911 with fuzz 2 (offset 21 lines).
patching file drivers/net/wireless/ath/ath10k/hw.c
patching file drivers/net/wireless/ath/ath10k/hw.h
Hunk #2 succeeded at 416 (offset 5 lines).
Hunk #3 succeeded at 613 (offset 5 lines).
Hunk #4 succeeded at 813 (offset 5 lines).
patching file drivers/net/wireless/ath/ath10k/mac.c
Hunk #1 succeeded at 5410 (offset 38 lines).
Hunk #2 succeeded at 7449 (offset 38 lines).
Hunk #3 succeeded at 8027 (offset 38 lines).
patching file drivers/net/wireless/ath/ath10k/wmi.c
Hunk #1 succeeded at 4925 (offset 46 lines).
Hunk #2 succeeded at 4962 (offset 46 lines).
Hunk #3 succeeded at 4972 (offset 46 lines).
Hunk #4 succeeded at 4999 (offset 46 lines).
Hunk #5 succeeded at 5055 (offset 46 lines).
Hunk #6 succeeded at 5099 (offset 46 lines).
Hunk #7 succeeded at 5109 (offset 46 lines).
Hunk #8 succeeded at 5136 (offset 46 lines).
Hunk #9 succeeded at 5183 (offset 46 lines).
Hunk #10 succeeded at 5230 (offset 59 lines).
Hunk #11 succeeded at 5240 (offset 59 lines).
Hunk #12 succeeded at 5267 (offset 59 lines).
Hunk #13 succeeded at 5305 (offset 59 lines).
Hunk #14 succeeded at 5379 (offset 72 lines).
Hunk #15 succeeded at 5396 (offset 72 lines).
Hunk #16 succeeded at 5413 (offset 72 lines).
Hunk #17 succeeded at 6137 (offset 73 lines).

--=20
Kalle Valo=
