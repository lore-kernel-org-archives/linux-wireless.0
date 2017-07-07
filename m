Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39700 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750726AbdGGNR5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 09:17:57 -0400
Message-ID: <1499433473.4790.6.camel@sipsolutions.net> (sfid-20170707_151817_286027_2C5CB3B4)
Subject: Re: [PATCH] brcmfmac: fix possible buffer overflow in
 brcmf_cfg80211_mgmt_tx()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org
Date: Fri, 07 Jul 2017 15:17:53 +0200
In-Reply-To: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170707_140140_467929_3104918C)
References: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com>
         (sfid-20170707_140140_467929_3104918C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-07-07 at 13:01 +0100, Arend van Spriel wrote:
> The lower level nl80211 code in cfg80211 ensures that "len" is
> between
> 25 and NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN
> (24) from
> "len" so thats's max of 2280.  However, the action_frame->data[]
> buffer is
> only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy()
> can
> overflow.
> 
> 	memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
> 	       le16_to_cpu(action_frame->len));

Kalle is on vacation for the next 10 days or so.

Linus, since you were involved already, will you apply this directly?

Arend, otherwise please resend including netdev@, so we can ask davem
to pick it up (needs to land in his patchwork).

I guess it should also have a Cc: stable tag, and perhaps a Fixes?

Thanks,
johannes
