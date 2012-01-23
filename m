Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:49423 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab2AWQGM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 11:06:12 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RpMPJ-0005Ih-P2
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 17:06:09 +0100
Received: from localhost ([::1]:49590 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RpMPJ-0000kd-Kx
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 17:06:09 +0100
Received: from [195.4.92.15] (port=43739 helo=5.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RpMMu-0007xK-Dl
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 17:03:40 +0100
Received: from [2002:4fde:97a:2:5054:ff:feb8:40bd] (port=60692 helo=mail.maya.org)
	by 5.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RpMMt-0003rE-JB
	for linux-wireless@vger.kernel.org; Mon, 23 Jan 2012 17:03:40 +0100
Message-ID: <4F1D84CE.8020403@maya.org> (sfid-20120123_170615_583958_02995AB9)
Date: Mon, 23 Jan 2012 17:03:26 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
References: <4EFF12D9.3010602@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site> <4F040FEA.3080703@01019freenet.de> <1408490.qSFZVkU7fA@helmutmobil.site> <4F0562DF.3000200@dualc.maya.org> <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com> <4F0AEBAB.9020104@01019freenet.de> <CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com> <201201100803.q0A83nsQ003757@mail.maya.org> <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com> <201201200730.q0K7U0oj004966@mail.maya.org> <CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
In-Reply-To: <CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> On Fri, Jan 20, 2012 at 8:29 AM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>> All in one: Your workaround was a good idea, but unfortunately it
>> doesn't "solve" / workaround the problem introduced with the patch
>> "mac80211: retry sending failed BAR frames later instead of tearing
>> down aggr" [1]. I don't know off any other solution at this time as to revert it.
> 
> Ok, so we've got at least one hw issue here: rt2800 is not able to report
> correct ACK state of BARs :(
> 
> The interesting bit is that the legacy drivers tear the BA session down as
> soon as the first AMPDU subframe failed. That's the same behavior as
> mac80211 had before the mentioned patch.
> 
> So, let's assume the generic way Felix implemented works for other devices
> (like ath9k) we could go with a workaround inside rt2x00 to tear down
> the BA session as soon as the first AMPDU frame failed.
> 
> Mind to try that one (not even compile tested though :) ).

hdr is missing. I tried to derive it like this:

struct ieee80211_hdr *hdr=(void*)entry->skb->data;

Unfortunately, it crashes the machine after short time of operation.
Therefore I think that it isn't derived correctly!


Regards,
Andreas

> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
> b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index c930ce0..9038934 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -420,8 +420,16 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  		tx_info->status.ampdu_len = 1;
>  		tx_info->status.ampdu_ack_len = success ? 1 : 0;
> 
> -		if (!success)
> -			tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
> +		if (!success && ieee80211_is_data_qos(hdr->frame_control)) {
> +			/*
> +			 * Tear down BA session
> +			 */
> +			struct ieee80211_sta *sta = tx_info->control.sta;
> +			u8 *qc = ieee80211_get_qos_ctl(hdr);
> +			int tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
> +
> +			ieee80211_stop_tx_ba_session(sta, tid);
> +		}
>  	}
> 
>  	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {

