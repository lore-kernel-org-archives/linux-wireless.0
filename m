Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:47341 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYA1J3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 04:29:01 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2873154wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2008 01:29:00 -0800 (PST)
Message-ID: <1ba2fa240801280129g5c9c7b73pdfdb2eb80944ce32@mail.gmail.com> (sfid-20080128_092908_236949_AAEFFC46)
Date: Mon, 28 Jan 2008 11:29:00 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <479D9B5F.5000304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <479D9B5F.5000304@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 28, 2008 11:07 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Johannes,
>
> With the latest wireless-2.6 git tree on my x86_64 system, I am getting a GPF in
> ieee80211_sta_scan_work. I tracked it down to the following astatement:
>
>                 if (!sband ||
>                     (local->scan_channel_idx >= sband->n_channels &&
>                      local->scan_band >= IEEE80211_NUM_BANDS)) {
>
> Specifically, it is the "local->scan_channel_idx >= sband->n_channels" part of the if test. When I
> added test prints of local->scan_channel_idx, local->scan_band, and sband, I got the following:
>
> mac80211: scan_channel_idx = 0, scan_band = 0, sband = ffffffff882c2f10
> mac80211: scan_channel_idx = 1, scan_band = 0, sband = ffffffff882c2f10
> ...
> ...
> mac80211: scan_channel_idx = 13, scan_band = 0, sband = ffffffff882c2f10
> mac80211: scan_channel_idx = 0, scan_band = 2, sband = dead4ead00000001
> general protection fault: 0000 [1] SMP
>
> As can be seen, "sband" is some kind of magic number and is an invalid pointer when scan_band is
> larger than IEEE80211_NUM_BANDS, which causes the GPF.
>
> With the following patch, it works:
>
> Index: wireless-2.6/net/mac80211/ieee80211_sta.c
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/ieee80211_sta.c
> +++ wireless-2.6/net/mac80211/ieee80211_sta.c
> @@ -3237,8 +3237,7 @@ void ieee80211_sta_scan_work(struct work
>                 }
>
>                 if (!sband ||
> -                   (local->scan_channel_idx >= sband->n_channels &&
> -                    local->scan_band >= IEEE80211_NUM_BANDS)) {
> +                    local->scan_band >= IEEE80211_NUM_BANDS) {
>                         ieee80211_scan_completed(local_to_hw(local));
>                         return;
>                 }
>
> It seems to me that it should be OK to skip the scan_chan_idx >= sband->n_channels part of the test
> as scan_band won't get to be >= to IEEE80211_NUM_BANDS until all the channels have been tested in
> the legal bands.
>
> Larry

There are too many issues with API change patch. I think it is a good
direction but it's really unstable I think we need to give another
round before it can be applied.
Thanks
Tomas

>
