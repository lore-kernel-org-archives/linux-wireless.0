Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:25740 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYETNLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:11:43 -0400
Received: by el-out-1112.google.com with SMTP id s27so581953ele.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 06:11:42 -0700 (PDT)
Message-ID: <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com> (sfid-20080520_151151_612690_148AAF30)
Date: Tue, 20 May 2008 16:11:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "Helmut Schaa" <hschaa@suse.de>,
	"John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1211288251.6252.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1211288251.6252.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 3:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-05-20 at 15:54 +0300, Tomas Winkler wrote:
>> On Tue, May 20, 2008 at 10:56 AM, Helmut Schaa <hschaa@suse.de> wrote:
>> > Fix a possible NULL pointer dereference in ieee80211_compatible_rates
>> > introduced in the patch "mac80211: fix association with some APs". If no bss
>> > is available just use all supported rates in the association request.
>> >
>> > Signed-off-by: Helmut Schaa <hschaa@suse.de>
>> > ---
>> >
>> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> > index 76ad4ed..3f7f92a 100644
>> > --- a/net/mac80211/mlme.c
>> > +++ b/net/mac80211/mlme.c
>> > @@ -721,7 +721,17 @@ static void ieee80211_send_assoc(struct net_device
>> > *dev,
>> >                        capab |= WLAN_CAPABILITY_PRIVACY;
>> >                if (bss->wmm_ie)
>> >                        wmm = 1;
>> > +
>> > +               /* get all rates supported by the device and the AP as
>> > +                * some APs don't like getting a superset of their rates
>> > +                * in the association request (e.g. D-Link DAP 1353 in
>> > +                * b-only mode) */
>> > +               rates_len = ieee80211_compatible_rates(bss, sband, &rates);
>> > +
>> >                ieee80211_rx_bss_put(dev, bss);
>> > +       } else {
>> > +               rates = ~0;
>> > +               rates_len = sband->n_bitrates;
>> >        }
>> >
>> >        mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
>> > @@ -752,10 +762,7 @@ static void ieee80211_send_assoc(struct net_device
>> > *dev,
>> >        *pos++ = ifsta->ssid_len;
>> >        memcpy(pos, ifsta->ssid, ifsta->ssid_len);
>> >
>> > -       /* all supported rates should be added here but some APs
>> > -        * (e.g. D-Link DAP 1353 in b-only mode) don't like that
>> > -        * Therefore only add rates the AP supports */
>> > -       rates_len = ieee80211_compatible_rates(bss, sband, &rates);
>> > +       /* add all rates which were marked to be used above */
>> >        supp_rates_len = rates_len;
>> >        if (supp_rates_len > 8)
>> >                supp_rates_len = 8;
>> >
>> >
>>
>> I found one  ieee80211_rx_bss_{get,put} imbalance   in
>> ieee80211_sta_join_ibss function
>> That may cause this problem yet it doesn't look like this is the case.
>> ieee80211_sta_join_ibss
>> calls ieee80211_rx_bss_put on 'bss' that it receives as an argument
>> Keep searching.
>
> Hm. Send a patch? :)
>

Searching for the real problem ...

>> I suggest to insert at least some WARN_ON(1) for the else case.
>
> Disagree, not until somebody audits the code. We already know it can
> happen and a WARN() won't help us track it down because it provides no
> additional information (stack trace is useless)

What about printk(KERN_WARN ), The else statement actually means that
something wrong happened.


Tomas
