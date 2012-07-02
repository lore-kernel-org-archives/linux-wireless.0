Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab2GBI1F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 04:27:05 -0400
Date: Mon, 2 Jul 2012 10:26:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [RFT] iwlegacy: don't mess up the SCD when removing a key
Message-ID: <20120702082653.GA2479@redhat.com> (sfid-20120702_102710_329519_0E161473)
References: <1341148023-17673-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341148023-17673-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 01, 2012 at 04:07:03PM +0300, Emmanuel Grumbach wrote:
> diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
> index d24eaf8..9981f09 100644
> --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> @@ -3420,7 +3420,7 @@ il4965_remove_dynamic_key(struct il_priv *il,
>  	memset(&il->stations[sta_id].sta.key, 0, sizeof(struct il4965_keyinfo));
>  	il->stations[sta_id].sta.key.key_flags =
>  	    STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
> -	il->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
> +	il->stations[sta_id].sta.key.key_offset = keyconf->hw_key_idx;

Thanks for the patch. Just small issue with it. We use key_offset to
check if the key is invalid on the below code:

        if (il->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
                IL_WARN("Removing wrong key %d 0x%x\n", keyconf->keyidx,
                        key_flags);
                spin_unlock_irqrestore(&il->sta_lock, flags);
                return 0;
        }

Since you changed the key_offset, above check should be changed as well,
probably using STA_KEY_FLG_INVALID flag.

Stanislaw 
 
