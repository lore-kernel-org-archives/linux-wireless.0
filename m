Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41412 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbaCEME7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:04:59 -0500
Received: by mail-oa0-f44.google.com with SMTP id n16so912553oag.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 04:04:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1394017904-4012-3-git-send-email-luca@coelho.fi>
References: <1394017904-4012-1-git-send-email-luca@coelho.fi>
	<1394017904-4012-3-git-send-email-luca@coelho.fi>
Date: Wed, 5 Mar 2014 13:04:59 +0100
Message-ID: <CA+BoTQkb95xGNtVUxvn_u==P6fuy-h0iNAp8pGEcq8m0ZUm-7A@mail.gmail.com> (sfid-20140305_130508_092518_FAFF6457)
Subject: Re: [PATCH v5 2/3] mac80211: implement chanctx reservation
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 March 2014 12:11, Luca Coelho <luca@coelho.fi> wrote:

[...]

> +       /* unref our reservation before assigning */
> +       ctx->refcount--;
> +       sdata->reserved_chanctx = NULL;
> +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> +       if (ret) {
> +               /* if assign fails refcount stays the same */
> +               if (ctx->refcount == 0)
> +                       ieee80211_free_chanctx(local, ctx);
> +               goto out_wake;
> +       }

This actually won't work if there are AP VLANs (I noticed that yesterday).

You can't call ieee80211_vif_copy_chanctx_to_vlans() here due to
current locking requirements. I have a patch for that though ;-) I'll
send it soon.


Michał
