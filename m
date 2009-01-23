Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:54745 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbZAWAHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 19:07:21 -0500
Received: by nf-out-0910.google.com with SMTP id d3so754623nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 16:07:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d7a260e8d188b785d0d2be743c8c5461@localhost>
References: <87priffb95.fsf@litku.valot.fi>
	 <20090122183448.GC3646@tuxdriver.com>
	 <d7a260e8d188b785d0d2be743c8c5461@localhost>
Date: Fri, 23 Jan 2009 01:07:19 +0100
Message-ID: <2d0a357f0901221607o8f77ff4tf735135200fcea66@mail.gmail.com> (sfid-20090123_010727_266295_4434ED29)
Subject: Re: iwl3945 regression: associates but no data is transfered
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: samuel@sortiz.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

BTW, v2 of Alina's fix is *NOT* fixing the problem (not on my machine).

Kind Regards,
Sedat

[1] [PATCH v2] mac80211: Fixed BSSID handling revisited
http://marc.info/?l=linux-wireless&m=123259183328417&w=2

On Fri, Jan 23, 2009 at 12:41 AM,  <samuel@sortiz.org> wrote:
>
> On Thu, 22 Jan 2009 13:34:48 -0500, "John W. Linville"
> <linville@tuxdriver.com> wrote:
>> On Thu, Jan 22, 2009 at 08:26:14PM +0200, Kalle Valo wrote:
>>> Hello,
>>>
>>> I upgraded to the latest wireless-testing and my iwl3945 is now
>>> broken. It can associate but no data is transfered after that. Tried
>>> with open and wep modes. With dhcp I cannot get ip and with static ip
>>> ping to the gateway doesn't work.
>>>
>>> Any hints?
>>
>> Lots of iwlwifi stuff merged yesterday...
> The bad commit seems to be e32b1b9a33759e8a83ac566c4c43f23ed5d6343b, which
> is not iwlwifi related.
> Even though it's an mlme commit, it doesnt seem to affect other drivers (at
> least b43 and ath5k).
> I'll come up soon with a proper fix, but for now iwl3945 users should
> revert that commit locally.
>
> Cheers,
> Samuel.
>
>>
>> Chatre, Reinette (1):
>>       iwl3945: add debugging for wrong command queue
>>
>> Helmut Schaa (2):
>>       iwl3945: fix some warnings when compiled without debug
>>       iwlagn: fix hw-rfkill while the interface is down
>>
>> Jay Sternberg (4):
>>       iwlwifi: correct Kconfig to prevent following entries from not
>>       indenting
>>       iwlwifi: remove static from 5000 structures
>>       iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
>>       iwlwifi: add recognition of Intel WiFi Link 100 Series
>>
>> Reinette Chatre (1):
>>       iwlwifi: return NETDEV_TX_OK from _tx ops
>>
>> Samuel Ortiz (3):
>>       iwl3945: Use iwl_txq_update_write_ptr
>>       iwlwifi: Add TFD library operations
>>       iwl3945: Use iwl-hcmd host command routines
>>
>> Winkler, Tomas (6):
>>       iwlwifi: make iwl-power.c more readable
>>       iwlwifi: fix iwl_mac_set_key and iwl3945_mac_set_key
>>       iwlwifi: kill iwl3945_scan_cancel and iwl3945_scan_cancel_timeout
>>       iwlwifi: kill scan39
>>       iwlwifi: remove unused or twice defined members in iwl_priv
>>       iwlwifi: eliminate power_data_39.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
