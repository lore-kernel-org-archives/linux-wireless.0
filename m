Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:63896 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYI2IO5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 04:14:57 -0400
Received: by yx-out-2324.google.com with SMTP id 8so293466yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 01:14:56 -0700 (PDT)
Message-ID: <43e72e890809290114w5010c397od3d17101db263109@mail.gmail.com> (sfid-20080929_101502_449678_57475562)
Date: Mon, 29 Sep 2008 01:14:56 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS mode
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 28, 2008 at 9:14 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> This patch makes mac80211 able to send action frames when toggling
> (SM PS) Spacial Multiplexing Power Save mode.

I have no clue what this is as I haven't yet peeked at this section of
the draft. If we can provide a brief explanation as to what this is
would be useful to other developers without access to the 11n draft.
Even it its just enhancing the comment in the code.

> Example:
> 1.
> Low lever driver may close some of RX chains in power save mode
> and needs to announce to AP that a RTS frame is need in order to wake all
> RX chains, on other hand SM PS can be disabled on CAM mode

What's CAM mode?

> or if HW is able
> to wake all chains without RTS frame.

Should we add a HW capability bit for mac80211 drivers to indicate this?

> 2.
> iwlwifi can call this function when it detects that only
> one antenna can effectively receive

When would this happen? Would this happen when any 11n mac80211
capable driver is going to PS mode and it doesn't have the capability
of detecting when it needs to to turn on its antennas?

> then MS PS

Did you mean SM PS mode?

> mode is set to STATIC

Can we elaborate a bit on what this vs Dynamic is in the comments if possible?


> +static void ieee80211_send_sm_ps(struct ieee80211_sub_if_data *sdata, u8 mode)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_mgmt *mgmt;
> +       struct sk_buff *skb;
> +       DECLARE_MAC_BUF(mac);
> +
> +       struct ieee80211_if_sta *ifsta = &sdata->u.sta;
> +       struct net_device *dev = sdata->dev;
> +
> +       /* Implemented for STA only */
> +       if (sdata->vif.type != NL80211_IFTYPE_STATION)
> +               return;

<-- snip -->

> +       if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
> +               ieee80211_tx_skb(sdata, skb, 0);

You can move this ending branch above to return early so we don't go
through the entire routine for no good reason. So something like:

       if (sdata->vif.type != NL80211_IFTYPE_STATION ||
                      ifsta->flags & IEEE80211_STA_ASSOCIATED)
               return;

  Luis
