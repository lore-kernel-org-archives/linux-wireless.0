Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59032 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab2G1Ogc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 10:36:32 -0400
Message-ID: <5013F8EF.10404@net.t-labs.tu-berlin.de> (sfid-20120728_163635_578460_B11F462F)
Date: Sat, 28 Jul 2012 16:36:31 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com, nbd@openwrt.org
Subject: Re: [PATCH 2/2] mac80211: Add transmit power control support (TPC)
 for ACK packets
References: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1343404809-70329-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <201207272336.09898.chunkeey@googlemail.com>
In-Reply-To: <201207272336.09898.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

Christian Lamparter schrieb:

> On Friday 27 July 2012 18:00:09 Thomas Huehn wrote:
>> This patch adds support to annotate and change the power-level of ACK
>> packets. To map hardware specific ack power capabilities to mac80211
>> one new hw flag is defined:
>>
>> @IEEE80211_HW_SUPPORTS_TPC_ACK_GLOBAL:
>> 	Power level of ack packets is adjustable and processed in a
>> 	global manner, per hw rather than per ack packet or link.
>>
>> The struct hw_config is extended by ack_power a global power level in
>> dBm to be used for all acknowledgement_packets. A new config change
>> event IEEE80211_CONF_CHANGE_ACK_POWER is defined to reacte with driver
>> specific function calls to ack_power changes from the mac80211.
> 
> I know this is kind of an odd. But as carl9170 has TPC settings
> for BlockACK, CF-End and QoS-Null frames, it wouldn't be possible
> to extend "ACK" to "response".
> 
> NB: The HW has also TPC control registers for ERP(RTS/CTS)
> but that's sort of a different issue.


I just double checked with the registers for Atheros ath5k and ath9k
chips and it is register at address offset: 0x80E8 and holds the
transmit powers for self- generated response frames: ACK_PWR (ACK
self-generated response frames), CTS_PWR (CTS self-generated response
frames) and CHRIP_PWR (Chirp self-generated response frames). So at
least for those chips, I can not see an separate TPC setting .. lets say
for BlockACK. Maybe the Atheros Guys can help out here ?
If my proposed FLAG is to generous we can introduce more hardware
specific ones. My TPC algorithm does consider DATA and ACK packets at
the moment as they are most relevant for interference management but
could be extended to other types.


Greetings Thomas
