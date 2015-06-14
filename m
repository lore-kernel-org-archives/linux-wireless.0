Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:46376 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbFNPqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 11:46:44 -0400
Date: Sun, 14 Jun 2015 17:46:42 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG ?] rtlwifi: rtl8723be: condition with no effect
Message-ID: <20150614154642.GA10048@opentech.at> (sfid-20150614_174652_127938_B0D2BD1E)
References: <1434192211-5855-1-git-send-email-hofrat@osadl.org> <557D9B09.7020100@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557D9B09.7020100@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 14 Jun 2015, Larry Finger wrote:

> On 06/13/2015 05:43 AM, Nicholas Mc Guire wrote:
>> From: Nicholas Mc Guire <hofrat@osadl.org>
>>
>> scanning for trivial bug-patters with coccinelle spatches returned:
>> ./drivers/net/wireless/rtlwifi/rtl8723be/dm.c:886
>> 	WARNING: condition with no effect (if branch == else)
>>
>> Added in 'commit a619d1abe20c ("rtlwifi: rtl8723be: Add new driver")'
>>
>> drivers/net/wireless/rtlwifi/rtl8723be/dm.c - line numbers from 4.1-rc7
>> 886         if (thermalvalue > rtlefuse->eeprom_thermalmeter)
>> 887                 rtl8723be_dm_tx_power_track_set_power(hw, BBSWING, 0,
>> 888						 	index_for_channel);
>> 889         else
>> 890                 rtl8723be_dm_tx_power_track_set_power(hw, BBSWING, 0,
>> 891							index_for_channel);
>>
>> Can't figure out what the intent of this condition is but it currently has
>> no effect as if == else and this most likely is not the intent.
>
> I do not know what the correct code should be here, but I will contact 
> the Realtek engineers and get their interpretation. In the meantime, 
> please do not change this code.
>
as noted - I have no clue - so no intent to attempt a change
my mail is only intended as probable bug report.

thx!
hofrat
