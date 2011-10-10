Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:33989 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab1JJT0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:26:00 -0400
Received: by bkbzv15 with SMTP id zv15so8836020bkb.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:25:58 -0700 (PDT)
Subject: Re: [PATCH 05/29] wl12xx: move bitrate_masks into wlvif
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEejP2iELFGd+s+-4fBPTxDk_iuNPhU1AZdmCxneBKGF-Q@mail.gmail.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-6-git-send-email-eliad@wizery.com>
	 <1318270806.9690.373.camel@cumari>
	 <CAB3XZEejP2iELFGd+s+-4fBPTxDk_iuNPhU1AZdmCxneBKGF-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 22:25:55 +0300
Message-ID: <1318274755.9690.400.camel@cumari> (sfid-20111010_212604_780848_80B113C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 21:21 +0200, Eliad Peller wrote: 
> On Mon, Oct 10, 2011 at 8:20 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote:
> >> move bitrate_masks into the per-interface data, rather than
> >> being global.
> >>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> ---
> >
> > [...]
> >
> >> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> >> index 102a8a5..ff653e8 100644
> >> --- a/drivers/net/wireless/wl12xx/cmd.c
> >> +++ b/drivers/net/wireless/wl12xx/cmd.c
> >> @@ -1111,15 +1111,16 @@ out:
> >>       return ret;
> >>  }
> >>
> >> -int wl1271_cmd_build_probe_req(struct wl1271 *wl,
> >> +int wl1271_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
> >>                              const u8 *ssid, size_t ssid_len,
> >>                              const u8 *ie, size_t ie_len, u8 band)
> >
> > If struct wl12xx_vif contains a pointer to wl, can't you pass only wlvif
> > to all these functions instead of passing both?
> >
> yes, it's possible.
> but maybe leave it for some future overhaul?

Yes, it's okay.  Otherwise the rebasing of this would be annoying to
do. ;)


-- 
Cheers,
Luca.

