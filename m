Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:61857 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbYA1R1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 12:27:32 -0500
Received: by an-out-0708.google.com with SMTP id d31so383036and.103
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2008 09:27:31 -0800 (PST)
Message-ID: <479E1023.3040604@gmail.com> (sfid-20080128_172739_711189_C79CE30A)
Date: Mon, 28 Jan 2008 11:25:55 -0600
From: "Jory A. Pratt" <geekypenguin@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
References: <479D9B5F.5000304@lwfinger.net>
In-Reply-To: <479D9B5F.5000304@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
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
>  		}
>
>  		if (!sband ||
> -		    (local->scan_channel_idx >= sband->n_channels &&
> -		     local->scan_band >= IEEE80211_NUM_BANDS)) {
> +		     local->scan_band >= IEEE80211_NUM_BANDS) {
>  			ieee80211_scan_completed(local_to_hw(local));
>  			return;
>  		}
>
> It seems to me that it should be OK to skip the scan_chan_idx >= sband->n_channels part of the test
> as scan_band won't get to be >= to IEEE80211_NUM_BANDS until all the channels have been tested in
> the legal bands.
>
> Larry
>   

Larry patch works great it puts the development tree back into a useable 
state for broadcom devices. This should be pushed to wireless-2.6 if 
Johannes will ack it.

-Jory

