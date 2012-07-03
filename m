Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2546 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357Ab2GCQdl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:33:41 -0400
Message-ID: <4FF31ED2.7040302@broadcom.com> (sfid-20120703_183344_308331_DE001727)
Date: Tue, 3 Jul 2012 18:33:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [PATCH] brcmsmac: fix brcms_c_regd_init() which crashed
 after 11ad patch
References: <1341321280-6136-1-git-send-email-arend@broadcom.com>
 <20120703132608.GA5626@thinkpad-t410>
In-Reply-To: <20120703132608.GA5626@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/03/2012 03:26 PM, Seth Forshee wrote:
> On Tue, Jul 03, 2012 at 03:14:40PM +0200, Arend van Spriel wrote:
>> This patch fixes an OOPS in brcmsmac driver, which was introduced
>> by the 11ad patch 'cfg80211: add 802.11ad (60gHz band) support'.
>> The value IEEE80211_NUM_BANDS increased, which was used in the
>> brcms_c_regd_init() function.
>>
>> Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
>> Cc: Johannes Berg <johannes.berg@intel.com>
>> Cc: Seth Forshee <seth.forshee@canonical.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> 
> Acked-by: Seth Forshee <seth.forshee@canonical.com>
> 
> Just one minor nit ...
> 
>> +		if (band_idx == BAND_2G_INDEX) {
>> +			sband = wiphy->bands[IEEE80211_BAND_2GHZ];
>> +		} else {
>> +			sband = wiphy->bands[IEEE80211_BAND_5GHZ];
>> +		}
> 
> No need for braces here.

I hate nits so I will remove them.

Gr. AvS

