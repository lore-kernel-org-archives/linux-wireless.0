Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34156 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2B0X0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:26:47 -0500
Date: Mon, 27 Feb 2012 13:23:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 3.3] mwifiex: remove redundant scan operation
Message-ID: <20120227182333.GC26664@tuxdriver.com> (sfid-20120228_002725_121821_8863E712)
References: <1330148136-28867-1-git-send-email-bzhao@marvell.com>
 <1330148136-28867-2-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330148136-28867-2-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 24, 2012 at 09:35:36PM -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> It should have been removed by commit "mwifiex: use cfg80211 dynamic
> scan..." (7c6fa2a843..) after adding code to avoid an extra scan
> during association because scan entries are valid for 15 seconds in
> cfg80211 stack.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index e4e6d7d..7b98ce0 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -924,12 +924,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
>  		}
>  	}
>  done:
> -	/* Do specific SSID scanning */
> -	if (mwifiex_request_scan(priv, &req_ssid)) {
> -		dev_err(priv->adapter->dev, "scan error\n");
> -		return -EFAULT;
> -	}
> -
>  	/*
>  	 * Scan entries are valid for some time (15 sec). So we can save one
>  	 * active scan time if we just try cfg80211_get_bss first. If it fails

It seems like this could wait to be fixed in 3.4?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
