Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC83C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D85E2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFm1LMx2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D85E2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbeKUNxk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:53:40 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:41760 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbeKUNxk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 08:53:40 -0500
Received: by mail-io1-f65.google.com with SMTP id s22so3011797ioc.8
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2018 19:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvdD350S5xrXdLzzmPXVMAW0MEo3EiFNQTEvkxDsZmw=;
        b=CFm1LMx2bOw7myYyHpo5gKNmUTrU/8vMjw9ZpmgQtfaMuTaHxu1zRnsOk/BKt40+fU
         Opb22xmaR65gY35atLUSll3nlypgZOLODJbB470c95eksorntfdAVWFzY3vnHD45gq8V
         ffNY7qpvwUgcWEp92AVfeUx4vRYpeOf5zILcyxDTvIsJthIEYHRjZZwJDP2QTyal84u7
         OiIH2xgjTPCo4NW7UHDzdIOxcYlYaEXcJYfalPw0+14fms/sqqNniQLUgtvSxYdGfClb
         zWsf3bFoOvI/B5GtqyF6//qqBC08rQfVeeJyfMTle+SLdT7wJtVvgWy0dtmIoDnIbbje
         6iiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvdD350S5xrXdLzzmPXVMAW0MEo3EiFNQTEvkxDsZmw=;
        b=GqYIhsZHCEwi7XfdkaJ9amxJmOl0QD3HFcp49iDyBVJ8zCbDLR78n8/gDWpy2T+4f/
         1cNxALyVHn1avgfzEcSSLs4opQxQ231/NxXYGVsIM6sJQYzFbytCdioq1nr6AC50sH1V
         zU9pvurt4dz67aY5ve8vnRrQ24XoKItvaTk0yHUNjvEdI/nlTe2GI7Eft5pu99Y+5UK+
         5iQ1q5fOiCb09xe3LXAD2TWRic/5TZbyLLHbGY0NhN9zjpUgMiL5pnryNe1JgHvACa/Y
         Q/Cj9fb3kwMMsRijXwxC4p/IZ+lAhhlKAd+PQSmRigT6I3JJWrSThED0AMhff/8XZnvu
         VBNA==
X-Gm-Message-State: AA+aEWbk0l+7VXEOnnkXqz0WJTyyH9q6rAD0ul63Y9p/IvPM6IUde1cV
        V6ZK0YGknO5tONZf2f97aJatOORI+KJ5MBbHEPuh6A==
X-Google-Smtp-Source: AFSGD/WPXZYYwtGjWf1lVXtH1cKIa16RE6r42PqhFTyI2QNHpmSS3QWLv10jiomhgzGTqai08AodXVswTtQ75B2eeBY=
X-Received: by 2002:a6b:398b:: with SMTP id g133mr3564576ioa.67.1542770469043;
 Tue, 20 Nov 2018 19:21:09 -0800 (PST)
MIME-Version: 1.0
References: <20181004195906.201895-1-schuffelen@google.com> <1539073540.3687.99.camel@sipsolutions.net>
In-Reply-To: <1539073540.3687.99.camel@sipsolutions.net>
From:   Cody Schuffelen <schuffelen@google.com>
Date:   Tue, 20 Nov 2018 19:20:57 -0800
Message-ID: <CAAELVAGhUeALjdi+D=K5XVCncQMaw5tUnjZ=jypL0JKN3MNgzA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation device
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 9, 2018 at 1:25 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2018-10-04 at 12:59 -0700, Cody Schuffelen wrote:
> >
> > I wasn't completely clear on whether I should change the title (net-next
> > to mac80211-next) so I left it as is for v3 to try to keep the patchwork
> > series together.
>
> You can/should change it - patchwork doesn't really track this at all
> anyway.

Got it, thanks.

>
> > The driver is also now a bool instead of a tristate to use __ro_after_init.
>
> Hmm? Why would that be required? __ro_after_init works fine in modules?

My mistake, you're right. Tested and this does work with a module.

> > +static struct ieee80211_rate bitrates_2ghz[] = {
> > +     { .bitrate = 10 },
> > +     { .bitrate = 20 },
> > +     { .bitrate = 55 },
> > +     { .bitrate = 60 },
> > +     { .bitrate = 110 },
> > +     { .bitrate = 120 },
> > +     { .bitrate = 240 },
> > +};
>
> Come to think of it, the typical order here would be 1,2,5.5,11,6,12,24
> (6<->11), due to the ordering in the probe request frame I guess.
>
> I'm not sure it matters though.

Thanks, changed.

>
> > +static struct ieee80211_supported_band band_2ghz = {
>
> These can be const, I think?

Unfortunately, the arrays they're assigned to in the wiphy is non-const:
https://github.com/torvalds/linux/blob/master/include/net/cfg80211.h#L4055
https://github.com/torvalds/linux/blob/master/include/net/cfg80211.h#L346

struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];

> > +/** Assigned at module init. Guaranteed locally-administered and unicast. */
>
> I think you should avoid ** - it's the kernel-doc marker.

