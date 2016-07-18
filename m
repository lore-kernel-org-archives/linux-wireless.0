Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35139 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcGRTN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:13:58 -0400
Received: by mail-pa0-f53.google.com with SMTP id iw10so1137853pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2016 12:13:57 -0700 (PDT)
Subject: Re: [PATCH v2] cfg80211: Allow differnt beacon interval if driver
 supports
To: Johannes Berg <johannes@sipsolutions.net>,
	Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
References: <1468849985-6881-1-git-send-email-pkushwah@qti.qualcomm.com>
 <1468868209.2944.1.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9831c426-ae04-a85f-9173-bcea30c489d7@broadcom.com> (sfid-20160718_211406_979617_DAF925D3)
Date: Mon, 18 Jul 2016 21:13:51 +0200
MIME-Version: 1.0
In-Reply-To: <1468868209.2944.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 18-7-2016 20:56, Johannes Berg wrote:
> On Mon, 2016-07-18 at 19:23 +0530, Purushottam Kushwaha wrote:
>> Driver may allow support for different beacon interval on virtual
>> interfaces.
>> Allow if such support is advertised by driver. This adds new
>> ext_feature as NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
> 
> We have NL80211_IFACE_COMB_STA_AP_BI_MATCH in interface combinations,
> perhaps it would make sense to also put this flag there?

Hi Johannes,

Was looking at the same thing. The description of that flag was a bit
unclear to me.

"""
 * @beacon_int_infra_match: In this combination, the beacon intervals
 *      between infrastructure and AP types must match. This is required
 *      only in special cases.
"""

It is not explicitly stated but it implies the STA vif is connected, right.

Probably going off-topic here, but I am also wondering about the
use-case of the above patch. I have been looking at M-BSS. Toward
user-space these are AP interfaces, but like described in hostapd.conf
example a number of AP configuration items are required to be equal. Now
we also have chipsets with two 802.11 cores and on each an AP could be
setup with independent beacon interval. So to make the distinction would
it make sense to introduce MBSS_AP iftype? Or does AP_VLAN cover the
MBSS use-case?

Regards,
Arend
