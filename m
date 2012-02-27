Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:60026 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab2B0Xru convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:47:50 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 27 Feb 2012 15:47:32 -0800
Subject: RE: [PATCH 3.3] mwifiex: remove redundant scan operation
Message-ID: <477F20668A386D41ADCC57781B1F70430836762847@SC-VEXCH1.marvell.com> (sfid-20120228_004753_182640_44378963)
References: <1330148136-28867-1-git-send-email-bzhao@marvell.com>
 <1330148136-28867-2-git-send-email-bzhao@marvell.com>
 <20120227182333.GC26664@tuxdriver.com>
In-Reply-To: <20120227182333.GC26664@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> Subject: Re: [PATCH 3.3] mwifiex: remove redundant scan operation
> 
> On Fri, Feb 24, 2012 at 09:35:36PM -0800, Bing Zhao wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> >
> > It should have been removed by commit "mwifiex: use cfg80211 dynamic
> > scan..." (7c6fa2a843..) after adding code to avoid an extra scan
> > during association because scan entries are valid for 15 seconds in
> > cfg80211 stack.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > ---
> >  drivers/net/wireless/mwifiex/cfg80211.c |    6 ------
> >  1 files changed, 0 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> > index e4e6d7d..7b98ce0 100644
> > --- a/drivers/net/wireless/mwifiex/cfg80211.c
> > +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> > @@ -924,12 +924,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
> >  		}
> >  	}
> >  done:
> > -	/* Do specific SSID scanning */
> > -	if (mwifiex_request_scan(priv, &req_ssid)) {
> > -		dev_err(priv->adapter->dev, "scan error\n");
> > -		return -EFAULT;
> > -	}
> > -
> >  	/*
> >  	 * Scan entries are valid for some time (15 sec). So we can save one
> >  	 * active scan time if we just try cfg80211_get_bss first. If it fails
> 
> It seems like this could wait to be fixed in 3.4?

Yes, this one can be applied for 3.4.

Thanks,
Bing

