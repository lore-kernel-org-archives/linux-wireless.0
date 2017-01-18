Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37206 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754082AbdARO2a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 09:28:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rsi: Renamed the file rsi_91x_pkt.c to rsi_91x_hal.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1481173676-18808-1-git-send-email-prameela.j04cs@gmail.com>
References: <1481173676-18808-1-git-send-email-prameela.j04cs@gmail.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170118142829.2F5C96080C@smtp.codeaurora.org> (sfid-20170118_152834_367640_2BF8BEE1)
Date: Wed, 18 Jan 2017 14:28:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> wrote:
> The file 'rsi_91x_hal.c' is going to contain device specific
> code like firmware loading etc. As the file 'rsi_91x_pkt.c'
> contains code for preparing device (frimware understandable)
> specific descriptors for the transmit frames, it is moved to
> 'rsi_91x_hal.c'
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

These patches break endianess support again, at least in struct bl_header. And
also I see this AGAIN:

+/**
+ * bl_cmd() - This function initiates the BL command
+ *
+ * @adapter: Pointer to the hardware structure.
+ * @cmd: Command to write
+ * @exp_resp: Expected Response
+ * @str: Command string
+ *
+ * Return: 0 on success, -1 on failure.
+ */
+static int bl_cmd(struct rsi_hw *adapter, u8 cmd, u8 exp_resp, char *str)
+{

[...]

+fail:
+	return -EINVAL;
+}

If you insist keeping these, in my opinion useless, function documentation at
least make sure they are valid. How many times have I mentioned about this? If
you don't bother to follow this minor, but easy to fix, detail I'm starting to
wonder why I bother to use my time to review these patches and provide these
same comments over and over again.

Really, start with small patches and once you get more familiar start making
more complex patches. Or ask someone to help with reviewing the patches. And
LISTEN to feedback, just don't ignore it.

3 patches set to Changes Requested.

9465833 [1/3] rsi: Renamed the file rsi_91x_pkt.c to rsi_91x_hal.c
9465835 [2/3] rsi: Add new firmware loading method for RS9113 chip set
9465837 [3/3] rsi: Remove old firmware loading method for RS9113 chip set

-- 
https://patchwork.kernel.org/patch/9465833/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
