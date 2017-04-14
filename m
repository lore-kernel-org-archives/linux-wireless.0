Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34005 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdDNQzj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 12:55:39 -0400
Received: by mail-pg0-f42.google.com with SMTP id 21so45689132pgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2017 09:55:38 -0700 (PDT)
Date: Fri, 14 Apr 2017 09:55:35 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: Re: Re: [PATCH v3 4/4] mwifiex: pcie: extract wifi part from
 combo firmware during function level reset
Message-ID: <20170414165534.GA102425@google.com> (sfid-20170414_185542_692069_8CA78751)
References: <1491815374-6555-1-git-send-email-huxinming820@gmail.com>
 <1491815374-6555-4-git-send-email-huxinming820@gmail.com>
 <20170411013724.GA135531@google.com>
 <45a8fcd4f0384fa7b622cf3a87b41ea8@SC-EXCH02.marvell.com>
 <20170413174954.GA66124@google.com>
 <111627ea9fbd477e83622e8df51f109b@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <111627ea9fbd477e83622e8df51f109b@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Apr 14, 2017 at 03:28:28AM +0000, Xinming Hu wrote:
> According to the firmware download protocol, every CMD should not exceed MWIFIEX_UPLD_SIZE.
> we can add a sanity check , like,
> if (data_len > MWIFIEX_UPLD_SIZE - sizeof(fwdata->header))
> 	*error*

I was primarily interested in protecting the kernel itself. Once the
kernel starts parsing the firmware, we have to make sure a bad firmware
file won't end up with us looping infinitely, reading/writing invalid
memory, or otherwise exposing security or stability issues. I wasn't
necessarily interested in validating every requirement of the end-point
device. For example, we're not bothering checking the CRCs. I figured that
this was all the job of your Wifi card's boot ROM.

So, we *can* implement checks like this, but I'd really hope we don't
need this particular one, because your card should be taking care of
that.

Please consider reviewing my latest submission.

Regards,
Brian
