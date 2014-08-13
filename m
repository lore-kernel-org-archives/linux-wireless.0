Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56567 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMLWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 07:22:12 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so7226022wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2014 04:22:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407783114-5469-1-git-send-email-chaitanya.mgit@gmail.com>
References: <1407783114-5469-1-git-send-email-chaitanya.mgit@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 13 Aug 2014 16:51:51 +0530
Message-ID: <CABPxzYK9s=YQZwKEhSiL2st9NPUiPH7i4HhpHXQc8TapONtz9A@mail.gmail.com> (sfid-20140813_132217_202012_A1C07ED5)
Subject: Re: [mac80211] Enforce protected check for unicast robust management frames.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chaitanya T K <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 12, 2014 at 12:21 AM,  <chaitanya.mgit@gmail.com> wrote:
> From: Chaitanya T K <chaitanya.mgit@gmail.com>
>
> Enforce the check for protected field for all unicast
> robust management frames.
>
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> ---
>
> This removed the dependency on the driver to check for protected
> bit, especially for those drivers who believed the API :-).
>
> ---
>
>  net/mac80211/rx.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a8d862f..63e8f3d 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -569,6 +569,9 @@ static int ieee80211_is_unicast_robust_mgmt_frame(struct sk_buff *skb)
>         if (is_multicast_ether_addr(hdr->addr1))
>                 return 0;
>
> +       if (!ieee80211_has_protected(hdr->frame_control))
> +               return 0;
> +
>         return ieee80211_is_robust_mgmt_frame(skb);
>  }
>

Johannes,

Subject is wrong it should be [PATCH] mac8021:, so should i resend it again?
