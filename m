Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36772 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbIGRoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 13:44:44 -0400
Received: by wicgb1 with SMTP id gb1so52851097wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 10:44:43 -0700 (PDT)
Received: from ?IPv6:2001:40b0:7c00:97:222:faff:fe5d:5ef2? ([2001:40b0:7c00:97:222:faff:fe5d:5ef2])
        by smtp.googlemail.com with ESMTPSA id gt4sm1426014wib.21.2015.09.07.10.44.42
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 07 Sep 2015 10:44:42 -0700 (PDT)
Message-ID: <55EDCD0A.4030503@gmail.com> (sfid-20150907_194448_104233_F39CE44B)
Date: Mon, 07 Sep 2015 19:44:42 +0200
From: ferran <ranker72@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [question] panic when calling drv_get_tsf
References: <55E9A07E.8070005@gmail.com>
In-Reply-To: <55E9A07E.8070005@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I'm having some issues in a modified version of mac80211, which I hope
you will help me with.
I want to report a lower bound of the channel utilization to which a
mesh device is tuned in for a research project. So far, I can read
successfully from debugfs this new statistic updated periodically,
targeting mesh interfaces and tested only with atheros cards. However, I
would like to improve it as I describe at the end. The strategy is to
keep adding the rx and tx used time until a [mesh] beacon is sent, and
then, trigger a custom function that derives the utilization for that
given interval. This one reads the elapsed time since the previous
beacon (should be 1000 TU in mesh mode) and resets the counters. Caller
function:

    --- tx.c ---
    struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
                                             struct ieee80211_vif *vif,
                                             u16 *tim_offset, u16
    *tim_length)
    {
            struct ieee80211_local *local = hw_to_local(hw);
    ...

            rcu_read_lock();
            sdata = vif_to_sdata(vif);
    ...

     out:
            rcu_read_unlock();       

            /* HERE */
            my_function(local, sdata->name, sdata);

            return skb;
    }

My function. Note that I've modified ieee80211_local to share data
between "rx", "tx status" and "beacon tx" contexts. The line comments
fix the error.

    --- tx.c ---
    static void my_function(struct ieee80211_local *local, char
    *if_name, struct ieee80211_sub_if_data *sdata){
            u64 beacon_interval = 1000 * 1024 // 1.024 seconds.
            /* Retrieve counters and add them up */

            /* ↓ KERNEL PANIC HERE ↓ */
            // current_tsf = drv_get_tsf(local, sdata);
            // beacon_interval = current_tsf -
    local->ch_load.last_tsf_channel_load_update;

            rem = do_div(total_used_time, beacon_interval); // compute
    utilization

            /* do some averaging and save */
            /* reset counters */
    }

So firstly, why can't I call drv_get_tsf from there? Is it because TSF
is exactly then being reset? Secondly, I feel unsafe about
synchronization. Should I rcu-protect all operations on
ieee80211_sub_if_data, ieee80211_hw and sk_buff? Worker functions on
rx.c and status.c do read values from those structures.

Finally, I would be interested on using TSF to measure the time passed
since a packet is scheduled to transmit in tx.c and its report is
received at status.c. Do you think that TSF be usable for this?

Thanks for your help!
Ferran


