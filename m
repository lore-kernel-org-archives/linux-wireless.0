Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56134 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938679AbcKQRbS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:31:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Shengzhen Li <szli@marvell.com>
Subject: Re: [PATCH v3 01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
        <20161114194049.GA131593@google.com>
Date: Thu, 17 Nov 2016 14:41:11 +0200
In-Reply-To: <20161114194049.GA131593@google.com> (Brian Norris's message of
        "Mon, 14 Nov 2016 11:40:50 -0800")
Message-ID: <877f82mg7s.fsf@kamboji.qca.qualcomm.com> (sfid-20161117_183134_559730_F724B568)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> On Fri, Nov 11, 2016 at 06:40:08PM +0530, Amitkumar Karwar wrote:
>
>> There are multiple mwifiex patches under review. I want you consider them
>> in following sequence(first being oldest) to avoid conflicts
>
> Thanks for doing this! It's a little confusing about what's outstanding
> at the moment (and I think I was just confused on a review a bit ago; I
> wasn't 100% sure what it was based on), so this listing helps.
>
> If it helps, I'll put my comments here, since I've reviewed most of
> these:
>
>> [v3] mwifiex: report wakeup for wowlan
>
> Reviewed, SGMT.
>
>> mwifiex: add power save parameters in hs_cfg cmd
>
> Didn't review. No comment.
>
>> [2/2] mwifiex: ignore calibration data failure (Note: 1/2 has dropped)
>
> Didn't review. But FWIW, Kalle expressed a preference for full series,
> not partial.

You are correct, but dropping patches in patchwork is easy so I usually
can do that myself. Changing or adding patches to a patchset is the
difficult part.

So I dropped patch 1 now.

>> [v6] mwifiex: parse device tree node for PCIe
>
> This one is marked Deferred in patchwork, and I had some comments about
> it, since it introduced a double-free issue. I'd prefer it get fixed and
> resent, and I expect Kalle is also waiting for this.

Correct, I dropped v6.

>> [v2,1/3] mwifiex: Allow mwifiex early access to device structure
>> [v2,2/3] mwifiex: Introduce mwifiex_probe_of() to parse common properties
>> [v2,3/3] mwifiex: Enable WoWLAN for both sdio and pcie
>
> You sent v3 for the above, and those LGTM (I provided my review). I was
> probably also confused because they were based on the above "[v6]
> mwifiex: parse device tree node for PCIe", which was not completely
> correct.

v4 of this patchset is now "Under Review", which in practise means that
the patches are pending for commit. (Too bad that patchwork doesn't have
a "Pending" state, so I have to use "Under Review" instead)

>> mwifiex: don't do unbalanced free()'ing in cleanup_if()
>> mwifiex: printk() overflow with 32-byte SSIDs
>> mwifiex: fix memory leak in mwifiex_save_hidden_ssid_channels()
>
> I wrote or reviewed the above 3. LGTM.

The first is now "Under Review" and the last two I have already applied.

>> [v3,01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
>> [v3,02/11] mwifiex: complete blocked power save handshake in main process
>> [v3,03/11] mwifiex: resolve races between async FW init (failure) and device removal
>> [v3,04/11] mwifiex: remove redundant pdev check in suspend/resume handlers
>> [v3,05/11] mwifiex: don't pretend to resume while remove()'ing
>> [v3,06/11] mwifiex: resolve suspend() race with async FW init failure
>> [v3,07/11] mwifiex: reset card->adapter during device unregister
>> [v3,08/11] mwifiex: usb: handle HS failures
>> [v3,09/11] mwifiex: sdio: don't check for NULL sdio_func
>> [v3,10/11] mwifiex: stop checking for NULL drvata/intfdata
>> [v3,11/11] mwifiex: pcie: stop checking for NULL adapter->card
>
> For this entire series, I looked over them again (and I wrote several in
> the first place), so for all 11:
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

These 11 are now "Under Review".

So to summarise, this is what I'm planning to commit (it's sorted by
date but I try to follow the order Amit specified when I commit these):

[  1] mwifiex: add power save parameters in hs_cfg cmd             2016-10-14 Amitkumar Ka Under Review
[  2] [2/2] mwifiex: ignore calibration data failure               2016-10-21 Amitkumar Ka Under Review
[  3] mwifiex: don't do unbalanced free()'ing in cleanup_if()      2016-10-26 Brian Norris Under Review
[  4] [v3,01/11] mwifiex: check tx_hw_pending before downloadin... 2016-11-11 Amitkumar Ka Under Review
[  5] [v3,02/11] mwifiex: complete blocked power save handshake... 2016-11-11 Amitkumar Ka Under Review
[  6] [v3,03/11] mwifiex: resolve races between async FW init (... 2016-11-11 Amitkumar Ka Under Review
[  7] [v3,04/11] mwifiex: remove redundant pdev check in suspen... 2016-11-11 Amitkumar Ka Under Review
[  8] [v3,05/11] mwifiex: don't pretend to resume while remove(... 2016-11-11 Amitkumar Ka Under Review
[  9] [v3,06/11] mwifiex: resolve suspend() race with async FW.... 2016-11-11 Amitkumar Ka Under Review
[ 10] [v3,07/11] mwifiex: reset card->adapter during device unr... 2016-11-11 Amitkumar Ka Under Review
[ 11] [v3,08/11] mwifiex: usb: handle HS failures                  2016-11-11 Amitkumar Ka Under Review
[ 12] [v3,09/11] mwifiex: sdio: don't check for NULL sdio_func     2016-11-11 Amitkumar Ka Under Review
[ 13] [v3,10/11] mwifiex: stop checking for NULL drvata/intfdata   2016-11-11 Amitkumar Ka Under Review
[ 14] [v3,11/11] mwifiex: pcie: stop checking for NULL adapter-... 2016-11-11 Amitkumar Ka Under Review
[ 15] [v3,1/3] mwifiex: Allow mwifiex early access to device st... 2016-11-14 Amitkumar Ka Under Review
[ 16] [v3,2/3] mwifiex: Introduce mwifiex_probe_of() to parse c... 2016-11-14 Amitkumar Ka Under Review
[ 17] [v3,3/3] mwifiex: Enable WoWLAN for both sdio and pcie       2016-11-14 Amitkumar Ka Under Review
[ 18] [v4,1/3] mwifiex: Allow mwifiex early access to device st... 2016-11-15 Amitkumar Ka Under Review
[ 19] [v4,2/3] mwifiex: Introduce mwifiex_probe_of() to parse c... 2016-11-15 Amitkumar Ka Under Review
[ 20] [v4,3/3] mwifiex: Enable WoWLAN for both sdio and pcie       2016-11-15 Amitkumar Ka Under Review

Patchwork link for the same:

https://patchwork.kernel.org/project/linux-wireless/list/?state=2&q=mwifiex

Does that look ok?

-- 
Kalle Valo
