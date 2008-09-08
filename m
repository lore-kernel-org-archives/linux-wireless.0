Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:35196 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYIHU6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 16:58:40 -0400
Received: by yx-out-2324.google.com with SMTP id 8so930634yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 13:58:39 -0700 (PDT)
Message-ID: <1ba2fa240809081358h45b63b89xa02e17bd017b2dbc@mail.gmail.com> (sfid-20080908_225844_489986_B3317B7D)
Date: Mon, 8 Sep 2008 23:58:36 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/3] mac80211: fix typo in action frame handling
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220884308.31304.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080908090507.641740000@sipsolutions.net>
	 <1220884308.31304.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 5:31 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> This says chan_switch.action_code but really means
> measurement.action_code, of course the actual offset in
> the frame is the same, it's just harder to understand
> this way.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>



>  net/mac80211/mlme.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- everything.orig/net/mac80211/mlme.c 2008-09-08 16:29:54.000000000 +0200
> +++ everything/net/mac80211/mlme.c      2008-09-08 16:29:56.000000000 +0200
> @@ -2997,7 +2997,7 @@ static void ieee80211_rx_mgmt_action(str
>        case WLAN_CATEGORY_SPECTRUM_MGMT:
>                if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
>                        break;
> -               switch (mgmt->u.action.u.chan_switch.action_code) {
> +               switch (mgmt->u.action.u.measurement.action_code) {
>                case WLAN_ACTION_SPCT_MSR_REQ:
>                        if (len < (IEEE80211_MIN_ACTION_SIZE +
>                                   sizeof(mgmt->u.action.u.measurement)))
>
>
It doesn't really matter on which action code you doing the switch.
The full code looks like that

switch (mgmt->u.action.u.chan_switch.action_code) {
		case WLAN_ACTION_SPCT_MSR_REQ:
			if (len < (IEEE80211_MIN_ACTION_SIZE +
				   sizeof(mgmt->u.action.u.msrment_req)))
				break;
			ieee80211_sta_process_measurement_req(dev, mgmt);
			break;
		case WLAN_ACTION_SPCT_CHL_SWITCH:
			if (len < (IEEE80211_MIN_ACTION_SIZE +
				   sizeof(mgmt->u.action.u.chan_switch)))
				break;
			ieee80211_sta_process_channel_switch(dev, ifsta,
				&mgmt->u.action.u.chan_switch.sw_elem);
			break;
		case WLAN_ACTION_SPCT_TPC_REQ:
			ieee80211_sta_process_tpc_req(dev, mgmt, rx_status);
			break;
		default:
			break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
