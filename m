Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36838 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbcKIWWU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 17:22:20 -0500
Received: by mail-pf0-f177.google.com with SMTP id 189so133707452pfz.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2016 14:22:20 -0800 (PST)
Date: Wed, 9 Nov 2016 14:22:17 -0800
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, security@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mwifiex: printk() overflow with 32-byte SSIDs
Message-ID: <20161109222216.GA3818@google.com> (sfid-20161109_232242_725685_17B74EEF)
References: <1478658504-31045-1-git-send-email-briannorris@chromium.org>
 <87h97guwfu.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87h97guwfu.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 10, 2016 at 12:20:53AM +0200, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> writes:
> 
> > SSIDs aren't guaranteed to be 0-terminated. Let's cap the max length
> > when we print them out.
> >
> > This can be easily noticed by connecting to a network with a 32-octet
> > SSID:
> >
> > [ 3903.502925] mwifiex_pcie 0000:01:00.0: info: trying to associate to
> > '0123456789abcdef0123456789abcdef <uninitialized mem>' bssid
> > xx:xx:xx:xx:xx:xx
> >
> > Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
> > Cc: <stable@vger.kernel.org>
> 
> I'm planning to push this to 4.9 if no objections.

SGTM. Thanks.
