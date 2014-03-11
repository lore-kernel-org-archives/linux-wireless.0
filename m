Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36326 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaCKLaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 07:30:30 -0400
Received: by mail-ob0-f171.google.com with SMTP id wn1so8363415obc.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 04:30:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394176178-8504-1-git-send-email-michal.kazior@tieto.com>
References: <1394176178-8504-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 11 Mar 2014 12:30:30 +0100
Message-ID: <CA+BoTQkVfgkMR_cvv5dUNkzLd7KrDQ7VMYKucJybpF0aAWpESA@mail.gmail.com> (sfid-20140311_123033_841466_52AA6F38)
Subject: Re: [PATCH] mac80211: fix possible NULL dereference
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 March 2014 08:09, Michal Kazior <michal.kazior@tieto.com> wrote:
> If chanctx is missing on a given vif then the band
> is assumed to be 2GHz. However if hw doesn't
> support 2GHz band then mac80211 ended up with a
> NULL dereference.
>
> This fixes a splat:
>
> [ 4605.207223] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> [ 4605.210789] IP: [<ffffffffa07b5635>] ieee80211_parse_bitrates+0x65/0x110 [mac80211]
>
> The splat was preceeded by WARN_ON(!chanctx_conf)
> in ieee80211_get_sdata_band().
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---

Drop this, please. There are more places that need sband to be
NULL-checked. I'll send out a more thorough patch later.


Michał
