Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:60559 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3HFKkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 06:40:04 -0400
Received: by mail-ob0-f178.google.com with SMTP id ef5so398355obb.23
        for <linux-wireless@vger.kernel.org>; Tue, 06 Aug 2013 03:40:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net>
References: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 6 Aug 2013 13:40:04 +0300
Message-ID: <CAB3XZEeYvi=i5crLsMKNhgbctPhU9BjEF=DTsHdickssRM480A@mail.gmail.com> (sfid-20130806_124014_195432_4FA74DB7)
Subject: Re: [PATCH] mac80211: add control port protocol TX control flag
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 6, 2013 at 12:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> A lot of drivers check the frame protocol for ETH_P_PAE,
> for various reasons (like making those more reliable).
> Add a new flags bitmap to the TX control info and a new
> flag indicating the control port protocol is in use to
> let all drivers also apply such logic to other control
> port protocols, should they be configured.
>
> Change-Id: I292ba4865694142670f005856b6320f7f3fa05c8
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
> index 4491c1c..9f43fb9 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
> @@ -33,9 +33,10 @@
>  static inline bool iwl_trace_data(struct sk_buff *skb)
>  {
>         struct ieee80211_hdr *hdr = (void *)skb->data;
> +       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>
>         if (ieee80211_is_data(hdr->frame_control))
> -               return skb->protocol != cpu_to_be16(ETH_P_PAE);
> +               return info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
>         return false;
>  }
this looks reversed...

Eliad.
