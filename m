Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932375AbcL0Tq7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 14:46:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Peter Xu <peterx@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: Intel Wireless 7260 failed to work
References: <20161227091706.GA20895@pxdev.xzpeter.org>
Date: Tue, 27 Dec 2016 21:46:55 +0200
In-Reply-To: <20161227091706.GA20895@pxdev.xzpeter.org> (Peter Xu's message of
        "Tue, 27 Dec 2016 17:17:07 +0800")
Message-ID: <871swtkvdc.fsf@purkki.adurom.net> (sfid-20161227_204727_813922_D24B673F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Xu <peterx@redhat.com> writes:

> Looks like latest Linux master (4.10-rc1, 7ce7d89f) cannot work well
> with my wireless card, which is:
>
>   Intel Corporation Wireless 7260 (rev bb)
>
> Boot message shows that no suitable firmware found:
>
>     # journalctl -kp3
>     Dec 27 16:38:00 kernel: Error parsing PCC subspaces from PCCT
>     Dec 27 16:38:00 kernel: mmc0: Unknown controller version (3). You may experience problems.
>     Dec 27 16:38:02 kernel: DMAR: DRHD: handling fault status reg 2
>     Dec 27 16:38:02 kernel: DMAR: [DMA Write] Request device [00:02.0] fault addr 7200000000 [fault reason 05] PTE Write a
>     Dec 27 16:38:03 kernel: tpm tpm0: A TPM error (6) occurred attempting to read a pcr value
>     Dec 27 16:38:04 kernel: iwlwifi 0000:03:00.0: no suitable firmware found!
>
> Linux stable/master (Linux 4.8-rc8, 08895a8b6b) works for me. And no
> further tests have been done yet.
>
> Is this a known issue? Please let me know if anyone wants more info or
> logs, since this error triggers easily (everytime I boot).

The error message isn't really telling much to the user (hint hint) but
I suspect this is by design:

"iwlwifi: remove support for fw older than -17 and -22

FW versions older than -17 for 3160 and 7260 and older than -22 for
newer NICs are not supported anymore.  Don't load these versions
and remove code that handles them."

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4b87e5af638b6056bd6c20b0954d09a5a58633be

Adding luca.

-- 
Kalle Valo
