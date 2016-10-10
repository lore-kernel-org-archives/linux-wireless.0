Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34376 "EHLO
        mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752354AbcJJXyx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 19:54:53 -0400
Received: by mail-pa0-f45.google.com with SMTP id rz1so3551343pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2016 16:54:53 -0700 (PDT)
Date: Mon, 10 Oct 2016 16:54:50 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161010235449.GB19969@localhost> (sfid-20161011_015456_165691_070D691F)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <20161004215814.GB31652@localhost>
 <8ec683dc72a746909157fca4dcbd10e8@SC-EXCH04.marvell.com>
 <20161005163024.GA54237@google.com>
 <127198026f5149c783bb0f5855dc87b9@SC-EXCH04.marvell.com>
 <CAKdAkRTKo3JVJPamM44jyG6QuHoQB89FMKj5vo3-z6T+XH1W9Q@mail.gmail.com>
 <20161010234708.GA19969@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161010234708.GA19969@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I think Dmitry noticed the same while I wrote this.)

On Mon, Oct 10, 2016 at 04:47:08PM -0700, Brian Norris wrote:
> [*] The other cases are in error handling cases. I guess I should make
> sure those didn't race too...

Ah, well I think I missed one case:

For the async FW request code path, the callback mwifiex_fw_dpc() can
fail to load FW, and so it unwinds with:

        if (adapter->if_ops.unregister_dev)
                adapter->if_ops.unregister_dev(adapter);

This all happens after probe() is finished, so we can have a race on
card->adapter being read in suspend() and written in the $subject patch.

Can I revoke my Reviewed-by? (Or make it Reviewed-and-found-wanting-by?)

Brian
