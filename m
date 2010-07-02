Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab0GBR3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 13:29:08 -0400
Subject: Re: [PATCH 2.6.34] mac80211: Fix auth retries if AP sends
 temporary deauth
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <AANLkTilV1t1737ciSPyyETeBEcN_QXsYxgEwpZIIucR2@mail.gmail.com>
References: <AANLkTilV1t1737ciSPyyETeBEcN_QXsYxgEwpZIIucR2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 19:29:03 +0200
Message-ID: <1278091743.15412.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-01 at 10:21 -0700, Paul Stewart wrote:
> @@ -1030,6 +1030,25 @@ ieee80211_rx_result
> ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
>  			skb_queue_tail(&local->work_skb_queue, skb);
>  			ieee80211_queue_work(&local->hw, &local->work_work);
>  			return RX_QUEUED;
> +		case IEEE80211_STYPE_DEAUTH:
> +			/*
> +			 * If we get sent a DEAUTH while we are
> +			 * actively trying to authenticate to this
> +			 * station, we shoot ourselves in the foot if
> +			 * we fall through using RX_CONTINUE and allow
> +			 * the bss context to disappear
> +			 * (ieee80211_sta_rx_mgmt()).  This is
> +			 * especially true if the reason for the
> +			 * DEAUTH was a negative but temporary direct
> +			 * response to an AUTH attempt. Let the retry
> +			 * mechanism run its course instead.
> +			 */
> +                        reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
> +			if (wk->type == IEEE80211_WORK_AUTH &&
> +                            reason_code == WLAN_REASON_PREV_AUTH_NOT_VALID) {
> +				return RX_DROP_MONITOR;
> +			}
> +			break;

Ok, wow, I finally understand this patch, but is it weird!! You're
modifying work.c to avoid having the mlme.c code send this frame to
cfg80211? That's really confusing.

The real reason for this is that we send up the deauth frame even when
we're not even authenticated. This happens in mlme.c. Therefore, we
should improve the logic in ieee80211_sta_rx_queued_mgmt() to make sure
it only triggers when we're authenticated with the BSS?

Alternatively, since cfg80211 tracks this, it would be easier to modify
cfg80211_send_rx_auth() to not send the event to userspace in the !done
case I guess.

johannes

