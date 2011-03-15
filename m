Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41708 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1COSdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:33:31 -0400
Received: by iyb26 with SMTP id 26so849575iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 11:33:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinZHRbhFS9xjdpRwanPWZ13y27x8mja=T=4E86i@mail.gmail.com>
References: <AANLkTi=taszKd9-kyijN100oEegnFi=0u5L4WCp7R_sJ@mail.gmail.com>
 <1299831238.5082.185.camel@wwguy-huron> <AANLkTikYJQcpOnE+Q3=VFioEfpdB+8j+x7+-K_eSU7kd@mail.gmail.com>
 <1300063647.24333.7.camel@wwguy-ubuntu> <AANLkTin_=k=7Y0XmEtZc952pm=wuCawJAXgq6fKFWZM+@mail.gmail.com>
 <1300189917.5596.10.camel@jlt3.sipsolutions.net> <1300193550.5596.16.camel@jlt3.sipsolutions.net>
 <AANLkTinfEU2HNAg7aTmMgSrR6vVyVwLbFmpcP9TL4GyK@mail.gmail.com>
 <1300213768.4139.3.camel@jlt3.sipsolutions.net> <AANLkTinZHRbhFS9xjdpRwanPWZ13y27x8mja=T=4E86i@mail.gmail.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Tue, 15 Mar 2011 11:33:09 -0700
Message-ID: <AANLkTi=Y2r-m71EgZapSAhXY6979PuQzMKwo+DJ8vj5M@mail.gmail.com>
Subject: Re: bug: iwlwifi, aggregation, and mac80211's reorder buffer
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, terminal cut off.

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..0467ec8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -605,13 +605,14 @@ static void ieee80211_sta_reorder_release(struct
ieee80211_hw *hw,
                                continue;
                        }
                        if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
-                                       HT_RX_REORDER_BUF_TIMEOUT))
+                                       HT_RX_REORDER_BUF_TIMEOUT) && skipped)
                                goto set_release_timer;

-#ifdef CONFIG_MAC80211_HT_DEBUG
-                       if (net_ratelimit())
+#if 1
+//#ifdef CONFIG_MAC80211_HT_DEBUG
+//                     if (net_ratelimit())
                                wiphy_debug(hw->wiphy,
-                                           "release an RX reorder
frame due to timeout on earlier frames\n");
+                                           "release an RX reorder
frame due to timeout on earlier frames (skipped=%d)\n", skipped);
 #endif
                        ieee80211_release_reorder_frame(hw, tid_agg_rx, j);

@@ -680,6 +681,7 @@ static bool
ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
         * size release some previous frames to make room for this one.
         */
        if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
+               printk("New seq exceeds buffering window: %d, %d\n",
mpdu_seq_num, head_seq_num);
                head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
                /* release stored frames up to new head to stack */
                ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);


On Tue, Mar 15, 2011 at 11:31 AM, Daniel Halperin
<dhalperi@cs.washington.edu> wrote:
> At the receiver (AP in this case) side, hacked from mac80211. The
> following diff includes one more mac80211 fix I haven't yet sent to
> the list.
>
> Dan
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a6701ed..0467ec8 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -605,13 +605,14 @@ static void ieee80211_sta_reorder_release(struct
> ieee80211                                continue;
>                        }
>                        if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
> -                                       HT_RX_REORDER_BUF_TIMEOUT))
> +                                       HT_RX_REORDER_BUF_TIMEOUT) && skipped)
>                                goto set_release_timer;
>
> -#ifdef CONFIG_MAC80211_HT_DEBUG
> -                       if (net_ratelimit())
> +#if 1
> +//#ifdef CONFIG_MAC80211_HT_DEBUG
> +//                     if (net_ratelimit())
>                                wiphy_debug(hw->wiphy,
> -                                           "release an RX reorder
> frame due to +                                           "release an
> RX reorder frame due to  #endif
>                        ieee80211_release_reorder_frame(hw, tid_agg_rx, j);
>
> @@ -680,6 +681,7 @@ static bool
> ieee80211_sta_manage_reorder_buf(struct ieee8021         * size
> release some previous frames to make room for this one.
>         */
>        if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
> +               printk("New seq exceeds buffering window: %d, %d\n",
> mpdu_seq_nu                head_seq_num =
> seq_inc(seq_sub(mpdu_seq_num, buf_size));
>                /* release stored frames up to new head to stack */
>                ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
>
>
> On Tue, Mar 15, 2011 at 11:29 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2011-03-15 at 11:16 -0700, Daniel Halperin wrote:
>>
>>> [341349.271337] New seq exceeds buffering window: 2797, 2766
>>
>> quick q (on the phone right now) - where's that message from?
>>
>> johannes
>>
>>
>>
>
