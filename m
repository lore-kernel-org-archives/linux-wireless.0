Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53058 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbIHSXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 14:23:02 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 34215409E87
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2015 11:23:02 -0700 (PDT)
Subject: Re: Question rate-mask and iw
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <55EF237D.9070608@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <55EF2785.3000405@candelatech.com> (sfid-20150908_202307_516551_B58B3651)
Date: Tue, 8 Sep 2015 11:23:01 -0700
MIME-Version: 1.0
In-Reply-To: <55EF237D.9070608@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2015 11:05 AM, Ben Greear wrote:
> I'm trying to add ability to ath10k to set an arbitrary tx-rate mask.
>
> (ie, enable rates 6 64 vht 3 4 9, etc)
>
> I know firmware will need to be modified...that is not the issue currently.
>
> My problem is that I seem not be mis-understanding how the code to set
> rates work.

Ahhh, I think I see.  For HW rate-ctrl, the driver is going to need to keep
the config values from the 'set_bitrate_mask' logic in the driver
and deal with it accordingly....

Thanks,
Ben

>
> I have this code:
>
> static void ath10k_peer_assoc_h_rate_overrides(struct ath10k *ar,
>                             struct ieee80211_vif *vif,
>                             struct ieee80211_sta *sta,
>                             struct wmi_peer_assoc_complete_arg *arg)
> {
>      struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
>      const struct ieee80211_supported_band *sband;
>      const struct ieee80211_rate *rates;
>      u32 ratemask;
>      int i, j;
>      int band = ar->hw->conf.chandef.chan->band;
>
>      if (! test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
>          return;
>
>      lockdep_assert_held(&ar->conf_mutex);
>
>      sband = ar->hw->wiphy->bands[band];
>      ratemask = sta->supp_rates[band];
>      rates = sband->bitrates;
>
>      ath10k_warn(ar, "band: %d  ratemask: 0x%x\n", band, ratemask);
>
>
> It is called when I run the command below:
>
> iw wlan0 set bitrates legacy-5 6 12
>
> But, rate-mask has all bits set...I would expect only bits corresponding
> to rate 6 and 12 to be set.
>
> [ 7487.627841] ath10k_pci 0000:05:00.0: band: 1  ratemask: 0xff
>
>
> I'll go dig through the stack next..but if anyone has pointers, they would be welcome.
>
> Thanks,
> Ben
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

