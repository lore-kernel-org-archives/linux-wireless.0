Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:33143 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab2BFOsI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 09:48:08 -0500
Message-ID: <4F2FE825.6020700@neratec.com> (sfid-20120206_154812_242687_B81C8372)
Date: Mon, 06 Feb 2012 15:48:05 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Goldenshtein, Victor" <victorg@ti.com>
CC: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Subject: Re: [RFC 3/9] nl80211/cfg80211: add ability to enable TX on op-channel
References: <1327581484-22047-1-git-send-email-victorg@ti.com>	<1327581484-22047-4-git-send-email-victorg@ti.com>	<4F277F85.1090901@sipsolutions.net>	<CAK80WHbAE0+NhLgLAxE+6BmkHFy2hw=sNV1TBjjOTajhHcdxRw@mail.gmail.com>	<4F2B18AA.90809@neratec.com>	<4F2FB6A0.5030901@gmail.com> <CAK80WHa_06axdbeOV33BKwOC9FPRZA_4xJeo0f6VOYVjqAcBHw@mail.gmail.com>
In-Reply-To: <CAK80WHa_06axdbeOV33BKwOC9FPRZA_4xJeo0f6VOYVjqAcBHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2012 02:01 PM, Goldenshtein, Victor wrote:
> On Mon, Feb 6, 2012 at 1:16 PM, zefir.kurtisi@gmail.com 
> <zefir.kurtisi@gmail.com> wrote:
>> I noticed this issue working on interfacing ath9k to your DFS
>> management component. When a DFS channel is initially set, the
>> driver has no information whether to block TX or not (as opposed to
>> ap_process_chanswitch() providing these flags). What is the
>> assumption here? Is the driver required to check itself whether a
>> DFS channel is set and raise some internal tx_disabled flag to be
>> reset via hw_dfs_en_tx()? With all the logic being located in
>> hostap, this looks inconsistent (but doable).
>> 
> 
> When a DFS channel is initially set (with hostapd_set_freq()) the AP 
> is during early init phase and obviously not transmitting anything
> yet at this point, the AP should start the tx (transmitting beacons)
> only after hostapd_setup_bss() call, which is blocked until we
> validate the channel for radar clearness. If during the CAC tes a
> radar is detected we select and set another frequency/channel (still
> with hostapd_set_freq()) and start the radar detection once again for
> the new freq. Once the channel pass the "channel availability check"
> we continue with the init flow as usual. IMHO the driver doesn't need
> to block anything at this point and no flag is required.
> 
> In wl12xx we have one "FLAG_DFS_CAC_IN_PROGRESS" which basically 
> indicates that we're in the middle of a CAC test and no tx can occur 
> during this period. This flag is set during 
> "hw_dfs_start_radar_detection()" and unset during hw_dfs_en_tx(),
> this is one of the reason that I thought to change the
> "hw_dfs_en_tx()" to something like "dfs_resume_cac()", in this case
> it would be also aligned with "hostapd_resume_dfs_cac()" callback,
> what do you think about this?
> 
So the driver does not need to be aware of disabled TX condition at all, since hostapd ensures that no TX will happen during CAC? What is then your FLAG_DFS_CAC_IN_PROGRESS used for?

As for the naming, I'd maybe call them just dfs_start_cac() and dfs_end_cac(), but am also fine with the 'resume' variant.
 
> 
>> Aside from that, I managed to interface ath9k to the proposed
>> component. So far, it enables me to set up a DFS monitor to
>> physically test my pattern detectors, while it fails to run in
>> master mode. Need to go through the trace logs to isolate the
>> problem and will report then.
>> 
> 
> We're planning to release wl12xx DFS RFC which might help better 
> understand the DFS implementation from driver's point of view.
> 
> 
Yeah, having a working reference implementation would definitively help.


Thanks,
Zefir

