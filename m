Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbdCTRJp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:09:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] mwifiex: fix kernel crash after shutdown command timeout
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170316213607.62386-1-briannorris@chromium.org>
References: <20170316213607.62386-1-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Amitkumar Karwar <akarwar@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20170320170944.3D26D609C6@smtp.codeaurora.org> (sfid-20170320_181010_640416_39F1CAC4)
Date: Mon, 20 Mar 2017 17:09:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> We observed a SHUTDOWN command timeout during reboot stress test due to
> a corner case firmware bug. It can lead to either a use-after-free +
> OOPS (on either the adapter structure, or the 'card' structure) or an
> abort (where, e.g., the PCI device is "disabled" before we're done
> dumping the FW).
> 
> We can avoid this by canceling/flushing the FW dump work:
> 
> (a) after we've terminated all other work queues (e.g., for processing
>     commands which could time out)
> (b) after we've disabled all interrupts (which could also queue more
>     work for us)
> (c) after we've unregistered the netdev and wiphy structures (and
>     implicitly, and debugfs entries which could manually trigger FW dumps)
> (d) before we've actually disabled the device (e.g.,
>     pci_device_disable())
> 
> Altogether, this means no card->work will be scheduled if we sync at
> a point that satisfies the above. This can be done at the beginning of
> the .cleanup_if() callback.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

5caa7f384629 mwifiex: fix kernel crash after shutdown command timeout

-- 
https://patchwork.kernel.org/patch/9629349/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
