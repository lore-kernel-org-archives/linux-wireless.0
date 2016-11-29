Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53086 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754693AbcK2M7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 07:59:38 -0500
Message-ID: <1480424369.10012.6.camel@sipsolutions.net> (sfid-20161129_135942_584209_B12BA4D3)
Subject: Re: [PATCH] mac80211: fix Tx BA session stuck issue during sw
 scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Chris Chiu <chiu@endlessm.com>, linux-wireless@vger.kernel.org
Cc: linux@endlessm.com
Date: Tue, 29 Nov 2016 13:59:29 +0100
In-Reply-To: <1479887968-17473-1-git-send-email-chiu@endlessm.com> (sfid-20161123_085941_969147_2A29A624)
References: <1479887968-17473-1-git-send-email-chiu@endlessm.com>
         (sfid-20161123_085941_969147_2A29A624)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-11-23 at 15:59 +0800, Chris Chiu wrote:
> ieee80211_iface_work() will check if sw scanning is in progress
> before handling block ack session. In our case, the RTL8821AE
> operate in station mode, when tx session expired, DELBA packet
> stuck during sw scanning and so do other data packets.
> 
> ieee80211_scan_state_decision() will take lots of time in
> SCAN_SUSPEND/SCAN_RESUME state due to !tx_empty or bad_latency.
> Then the sw scanning mostly take > 20 seconds to finish or even
> worse in our case RTL8821AE have 37 channels for 2G+5G to scan
> and tx stalls ~300 seconds. AP side still thinks the connection
> is alive because it still receives the QoS NULL packet from STA.
> So the link state will never change but actually no data tx/rx
> during this long time.
> 
> This commit tries to send out packet in SCAN_SUSPEND state so the
> sw scanning can complete more efficiently and less affect on Block
> Ack session handling. Verified on RTL8821AE for > 30000 pings and
> no Tx BA session stuck observed.

The premise seems fairly reasonable, although I'm a little worried that
if so much new traffic is coming in we never finish the scan suspend?
Actually, the queues are still stopped, so it's only management frames
that can come in, so that should be ok?

> +	test_and_clear_bit(SCAN_SUSPEND_SCANNING, &local->scanning);
> 

That makes no sense, you're not checking the return value, just clear
the bit without test.
 
> @@ -844,6 +846,8 @@ static void ieee80211_scan_state_suspend(struct
> ieee80211_local *local,
>  	/* disable PS */
>  	ieee80211_offchannel_return(local);
>  
> +	__set_bit(SCAN_SUSPEND_SCANNING, &local->scanning);

Why are you using the non-atomic version here, vs. the atomic one
above?

johannes
