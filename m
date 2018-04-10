Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753411AbeDJOf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 10:35:27 -0400
Message-ID: <93556893316dba0f85be071976ab8c047f0d4aa8.camel@redhat.com> (sfid-20180410_163601_733119_FBBF3C1C)
Subject: Re: [v2 PATCH] mwifiex: parse key management suite from RSN IE
From: Dan Williams <dcbw@redhat.com>
To: Xinming Hu <huxm@marvell.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Date: Tue, 10 Apr 2018 09:35:24 -0500
In-Reply-To: <c4107389ed724cfeb7bda632cea95c46@SC-EXCH02.marvell.com>
References: <1523260191-29352-1-git-send-email-huxm@marvell.com>
         <87o9isr6v5.fsf@codeaurora.org>
         <c4107389ed724cfeb7bda632cea95c46@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-04-10 at 02:19 +0000, Xinming Hu wrote:
> Hi Kalle,
> 
> > -----Original Message-----
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > Sent: 2018年4月9日 18:51
> > To: Xinming Hu <huxm@marvell.com>
> > Cc: Linux Wireless <linux-wireless@vger.kernel.org>; Brian Norris
> > <briannorris@chromium.org>; Dmitry Torokhov <dtor@google.com>;
> > rajatja@google.com; Zhiyuan Yang <yangzy@marvell.com>; Tim Song
> > <songtao@marvell.com>; Cathy Luo <cluo@marvell.com>; James Cao
> > <jcao@marvell.com>; Ganapathi Bhat <gbhat@marvell.com>; Ellie
> > Reeves
> > <ellierevves@gmail.com>
> > Subject: Re: [v2 PATCH] mwifiex: parse key management suite from
> > RSN IE
> > 
> > Xinming Hu <huxm@marvell.com> writes:
> > 
> > > Association failed when using wpa_supplicant with configuration
> > > key_mgmt=WPA-PSK-SHA256, and it is noticed that wpa_supplicant
> > > set
> > > WLAN_AKM_SUITE_PSK_SHA256 in RSN IE, but miss it in start_ap
> > > parameters.
> > > 
> > > This patch parse key management suite from RSN IE, in case it is
> > > missed.
> > > 
> > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > 
> > Shouldn't you fix wpa_supplicant instead of adding a workaround to
> > the driver?
> > 
> 
> Yes, I am preparing a wpa_supplicant fix on this.
> Even so, driver fix is still need to compatible with old
> wpa_supplicant stable release

Typically the kernel does not add hacks to work around userspace
software bugs.  The userspace software needs to be fixed and upgraded.

Dan
