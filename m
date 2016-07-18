Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:32878 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbcGRTVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:21:16 -0400
Received: by mail-pf0-f179.google.com with SMTP id y134so42568553pfg.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 12:21:16 -0700 (PDT)
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
To: Johannes Berg <johannes@sipsolutions.net>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
 <1468868209.2944.1.camel@sipsolutions.net>
 <9831c426-ae04-a85f-9173-bcea30c489d7@broadcom.com>
 <1468869356.2944.5.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fd7fc930-67ab-89bf-5909-0851057e0c84@broadcom.com> (sfid-20160718_212120_366580_A291128C)
Date: Mon, 18 Jul 2016 21:21:11 +0200
MIME-Version: 1.0
In-Reply-To: <1468869356.2944.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-7-2016 21:15, Johannes Berg wrote:
> On Mon, 2016-07-18 at 21:13 +0200, Arend Van Spriel wrote:
>>
>> On 18-7-2016 20:56, Johannes Berg wrote:
>>> On Mon, 2016-07-18 at 19:23 +0530, Purushottam Kushwaha wrote:
>>>> Driver may allow support for different beacon interval on virtual
>>>> interfaces.
>>>> Allow if such support is advertised by driver. This adds new
>>>> ext_feature as NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
>>>
>>> We have NL80211_IFACE_COMB_STA_AP_BI_MATCH in interface
>>> combinations,
>>> perhaps it would make sense to also put this flag there?
>>
>> Hi Johannes,
>>
>> Was looking at the same thing. The description of that flag was a bit
>> unclear to me.
>>
>> """
>>  * @beacon_int_infra_match: In this combination, the beacon intervals
>>  *      between infrastructure and AP types must match. This is
>> required
>>  *      only in special cases.
>> """
>>
>> It is not explicitly stated but it implies the STA vif is connected,
>> right.
> 
> Yes.
> 
> Forget this flag. I don't think any driver sets it - it was a hack for
> iwldvm. I also don't think any userspace cares about it, and it likely
> never really worked. What if the STA vif reconnects anyway?
> 
> I was merely pointing this out wrt. the grouping and where to put
> something new.
> 
>> Probably going off-topic here, but I am also wondering about the
>> use-case of the above patch. I have been looking at M-BSS. Toward
>> user-space these are AP interfaces, but like described in
>> hostapd.conf
>> example a number of AP configuration items are required to be equal.
>> Now
>> we also have chipsets with two 802.11 cores and on each an AP could
>> be
>> setup with independent beacon interval. So to make the distinction
>> would
>> it make sense to introduce MBSS_AP iftype? Or does AP_VLAN cover the
>> MBSS use-case?
>>
> 
> I don't think AP_VLAN does, but isn't a mesh portal simply a mesh point
> interface and an AP interface?

Whoops. Should not use abbreviations like that. I meant the
Multiple-BSSID functionality (from hostapd):

##### Multiple BSSID support
##################################################
#
# Above configuration is using the default interface (wlan#, or
multi-SSID VLAN
# interfaces). Other BSSIDs can be added by using separator 'bss' with
# default interface name to be allocated for the data packets of the new
BSS.
#
# hostapd will generate BSSID mask based on the BSSIDs that are
# configured. hostapd will verify that dev_addr & MASK == dev_addr. If
this is
# not the case, the MAC address of the radio must be changed before starting
# hostapd (ifconfig wlan0 hw ether <MAC addr>). If a BSSID is configured for
# every secondary BSS, this limitation is not applied at hostapd and other
# masks may be used if the driver supports them (e.g., swap the locally
# administered bit)
#
# BSSIDs are assigned in order to each BSS, unless an explicit BSSID is
# specified using the 'bssid' parameter.
# If an explicit BSSID is specified, it must be chosen such that it:
# - results in a valid MASK that covers it and the dev_addr
# - is not the same as the MAC address of the radio
# - is not the same as any other explicitly specified BSSID
#
# Alternatively, the 'use_driver_iface_addr' parameter can be used to
request
# hostapd to use the driver auto-generated interface address (e.g., to
use the
# exact MAC addresses allocated to the device).
#
# Not all drivers support multiple BSSes. The exact mechanism for
determining
# the driver capabilities is driver specific. With the current (i.e., a
recent
# kernel) drivers using nl80211, this information can be checked with
"iw list"
# (search for "valid interface combinations").
#
# Please note that hostapd uses some of the values configured for the
first BSS
# as the defaults for the following BSSes. However, it is recommended
that all
# BSSes include explicit configuration of all relevant configuration items.
#

Regards,
Arend
