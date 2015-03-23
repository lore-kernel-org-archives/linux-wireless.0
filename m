Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1746 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbbCWNYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 09:24:15 -0400
Date: Mon, 23 Mar 2015 15:24:09 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: mac80111: Add BIP-GMAC-128 and BIP-GMAC-256 ciphers
Message-ID: <20150323132409.GA20999@jouni.qca.qualcomm.com> (sfid-20150323_142422_636055_5B812628)
References: <20150319125314.GA15250@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150319125314.GA15250@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2015 at 03:53:14PM +0300, Dan Carpenter wrote:
> The patch 8ade538bf39b: "mac80111: Add BIP-GMAC-128 and BIP-GMAC-256
> ciphers" from Jan 24, 2015, leads to the following static checker
> warning:

> net/mac80211/aes_gmac.c
>     61  struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],

>     71          err = crypto_aead_setkey(tfm, key, key_len);
>     72          if (!err)
>                     ^^^^
> This is success handling.  In the kernel, everyone expects error
> hanlding like "if (err) " so this makes the code hard to read if you
> have a job and need to read code quickly.  At first I missed the "!"
> character, and then I thought,  "What??  Is err a pointer?"

This follows the style used in net/mac80211/aes_ccm.c for an equivalent
key_setup function. I have no issues in someone cleaning that up as long
as it is done consistently through all net/mac80211 key_setup functions.

>     73                  return tfm;
>     74          if (!err)
>     75                  err = crypto_aead_setauthsize(tfm, GMAC_MIC_LEN);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This is dead code.

That's interesting.. This must be some kind of rebasing issue since this
obviously makes no sense. Lines 72-73 were supposed to be after this
line 75 just like this is done in aes_gcm.c and aes_ccm.c. Thanks for
reporting this, I'll fix it.

>     77          crypto_free_aead(tfm);
>     78          return ERR_PTR(err);
> 
> This function should be a list of commands in a row with tiny detours
> for exceptions and error handling.  It messes everyone up if the success
> path is hidden somewhere in the middle and it leads to bugs like this.

I'm not sure that would be behind this specific bug, but like noted
above, no objection to someone cleaning this up consistently.

-- 
Jouni Malinen                                            PGP id EFC895FA
