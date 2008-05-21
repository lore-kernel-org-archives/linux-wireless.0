Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:56229 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954AbYEUPLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 11:11:32 -0400
Received: by rn-out-0910.google.com with SMTP id k40so295927rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 08:11:30 -0700 (PDT)
Message-ID: <1ba2fa240805210811i41eefa21q8f412e44b4425064@mail.gmail.com> (sfid-20080521_171137_533386_147518F3)
Date: Wed, 21 May 2008 18:11:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Helmut Schaa" <hschaa@suse.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"Bruno Randolf" <bruno@thinktube.com>
In-Reply-To: <1211382489.13667.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1ba2fa240805210347w375b571djc922f814fa9f521f@mail.gmail.com>
	 <20080521135451.GA3545@tuxdriver.com>
	 <1ba2fa240805210750x5112a8c3lea2f493f59a50b79@mail.gmail.com>
	 <1211382489.13667.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 6:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> static void ieee80211_rx_bss_put(struct net_device *dev,
>>                                  struct ieee80211_sta_bss *bss)
>> {
>>         struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>>
>>         local_bh_disable();
>>         if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
>>                 local_bh_enable();
>>                 return;
>>         }
>>
>> ---- don't we miss  local_bh_enable(); here or spin_unlock_bh takes
>> care of this ---
>>
>>
>>         __ieee80211_rx_bss_hash_del(dev, bss);
>>         list_del(&bss->list);
>>         spin_unlock_bh(&local->sta_bss_lock);
>
> spin_unlock_bh takes care of it. The local_bh_disable() +
> atomic_dec_and_lock() is like spin_lock_bh() + atomic_dec() just with
> different atomicity guarantees.
>
> johannes
>
OK, thanks for explanation
Tomas
