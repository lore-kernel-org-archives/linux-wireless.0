Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49401 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab3JKTrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 15:47:48 -0400
Message-ID: <525855E1.1010207@openwrt.org> (sfid-20131011_214801_223590_71AD4FDE)
Date: Fri, 11 Oct 2013 21:47:45 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in commit 0d528d8
References: <52571723.5020000@lwfinger.net> <52571DAA.60502@openwrt.org> <525854AD.5020607@lwfinger.net>
In-Reply-To: <525854AD.5020607@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-10-11 9:42 PM, Larry Finger wrote:
> On 10/10/2013 04:35 PM, Felix Fietkau wrote:
>> I don't recall any necessary extra actions introduced by this patch.
>> Please compare the rate selection info passed to the driver before and
>> after this patch, by dumping info->control.rates.
> 
> I dumped the structure returned by ieee80211_get_tx_rate(hw, info) and found the 
> same values for the case that worked and the one that failed. The values were: 
> flags 0xc, bitrate 0xa, hw_value 0x0, and hw_value_short 0x0.
I guess then we need to take another look at what exactly happens when
the connection fails, I have no idea how that commit can affect rtlwifi.

- Felix
