Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48256 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab2GNLoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jul 2012 07:44:37 -0400
Message-ID: <50015B98.60705@openwrt.org> (sfid-20120714_134441_774453_2A3EB076)
Date: Sat, 14 Jul 2012 13:44:24 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>, coelho@ti.com,
	johannes.berg@intel.com, brcm80211-dev-list@broadcom.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	ilw@linux.intel.com, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, chunkeey@googlemail.com,
	dsd@gentoo.org, buytenh@wantstofly.org
Subject: Re: [ath9k-devel] [PATCH 2/2] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
References: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de> <50014580.7060702@broadcom.com>
In-Reply-To: <50014580.7060702@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-14 12:10 PM, Arend van Spriel wrote:
> On 07/13/2012 08:52 PM, Thomas Huehn wrote:
>> The pointer control.sta is removed from ieee80211_tx_info to free up sufficient
>> memory in SKB_CB on the tx-path to enable new annotations per data packet e.g.
>> support of upcoming Transmit Power Control (TPC).
>> Now the control.sta pointer is put on the stack where it is passed as function
>> parameter to the .tx equivalent (ieee80211_ops) of each affected wireless
>> driver. Therefore a new structure ieee80211_tx_control is added to mac80211.h
>> which holds the sta structure instead.
>> 
>> ---
>>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  6 +++--
>> 
>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> index 9e79d47..a7be68d 100644
>> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
>> @@ -264,7 +264,9 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
>>  	}
>>  }
>>  
>> -static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>> +static void brcms_ops_tx(struct ieee80211_hw *hw,
>> +			 struct ieee80211_tx_control *control,
>> +			 struct sk_buff *skb)
> 
> Fix indent here (if it is not a mailer issue).
Indentation looks correct to me. The + in front of the 'static' moves
the rest of the line one character further to the right, whereas in the
other lines it's compensated by the tabstop.

- Felix
