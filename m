Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:8686 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYIHWIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 18:08:22 -0400
Received: by yx-out-2324.google.com with SMTP id 8so944104yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 15:08:20 -0700 (PDT)
Message-ID: <1ba2fa240809081508jd762ac6q9d8505879711d151@mail.gmail.com> (sfid-20080909_000827_571555_D4EEC5D1)
Date: Tue, 9 Sep 2008 01:08:17 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 4/4] mac80211: stop queues before carrier off
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220910240.9427.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080908153336.891710000@sipsolutions.net>
	 <20080908153510.167807000@sipsolutions.net>
	 <1ba2fa240809081440o2c88eaa7o1e120fe75c018b9e@mail.gmail.com>
	 <1220910240.9427.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 12:44 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Tue, 2008-09-09 at 00:40 +0300, Tomas Winkler wrote:
>> On Mon, Sep 8, 2008 at 6:33 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > During testing of the disassociation fixes, Tomas noticed that it
>> > was possible to run into a situation where you'd suddenly get a
>> > few "wlan0: dropped frame to <AP> (unauthorized port)" messages
>> > and I found this to be due to the AP's sta_info having been
>> > removed but netif_carrier_off not having removed/stopped traffic
>> > yet. To avoid that, stop the queue for the interface (and avoid
>> > bringing them up when another vif scans when they weren't up.)
>> >
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>>
>> It worked as far as I tested... ACK then.
>> I foolishly tried to switch APs with NM... With sadness I have to say that
>> we are now where other operating systems were 5 years ago
>
> need... cfg80211...
Correct

Anyway, was there some problem with NM here?

I've added manually two APs one with security enabled
(WPA2-Personal/CCMP) second open.
I was not able to connect to the open AP with NM it ask for a key.

When I want to connect to hidden ssid I have to manually scan for it
with iwlist wlan0 essid <SSID>, but that's rather old problem I guess.

The GUI has conceptual problem that it trying to connect something in
scan list (Wireless Networks - right click) instead to what we call a
profile (managed list of netrwork connection in NM language)
It has to be other way around. It should be possible to create a
profile form an entry in thes scan list and connect this specific
profile and not clicking on the entry of an scan list.

Even wpa supplicant works with profiles so why not the GUI?

Thanks
Tomas

>
> Dan
>
>> Tomas
>>
>>
>> > ---
>> >  net/mac80211/mlme.c |   26 +++++++++++++++++---------
>> >  1 file changed, 17 insertions(+), 9 deletions(-)
>> >
>> > --- everything.orig/net/mac80211/mlme.c 2008-09-08 16:39:59.000000000 +0200
>> > +++ everything/net/mac80211/mlme.c      2008-09-08 16:40:03.000000000 +0200
>> > @@ -429,6 +429,7 @@ static void ieee80211_set_associated(str
>> >        sdata->bss_conf.assoc = 1;
>> >        ieee80211_bss_info_change_notify(sdata, changed);
>> >
>> > +       netif_tx_start_all_queues(sdata->dev);
>> >        netif_carrier_on(sdata->dev);
>> >
>> >        ieee80211_sta_send_apinfo(sdata, ifsta);
>> > @@ -850,6 +851,7 @@ static void ieee80211_set_disassoc(struc
>> >        ifsta->assoc_scan_tries = 0;
>> >        ifsta->assoc_tries = 0;
>> >
>> > +       netif_tx_stop_all_queues(sdata->dev);
>> >        netif_carrier_off(sdata->dev);
>> >
>> >        ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
>> > @@ -3269,6 +3271,7 @@ static void ieee80211_sta_reset_auth(str
>> >        ifsta->direct_probe_tries = 0;
>> >        ifsta->auth_tries = 0;
>> >        ifsta->assoc_tries = 0;
>> > +       netif_tx_stop_all_queues(sdata->dev);
>> >        netif_carrier_off(sdata->dev);
>> >  }
>> >
>> > @@ -3745,13 +3748,15 @@ void ieee80211_scan_completed(struct iee
>> >        rcu_read_lock();
>> >        list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>> >                /* Tell AP we're back */
>> > -               if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
>> > -                   sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
>> > -                       ieee80211_send_nullfunc(local, sdata, 0);
>> > +               if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
>> > +                       if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
>> > +                               ieee80211_send_nullfunc(local, sdata, 0);
>> > +                               netif_tx_wake_all_queues(sdata->dev);
>> > +                       }
>> > +               } else
>> > +                       netif_tx_wake_all_queues(sdata->dev);
>> >
>> >                ieee80211_restart_sta_timer(sdata);
>> > -
>> > -               netif_wake_queue(sdata->dev);
>> >        }
>> >        rcu_read_unlock();
>> >
>> > @@ -3909,10 +3914,13 @@ static int ieee80211_sta_start_scan(stru
>> >
>> >        rcu_read_lock();
>> >        list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>> > -               netif_stop_queue(sdata->dev);
>> > -               if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
>> > -                   (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED))
>> > -                       ieee80211_send_nullfunc(local, sdata, 1);
>> > +               if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
>> > +                       if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
>> > +                               netif_tx_stop_all_queues(sdata->dev);
>> > +                               ieee80211_send_nullfunc(local, sdata, 1);
>> > +                       }
>> > +               } else
>> > +                       netif_tx_stop_all_queues(sdata->dev);
>> >        }
>> >        rcu_read_unlock();
>> >
>> >
>> > --
>> >
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
