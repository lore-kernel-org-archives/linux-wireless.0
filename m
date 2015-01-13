Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:11733 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbbAMMIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 07:08:06 -0500
Message-ID: <54B50AA1.3040402@neratec.com> (sfid-20150113_130810_581201_AB38DD9C)
Date: Tue, 13 Jan 2015 13:08:01 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	stable@vger.kernel.org
Subject: Re: [PATCH] ath9k: ignore radar PHY errors when DFS is not enabled
References: <1420822458-531-1-git-send-email-sw@simonwunderlich.de> <2179820.H2CYa3nAla@prime> <54B4F062.2090301@neratec.com> <3155015.RnApTRDnnO@prime>
In-Reply-To: <3155015.RnApTRDnnO@prime>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/13/2015 12:04 PM, Simon Wunderlich wrote:
> On Tuesday 13 January 2015 11:16:02 Zefir Kurtisi wrote:
>> [...]
>>
>> I did not dig how the hw->conf.radar_enabled flag is set in monitor mode,
>> but if it is same as for master (i.e. set for DFS channels), then it would
>> be a better approach to prevent calling ath9k_dfs_process_phyerr()
>> altogether from ath9k_rx_skb_preprocess() if not set.
> 
> Hm, you mean like - if radar_enabled then dfs_process, otherwise fft_process? 
> That would might be more elegant indeed ...
> 
More concrete / restrictive:
* if radar_enabled
 - spectral must not be enabled
 - only ath9k_dfs_process_phyerr() has to be processed
* if !radar_enabled
 - don't process ath9k_dfs_process_phyerr()

> The monitor mode does not have the radar flag enabled, 
> cfg80211_chandef_dfs_required() returns 0 in this case.
> 
Ah, which then means you can not do (supplemental) CACs with a monitor
out-of-the-box? For that, radar_enabled would need to be set for monitor, which
basically should not harm for a fully passive interface.

>>
>> And while you're at that: slaves do not need to scan for radar, might be
>> worth checking if it makes sense to selectively disable radar detection in
>> STA mode. I am using attached private OpenWRT patch for that - which still
>> would interfere with spectral scanning. Generally, the PHY_ERROR processing
>> should be reworked but becomes quite complicated when you take into account
>> special use-cases. Think of radar events being treated differently
>> depending on whether a master or a monitor detected them (OC-CAC vs. ISM).
> 
> I didn't check if that is enforced correctly, but 
> cfg80211_chandef_dfs_required() returns if radar is required for the various 
> interface types - AP, Adhoc and Mesh have it enabled if its a DFS channel, 
> client, monitor, etc don't have it enabled. That gets marked in the sdata-
>> radar_required, and ieee80211_is_radar_required() checks all interfaces if 
> there is any interface which needs radar. So that should have been taken care 
> of.
> 
> Therefore I think that this is already handled in cfg80211/mac80211 and ath9k 
> should not check the iftype at all, but only check the radar_enabled flag.
> 
Ok, thanks for clarifying that - one private patch less to handle :)