Good catch. Sorry about that, you pointed it out on an earlier version
as well on a different line.

>
> > +static u8 fake_router_bssid[ETH_ALEN] __ro_after_init = {};
>
> If this is the reason for not allowing it to be a module then you don't
> need  to disallow the module case.

Good point, fixed.

> > +
> > +static void virt_wifi_scan_result(struct work_struct *work)
> > +{
> > +     const union {
> > +             struct {
> > +                     u8 tag;
> > +                     u8 len;
> > +                     u8 ssid[8];
> > +             } __packed parts;
> > +             u8 data[10];
> > +     } ssid = { .parts = {
> > +             .tag = WLAN_EID_SSID, .len = 8, .ssid = "VirtWifi" }
> > +     };
>
> Not sure I see much value in the union, but I don't think it matters
> much.
> (You could just cast below - (void *)&ssid, sizeof(ssid))

Good point, done.

>
> > +     rtnl_lock();
> > +     if (priv->scan_request) {
> > +             cfg80211_scan_done(priv->scan_request, &scan_info);
> > +             priv->scan_request = NULL;
> > +     }
> > +     rtnl_unlock();
>
> Do you need the rtnl for the priv->scan_request locking?

I've redone the structure a bit to clean this up, and don't use the
lock here anymore.

> > +static int virt_wifi_get_station(struct wiphy *wiphy,
> > +                              struct net_device *dev,
> > +                              const u8 *mac,
> > +                              struct station_info *sinfo)
> > +{
> > [...]
> > +     sinfo->tx_packets = 1;
> > +     sinfo->tx_failed = 0;
> > +     sinfo->signal = -60;
>
> I think Sergey pointed out the -60 elsewhere - need to check here too,
> and maybe set in some place that you actually report dBm/mBm.

Added a comment here, it looks like even with CFG80211_SIGNAL_TYPE_MBM
this should be in dBm.
https://github.com/torvalds/linux/blob/master/include/net/cfg80211.h#L1264

> Also, I think you should only report something here if actually
> connected - Sergey pointed this out on the dump station but it applies
> here too.

Thanks, get_station and dump_station now both check if the device is connected.

> > +static void free_netdev_and_wiphy(struct net_device *dev)
> > +{
> > +     struct virt_wifi_netdev_priv *priv = netdev_priv(dev);
> > +     struct virt_wifi_priv *w_priv;
> > +
> > +     flush_work(&priv->register_wiphy_work);
> > +     if (dev->ieee80211_ptr && !IS_ERR(dev->ieee80211_ptr)) {
> > +             w_priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
> > +             w_priv->being_deleted = true;
> > +             flush_delayed_work(&w_priv->scan_result);
> > +             flush_delayed_work(&w_priv->connect);
> > +             flush_delayed_work(&w_priv->disconnect);
>
> this is called from
>
> > +static void virt_wifi_setup(struct net_device *dev)
> > +{
> > +     ether_setup(dev);
> > +     dev->netdev_ops = &virt_wifi_ops;
> > +     dev->priv_destructor = free_netdev_and_wiphy;
> > +}
>
> the destructor, but I believe the destructor is invoked with the RTNL
> held. As such, this will deadlock (and lockdep should complain - at
> least in current kernel versions) when it's actually running when you
> flush it, since you flush something that's (potentially) waiting to
> acquire the RTNL, but you are holding the RTNL here and so neither side
> can make progress.

Good catch, this was not a good strategy. I think it was stable for me
only because RTNL is technically not held when the destructor is
invoked by netdev_run_todo, though I see now that's only because
netdev_run_todo is a special case with respect to the RTNL mutex so
interacting with it there seems like a bad idea.
https://github.com/torvalds/linux/blob/master/net/core/dev.c#L8735

I've changed the asynchronous strategy: at a high level, it now sets
the device in a "down"/"being deleted" state to block any further
asynchronous requests, cancels pending delayed work operations, and
cleans up dangling callbacks the delayed work operations had committed
to doing. More functions are also now annotated with which locks
should already be held and which will be acquired and released. This
relies heavily on cancel_delayed_work_sync. My assumption here is that
cancel_delayed_work_sync puts the delayed work operations in a
definite "not running" state, and uses the return value to determine
if it needs to clean up any callbacks.

> > +     /* The newlink callback is invoked while holding the rtnl lock, but
> > +      * register_wiphy wants to claim the rtnl lock itself.
> > +      */
> > +     schedule_work(&priv->register_wiphy_work);
>
> Maybe we should fix/change that?

Worked around it for this implementation by sharing one wiphy across
all net_device instances. The module init and destroy now acquire the
rtnl mutex to init/destroy the wiphy as well as registering the rtnl
device type. The netdev setup is now more sane as the wiphy setup is
done ahead of time. The only downside is that multiple wifi devices
cannot scan simultaneously, so no great loss.

I've uploaded the new version here: https://lkml.org/lkml/2018/11/21/251
