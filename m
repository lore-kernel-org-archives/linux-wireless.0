Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.189]:17426 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYIHJGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:06:42 -0400
Received: by gv-out-0910.google.com with SMTP id e6so165869gvc.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 02:06:40 -0700 (PDT)
Message-ID: <1ba2fa240809080206u42908ef6yc6641435d747155a@mail.gmail.com> (sfid-20080908_110646_471169_8A8790F2)
Date: Mon, 8 Sep 2008 12:06:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220864314.31304.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220863139.31304.33.camel@johannes.berg>
	 <1ba2fa240809080146o93200eetcf8e142f6ef4a2b1@mail.gmail.com>
	 <1220864314.31304.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 11:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 11:46 +0300, Tomas Winkler wrote:
>> On Mon, Sep 8, 2008 at 11:38 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Mon, 2008-09-08 at 02:14 +0300, Tomas Winkler wrote:
>> >
>> >> Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this
>> >> before.
>> >
>> > The other question is whether we should be doing netif_carrier_off() at
>> > all since that throws away frames from the queue and attaches a noop
>> > qdisc. When we're roaming quickly between two APs, we don't necessarily
>> > want that, but we don't actually know whether or not we'll be able to
>> > get back to an AP quickly when we disassociate for whatever reason.
>> >
>> we should stop the wlan0 not the master device. Only data frames
>> should be stopped.
>
> That's what we're doing of course, but should we really drop all the
> frames that might still be in the queue? If we're just roaming we could
> send them out via the next AP, but it's hard to know, and since it's
> working let's not touch it for now.

In current situation we are dropping the frames anyway.
How do you know you are roaming and not moving to another network?

> How exactly are you triggering that "unauthorized port" message? I can't
> seem to reproduce to see if stopping the queue helps, but I'm fairly
> sure, try the patch below that fixes this.

Powering off AP, I think I've seen only Cisco AP that are able to send
deauth packet on power off. So this was without.

> johannes
>
> --- everything.orig/net/mac80211/mlme.c 2008-09-08 10:54:28.000000000 +0200
> +++ everything/net/mac80211/mlme.c      2008-09-08 10:57:30.000000000 +0200
> @@ -574,6 +574,7 @@ static void ieee80211_set_associated(str
>        sdata->bss_conf.assoc = 1;
>        ieee80211_bss_info_change_notify(sdata, changed);
>
> +       netif_tx_start_all_queues(sdata->dev);
>        netif_carrier_on(sdata->dev);
>
>        ieee80211_sta_send_apinfo(sdata, ifsta);
> @@ -995,6 +996,7 @@ static void ieee80211_set_disassoc(struc
>        ifsta->assoc_scan_tries = 0;
>        ifsta->assoc_tries = 0;
>
> +       netif_tx_stop_all_queues(sdata->dev);
>        netif_carrier_off(sdata->dev);
>
>        ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
> @@ -3413,6 +3415,7 @@ static void ieee80211_sta_reset_auth(str
>        ifsta->direct_probe_tries = 0;
>        ifsta->auth_tries = 0;
>        ifsta->assoc_tries = 0;
> +       netif_tx_stop_all_queues(sdata->dev);
>        netif_carrier_off(sdata->dev);
>  }
>
Will be able to test only at night.
Tomas
>
>
>
