Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36115 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbdDCNQU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 09:16:20 -0400
Date: Mon, 3 Apr 2017 15:16:16 +0200
From: Johan Hovold <johan@kernel.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Johan Hovold <johan@kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 1/2] wireless: ath9k_htc: fix NULL-deref at probe
Message-ID: <20170403131616.GA3119@localhost> (sfid-20170403_151711_033740_4751ADBC)
References: <20170313124421.28587-1-johan@kernel.org>
 <20170403084213.GE25742@localhost>
 <87shlpomvx.fsf@kamboji.qca.qualcomm.com>
 <87k271myos.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k271myos.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 03, 2017 at 01:02:28PM +0000, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> > Johan Hovold <johan@kernel.org> writes:
> >
> >> On Mon, Mar 13, 2017 at 01:44:20PM +0100, Johan Hovold wrote:
> >>> Make sure to check the number of endpoints to avoid dereferencing a
> >>> NULL-pointer or accessing memory beyond the endpoint array should a
> >>> malicious device lack the expected endpoints.
> >>> 
> >>> Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
> >>> Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> >>> Signed-off-by: Johan Hovold <johan@kernel.org>
> >>
> >> Is this one still in your queue, Kalle?
> >
> > Yes, I'm just lacking behing:
> >
> > https://patchwork.kernel.org/patch/9620723/
> 
> Meant "lagging" of course. Mondays..
> 
> >> As I mentioned earlier, I should have added a
> >>
> >> Cc: stable <stable@vger.kernel.org>     # 2.6.39
> >>
> >> but left it out as I mistakingly thought the net recommendations to do
> >> so applied also to wireless.
> >
> > Ok, I'll add that.
> 
> But is 2.6.39 really correct? Shouldn't it be 2.6.39+ so that it means
> all versions since 2.6.39?

Either way is fine, the stable maintainers apply them to all later
versions.

I notice now that adding a plus sign is more common, but it's still a
1:2 ratio judging from quick grep, while the stable-kernel-rules.rst
actually uses a minus sign...

Thanks,
Johan
