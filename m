Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:52540 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754047Ab3JHIgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 04:36:01 -0400
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 26529-01 for <linux-wireless@vger.kernel.org>;
 Tue,  8 Oct 2013 09:35:54 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Subject: RE: [PATCH] mac80211: Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
Date: Tue, 8 Oct 2013 09:33:52 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7379@saturn3.aculab.com> (sfid-20131008_103611_932907_DFDC8553)
In-Reply-To: <1381190953-6362-1-git-send-email-duanj.fnst@cn.fujitsu.com>
References: <1381190953-6362-1-git-send-email-duanj.fnst@cn.fujitsu.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: <djduanjiong@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	"Duan Jiong" <duanj.fnst@cn.fujitsu.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> ---
>  net/mac80211/key.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index 620677e..3e51dd7 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -879,7 +879,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
>  				  keyconf->keylen, keyconf->key,
>  				  0, NULL);
>  	if (IS_ERR(key))
> -		return ERR_PTR(PTR_ERR(key));
> +		return ERR_CAST(key);

I suspect the old code is a deliberate attempt to indicate that it
the error value that is being returned rather than the pointer.

Looking higher up that file there seems to be a fubar when setting
up the TKIP key.
It seems to put the same 6 bytes into every TID.
(I'm sure seq_len shouldn't be ignored either.0

	David


