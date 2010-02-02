Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51464 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0BBPAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 10:00:36 -0500
Date: Tue, 2 Feb 2010 09:31:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andriy Tkachuk <andriy.tkachuk@gmail.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] lib80211: Introduce TKIP_HDR_LEN define for code
	clarity
Message-ID: <20100202143140.GA15782@tuxdriver.com>
References: <4B68084E.7080306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B68084E.7080306@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 02, 2010 at 01:11:10PM +0200, Andriy Tkachuk wrote:
> Introduce TKIP_HDR_LEN define for code clarity (in the same way as
> CCMP_HDR_LEN).
> 
> Also odd len variable (not used) dropped from lib80211_tkip_hdr().
> 
> Signed-off-by: Andriy V. Tkachuk <andrit@ukr.net>
> 
> ---
>  net/wireless/lib80211_crypt_tkip.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/wireless/lib80211_crypt_tkip.c
> b/net/wireless/lib80211_crypt_tkip.c
> index c362873..c4fb4fb 100644
> --- a/net/wireless/lib80211_crypt_tkip.c
> +++ b/net/wireless/lib80211_crypt_tkip.c
> @@ -36,6 +36,8 @@ MODULE_AUTHOR("Jouni Malinen");
>  MODULE_DESCRIPTION("lib80211 crypt: TKIP");
>  MODULE_LICENSE("GPL");
> 
> +#define TKIP_HDR_LEN 8
> +
>  struct lib80211_tkip_data {
>  #define TKIP_KEY_LEN 32
>  	u8 key[TKIP_KEY_LEN];
> @@ -314,13 +316,12 @@ static int lib80211_tkip_hdr(struct sk_buff *skb,
> int hdr_len,

After a quick look, this and the other patch look fine.  But, the
patches are whitespace-damaged.  I can fix these, but in the future
please be sure to use a mailer that does not break lines.  I recommend
mutt and/or 'git send-email'.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
