Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:46062 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808Ab2BFNBh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 08:01:37 -0500
Received: by mail-lpp01m010-f51.google.com with SMTP id s15so2961823lag.38
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 05:01:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2FB6A0.5030901@gmail.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-4-git-send-email-victorg@ti.com>
	<4F277F85.1090901@sipsolutions.net>
	<CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>
	<4F2B18AA.90809@neratec.com>
	<4F2FB6A0.5030901@gmail.com>
Date: Mon, 6 Feb 2012 15:01:36 +0200
Message-ID: <CAK80WHa_06axdbeOV33BKwOC9FPRZA_4xJeo0f6VOYVjqAcBHw@mail.gmail.com> (sfid-20120206_140141_588711_B656D773)
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
From: "Goldenshtein, Victor" <victorg@ti.com>
To: "zefir.kurtisi@gmail.com" <zefir.kurtisi@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 1:16 PM, zefir.kurtisi@gmail.com
<zefir.kurtisi@gmail.com> wrote:
> I noticed this issue working on interfacing ath9k to your DFS management component. When a DFS channel is initially set, the driver has no information whether to block TX or not (as opposed to ap_process_chanswitch() providing these flags). What is the assumption here? Is the driver required to check itself whether a DFS channel is set and raise some internal tx_disabled flag to be reset via hw_dfs_en_tx()? With all the logic being located in hostap, this looks inconsistent (but doable).
>

When a DFS channel is initially set (with hostapd_set_freq()) the AP
is during early init phase and obviously not transmitting anything yet
at this point, the AP should start the tx (transmitting beacons) only
after hostapd_setup_bss() call, which is blocked until we validate the
channel for radar clearness. If during the CAC tes a radar is detected
we select and set another frequency/channel (still with
hostapd_set_freq()) and start the radar detection once again for the
new freq. Once the channel pass the "channel availability check" we
continue with the init flow as usual. IMHO the driver doesn't need to
block anything at this point and no flag is required.

In wl12xx we have one "FLAG_DFS_CAC_IN_PROGRESS" which basically
indicates that we're in the middle of a CAC test and no tx can occur
during this period. This flag is set during
"hw_dfs_start_radar_detection()" and unset during hw_dfs_en_tx(), this
is one of the reason that I thought to change the "hw_dfs_en_tx()" to
something like "dfs_resume_cac()", in this case it would be also
aligned with "hostapd_resume_dfs_cac()" callback, what do you think
about this?


> Aside from that, I managed to interface ath9k to the proposed component. So far, it enables me to set up a DFS monitor to physically test my pattern detectors, while it fails to run in master mode. Need to go through the trace logs to isolate the problem and will report then.
>

We're planning to release wl12xx DFS RFC which might help better
understand the DFS implementation from driver's point of view.


-- 
Thanks,
Victor.
