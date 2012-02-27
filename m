Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34162 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2B0X0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:26:47 -0500
Date: Mon, 27 Feb 2012 13:23:13 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 3.3] mwifiex: reset encryption mode flag before
 association
Message-ID: <20120227182312.GB26664@tuxdriver.com> (sfid-20120228_002722_937827_5A161971)
References: <1330148136-28867-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330148136-28867-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 24, 2012 at 09:35:35PM -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Recent commit
> "mwifiex: clear previous security setting during association"
> fixes association failure problems observed in some corner cases
> by clearing previous security setting before each association.
> 
> We should reset encryption mode flag as well. This patch takes care
> of it.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index 8d8ee63..e4e6d7d 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -872,6 +872,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
>  	priv->sec_info.wpa_enabled = false;
>  	priv->sec_info.wpa2_enabled = false;
>  	priv->wep_key_curr_index = 0;
> +	priv->sec_info.encryption_mode = 0;
>  	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);
>  
>  	if (mode == NL80211_IFTYPE_ADHOC) {

What bug does this fix?  Does it need to be fixed in 3.3?  Or can it wait for 3.4?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
