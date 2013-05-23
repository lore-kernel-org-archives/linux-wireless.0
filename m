Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3514 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3EWIMq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 04:12:46 -0400
Message-ID: <519DCF76.8050704@broadcom.com> (sfid-20130523_101251_873023_920BB4AC)
Date: Thu, 23 May 2013 10:12:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Zhou, Robie" <rzhou@qca.qualcomm.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Deng, Flavian" <flaviand@qti.qualcomm.com>
Subject: Re: ath9k_htc p2p finding issue
References: <A75A50687AD91044B3B81AB78993F668447D2F7F@NASANEXD02E.na.qualcomm.com>
In-Reply-To: <A75A50687AD91044B3B81AB78993F668447D2F7F@NASANEXD02E.na.qualcomm.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2013 07:58 AM, Zhou, Robie wrote:
> Hi all,
>
> We meet some problem when try P2P by using ath9k_htc compat-wireless-v3.6.8-1.
>
> When using the compat-wireless-v3.6.8-1, AR9271 could find other P2P devices, but other P2P devices couldn't find AR9271 (runs ath9k_htc) because driver couldn't report Probe Request to wpa_supplicant.
>
> And this issue could not be observed when using compat-wireless-v3.0.9-1, by compare with compat-wireless-v3.0.9-1, ATH9K RX filter is  set correctly after got "Report Probe Request" command from wpa_supplicant, but ATH9K driver couldn't get "Probe Request" frame(I add debug msg in ieee80211_rx_handlers() function).
>
> <7>[  205.784118] [DF_DBG]    [ieee80211_mgmt_frame_register] : local->probe_req_reg = 1;
> <7>[  205.830232] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
> <7>[  205.832858] [DF_DBG]    [ieee80211_configure_filter] : new_flags |= FIF_PROBE_REQ;
> <7>[  205.833101] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter
> <7>[  205.878230] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter
> <7>[  205.882556] [DF_DBG]    [ieee80211_configure_filter] : new_flags |= FIF_PROBE_REQ;
> <7>[  205.883606] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter
>
> <7>[  206.010886] [DF_DBG]    [ieee80211_mgmt_frame_register] : local->probe_req_reg = 0;
> <7>[  206.036237] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter
> <7>[  206.043357] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
> <7>[  206.044107] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
> <7>[  206.090106] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
> <7>[  206.160734] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
> <7>[  206.230740] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
>
>
> Did anyone ever meet this issue? Any suggestion for further debugging this issue?

Did you confirm ath9k_htc is handing over probe requests to mac80211? 
Might be useful to add debugging in prepare_for_handlers() instead.

Regards,
Arend


