Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:56860 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYDQRFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 13:05:43 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] mac80211: Fix n-band association problem
Date: Thu, 17 Apr 2008 10:05:40 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004353F6E@orsmsx416.amr.corp.intel.com> (sfid-20080417_180548_144551_F15549FF)
In-Reply-To: <1208451520.4066.25.camel@johannes.berg>
References: <1208379724-13568-1-git-send-email-reinette.chatre@intel.com> (sfid-20080416_220312_598962_80DA4049) <1208451520.4066.25.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Johannes Berg  wrote:

> On Wed, 2008-04-16 at 14:02 -0700, Reinette Chatre wrote:
>> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>> 
>> There are two structures named wmm_info and wmm_param, they are used
>> while parsing the beacon frame. (Check the function
>> ieee802_11_parse_elems). Certain APs like D-link does not set the
>> fifth bit in WMM IE. 
>> While sending the association request to n-only ap it checks for
>> wmm_ie. If it is set then only ieee80211_ht_cap is sent during
>> association request. So n-only association fails. And this patch
>> fixes this problem by copying the wmm_info to wmm_ie, which enables
>> the "wmm" flag in iee80211_send_assoc. 
>> 
>> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>> Acked-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> 
> Ack, thanks for the update.
> 
>> ---
>> 
>> This problem is also present in 2.6.25. This patch does apply to
>> 2.6.25-rc9 after changing the filename to be patched to
>> ieee80211_sta.c 
> 
> Do we want this for -stable then?

It will be great if this can make it into 2.6.25. Users who want to use
their DLink N band APs will appreciate it. I am not sure about the
status of submissions to it though as we are cutting it pretty close.

Reinette
