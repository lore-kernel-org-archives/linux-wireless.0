Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:36818 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751342AbdDCStA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:49:00 -0400
Received: by mail-pg0-f42.google.com with SMTP id g2so127132620pge.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:49:00 -0700 (PDT)
Date: Mon, 3 Apr 2017 11:48:58 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dtor@google.com>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Rajat Jain <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 3/3] mwifiex: pcie: avoid hardcode wifi-only firmware name
Message-ID: <20170403184857.GC116262@google.com> (sfid-20170403_204908_900535_FB5E78C1)
References: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
 <1490865547-10208-3-git-send-email-huxinming820@gmail.com>
 <CAE_wzQ-6irwa5_HeQuRk3kOcLBrYR9N9XNFPg_xx7tmWcHdgGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE_wzQ-6irwa5_HeQuRk3kOcLBrYR9N9XNFPg_xx7tmWcHdgGA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 31, 2017 at 03:50:27PM -0700, Dmitry Torokhov wrote:
> That said, I consider the whole wifi-only firmware business is quite
> fragile. Can we have unified firmware and have driver figure out what
> part shoudl be [re]loaded?

+1. I think we should really give a stab at this first, and *then* see
how we want to patch up the flagging of support on a per-chipset basis.
As-is, you're wasting filesystem space on a duplicate firmware blob,
that we have to make sure gets updated in sync with the combined
firmware every time there's an update.

Proof of the duplicate blob -- the latter portion of the combined FW is
identical to the WLAN-only:

  $ cmp mrvl/pcie{usb8997_combo,8997_wlan}_v4.bin $((0x2919c)); echo $?
  0

Brian
