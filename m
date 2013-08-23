Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:62614 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3HWJm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 05:42:57 -0400
Received: by mail-vb0-f48.google.com with SMTP id w16so270806vbf.35
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 02:42:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377249774.14021.15.camel@jlt4.sipsolutions.net>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	<1377248299-21007-2-git-send-email-k.eugene.e@gmail.com>
	<1377249774.14021.15.camel@jlt4.sipsolutions.net>
Date: Fri, 23 Aug 2013 11:42:56 +0200
Message-ID: <CAFSJ42YsC2qO1iqocfOujZ5TUkKKAQMCiwLxjGZKZW7xy=J=pA@mail.gmail.com> (sfid-20130823_114300_937764_45C47A06)
Subject: Re: [PATCH v2 01/16] wcn36xx: Add main.c
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +static const struct ieee80211_iface_limit if_limits[] = {
>> +     { .max = 2, .types = BIT(NL80211_IFTYPE_STATION) },
>> +     { .max = 1, .types = BIT(NL80211_IFTYPE_AP) },
>> +};
>> +
>> +static const struct ieee80211_iface_combination if_comb = {
>> +     .limits = if_limits,
>> +     .n_limits = ARRAY_SIZE(if_limits),
>> +     .max_interfaces = 2,
>> +     .num_different_channels = 1,
>> +};
>
>> +static int wcn36xx_add_interface(struct ieee80211_hw *hw,
>> +                              struct ieee80211_vif *vif)
>> +{
>> +     struct wcn36xx *wcn = hw->priv;
>> +
>> +     wcn36xx_dbg(WCN36XX_DBG_MAC, "mac add interface vif %p type %d\n",
>> +                 vif, vif->type);
>> +
>> +     wcn->current_vif = (struct wcn36xx_vif *)vif->drv_priv;
>
> If you actually support two interfaces (and that looks more likely now)
> I don't think this "current_vif" makes any sense at all, it'll be
> randomly pointing to one or the other depending on which one was added
> last.
>
>> +static int wcn36xx_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>> +                        struct ieee80211_sta *sta)
>> +{
>> +     struct wcn36xx *wcn = hw->priv;
>> +
>> +     wcn36xx_dbg(WCN36XX_DBG_MAC, "mac sta add vif %p sta %pM\n",
>> +                 vif, sta->addr);
>> +
>> +     wcn->sta = (struct wcn36xx_sta *)sta->drv_priv;
>> +     wcn->aid = sta->aid;
>
> You support more than one interface and AP, but there's no way this code
> can then be correct. It seems to me that you're really only supporting a
> single client interface correctly right now.

Exactly. So far wcn36xx supports only one interface.

-- 
Best regards,
Eugene
