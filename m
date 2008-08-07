Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44158 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYHGXPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 19:15:34 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
Date: Fri, 8 Aug 2008 01:18:19 +0200
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net> <200808071727.19129.chunkeey@web.de> <489B1BDE.6070203@lwfinger.net>
In-Reply-To: <489B1BDE.6070203@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808080118.20011.chunkeey@web.de> (sfid-20080808_011538_035931_42CF02F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 August 2008 17:59:26 Larry Finger wrote:
> Chr wrote:
> > On Thursday 07 August 2008 15:27:51 Johannes Berg wrote:
> >>> +			priv->tx_stats[le32_to_cpu(entry_data->frame_type - 4)].len--;
> >>
> >> Sorry for not catching this earlier, but this looks wrong, the -4 surely
> >> should be outside the endian conversion?
> >
> > likely... let's do the job properly for once and for all.
> > --
> >
> > This patch fixes not only the regression which has sneaked in
> > with commit b19fa1f, but also provides some extra code for
> > cts rates.
> >
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
>
> Is the extra code for cts rates a bug fix or a feature enhancement? If the
> latter, then this patch should be in two parts. The main reason is that
> fixes should go to stable as well as wireless-testing.
>
The old logic always tx'ed cts frames (if enabled) with a
short preamble when [rate > 3]. (read: with any 802.11g rate).
Of course this isn't that bad, but it's still wrong!

Regards,
	Chr
