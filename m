Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40542 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771Ab2GIJyS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:54:18 -0400
References: <1341766968-29570-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1341826631.4455.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341826631.4455.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A02DA778-9263-46DC-A824-D1EAA9CFC51D@net.t-labs.tu-berlin.de> (sfid-20120709_115421_237435_6D8E67A8)
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: thomas <thomas@net.t-labs.tu-berlin.de>
Subject: Re: [PATCH] mac80211: Add transmit power control support (TPC)
Date: Mon, 9 Jul 2012 11:55:13 +0200
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes, 

That was my fault of miss-spelling johns email... sorry for that.
regardinf the long cc list, it is generated through the get_maintainer script for all driver sources that I touched. what is the correct way you would suggest instead ???

greetings Thomas

Von meinem iPhone gesendet

Am 09.07.2012 um 11:37 schrieb Johannes Berg <johannes@sipsolutions.net>:

> Dropping half the world from CC, please don't do that. Also, please fix
> John's email address, it's really annoying to get bounces all the time
> because you get it wrong.
> 
> 
> On Sun, 2012-07-08 at 19:02 +0200, Thomas Huehn wrote:
>> This patch creates an transmit power control (TPC) API within the mac80211
>> subsystem. It enables a per multi-rate-retry stage annotaion of a power-level
>> value in dBm for each data packet and a global power-level for acknowledgement
>> packets. Furthermore, necessary flags are defined to specify and map TPC
>> hardware capabilities of individual wireless cards. This TPC API is a
>> pre-requisite to implement any power control algorithm at mac80211. A new joint
>> rate and power control algorithm "Minstrel-Blues" is released soon.
> 
> "Will be", presumably?
> 
>> This patch consists of the following 6 logical sections:
> 
> So ... you should split up the patch, right?
> 
>> (1) structure ieee80211_tx_control is added to mac80211
>> It holds the STA structure to be able to remove info->control.sta from
>> struct ieee80211_tx_info (therefor out of the tx-path) and put it on the stack.
> 
> That's certainly a separate step.
> 
>> (2) restructuring of ieee80211_tx_info to add TPC annotation
>> Remove info->control.sta from struct ieee80211_tx_info to free up suitable
>> memory in SKB_CB. Make use of the freed space to extend the struct
>> ieee80211_tx_rate by u8 tpc[4]. This enables a per packet annotation of one
>> powerlevel in dBm per multi-rate-retry stage.
> 
> "suitable"? I think you mean "sufficient"?
> 
>> (3) add tpc hardware capability flags
>> To map different tpc hardware capabilities to mac80211, a new enum
>> ieee80211_tpc_support (type of transmit power control) support is added. Based
>> on these flags someone can specify transmit power control capabilities
>> to the stack.
>> 
>> @IEEE80211_TPC_NONE: No tpc beside a fixed global setting is available.
>>    This setting is used as the default case. Extended tpc capabilities
>>    need to be announced via flags within the individual hardware driver.
>> @IEEE80211_TPC_PER_DATA_PACKET: One power level per data packet can
>>    be set. Each data packet is send out with its individual power level.
>> @IEEE80211_TPC_PER_DATA_MRR: Multiple individual power levels per
>>    multi-rate-retry stage within a data packet are supported.
>> @IEEE80211_TPC_ACK_POWER_GLOBAL: One power level of ack packets is
>>    globaly adjustable.
> 
> "globally"
> 
> This ... doesn't make sense. If this is an enum as you say, then why is
> the ack-power part of the enum? It should be orthogonal -- if I have
> data-MRR TPC support, then certainly I can still have ack-power support?
> 
> 
>> (4) add support to change power-level of acknowledgement packets.
>> Add flag IEEE80211_CONF_CHANGE_ACK_POWER to ieee80211_conf_flags. This enables
>> to specify ack_power as global power level in dBm to use for all mac80211
>> acknowledgement packets.
> 
> 
>> (5) brcmsmac: restructure info->control.sta handling as it is goning to be removed.
>> brcmsmac uses info->control.sta while doing ampdu aggregation. The usage of the
>> structure info->control.sta is changed, as it is going to be removed from
>> struct ieee80211_tx_info.
> 
> You had this as a separate patch, no? Please keep or make it separate.
> 
>> (6) restructure tx-path of all effected drivers
>> Restructure tx-path of all effected drivers to respect new TPC support in
>> mac80211. TPC support is added to mac80211 by restructuring of struct
>> ieee80211_tx_info. Therfore the tx-path of all effected drivers is modified
>> to receive struct sta from the stack and respect the new ieee80211_tx_info
>> struct. List of modified driver:
> 
> again, separate these patches.
> 
> johannes
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
