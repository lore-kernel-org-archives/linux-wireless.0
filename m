Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:31185 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYEUOvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 10:51:12 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1669452ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 07:50:49 -0700 (PDT)
Message-ID: <1ba2fa240805210750x5112a8c3lea2f493f59a50b79@mail.gmail.com> (sfid-20080521_165115_921412_1E7E5CD2)
Date: Wed, 21 May 2008 17:50:48 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "Helmut Schaa" <hschaa@suse.de>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"Bruno Randolf" <bruno@thinktube.com>
In-Reply-To: <20080521135451.GA3545@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1ba2fa240805210347w375b571djc922f814fa9f521f@mail.gmail.com>
	 <20080521135451.GA3545@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 4:54 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, May 21, 2008 at 01:47:04PM +0300, Tomas Winkler wrote:
>> On Tue, May 20, 2008 at 3:54 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>
>> > I found one  ieee80211_rx_bss_{get,put} imbalance   in
>> > ieee80211_sta_join_ibss function
>> > That may cause this problem yet it doesn't look like this is the case.
>> > ieee80211_sta_join_ibss
>> > calls ieee80211_rx_bss_put on 'bss' that it receives as an argument
>>
>> The patch below introduced  _get/_put imbalance. ieee80211_rx_bss_info
>> _put bss back at the end. Other callers of the ieee80211_sta_join_ibss
>> function don't use put.
>> I will post a patch that takes out the _put out of
>> ieee80211_rx_bss_info, I think it's more readable.
>
> Since you are doing _get and _add in ieee80211_rx_bss_info, it makes
> sense to me to do _put at the end of it.  Perhaps we should remove
> the _put from the end of ieee80211_sta_join_ibss and change it's
> callers instead?

That what I meant I've just pasted wrong function name into the mail
(was lazy typing)

Maybe someone can answer this


static void ieee80211_rx_bss_put(struct net_device *dev,
                                 struct ieee80211_sta_bss *bss)
{
        struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);

        local_bh_disable();
        if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
                local_bh_enable();
                return;
        }

---- don't we miss  local_bh_enable(); here or spin_unlock_bh takes
care of this ---


        __ieee80211_rx_bss_hash_del(dev, bss);
        list_del(&bss->list);
        spin_unlock_bh(&local->sta_bss_lock);
        ieee80211_rx_bss_free(bss);
}

Thanks
Tomas


> John
> --
> John W. Linville
> linville@tuxdriver.com
>
