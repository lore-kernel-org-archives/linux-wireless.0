Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35006 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759293AbdCVMsX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 08:48:23 -0400
Date: Wed, 22 Mar 2017 13:45:48 +0100
From: Johan Hovold <johan@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johan Hovold <johan@kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2/2] zd1211rw: fix NULL-deref at probe
Message-ID: <20170322124548.GC10130@localhost> (sfid-20170322_135046_633752_E3DF57C3)
References: <20170313124421.28587-2-johan@kernel.org>
 <20170322090415.BE414609FF@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170322090415.BE414609FF@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 22, 2017 at 09:04:15AM +0000, Kalle Valo wrote:
> Johan Hovold <johan@kernel.org> wrote:
> > Make sure to check the number of endpoints to avoid dereferencing a
> > NULL-pointer or accessing memory beyond the endpoint array should a
> > malicious device lack the expected endpoints.
> > 
> > Fixes: a1030e92c150 ("[PATCH] zd1211rw: Convert installer CDROM device into WLAN device")
> > Cc: Daniel Drake <dsd@gentoo.org>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 
> ca260ece6a57 zd1211rw: fix NULL-deref at probe

What about patch 1/2 which fixes the same bug (literally copied from the
zd1211rw driver)?

And as these fixes should be backported to stable (I left out the tag
for networking drivers), why only apply to -next?

Thanks,
Johan
