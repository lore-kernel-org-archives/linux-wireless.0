Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36620 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdANRAM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Jan 2017 12:00:12 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH 04/40] rt2x00: rt2800lib: fix beacon generation on RT3593
References: <20170113212027.GA3372@makrotopia.org>
Date: Sat, 14 Jan 2017 19:00:05 +0200
In-Reply-To: <20170113212027.GA3372@makrotopia.org> (Daniel Golle's message of
        "Fri, 13 Jan 2017 22:20:32 +0100")
Message-ID: <874m114lwq.fsf@codeaurora.org> (sfid-20170114_180016_514431_D55ED9FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> writes:

> From: Gabor Juhos <juhosg@openwrt.org>
>
> On the RT3593 chipset, the beacon registers are located
> in the high 8KB part of the shared memory.
>
> The high part of the shared memory is only accessible
> if it is explicitly selected. Add a helper function
> in order to be able to control the SHR_MSEL bit in
> the PBF_SYS_CTRL register. Also add a few more helper
> functions and use those to select the correct part of
> the shared memory before and after accessing the beacon
> registers.
>
> The base addresses of the beacon registers are also
> different from the actually used values, so fix the
> 'rt2800_hw_beacon_base' function to return the correct
> values.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Daniel, as you are submitting these patches you should add your
Signed-off-by after the author's line. Documentation/SubmittingPatches
contains more info about that and what Signed-off-by means. And also
take a look at how Luca does it:

http://www.spinics.net/lists/linux-wireless/msg158064.html

-- 
Kalle Valo
