Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33849 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab3ANVPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 16:15:16 -0500
Message-ID: <50F4755E.8010508@openwrt.org> (sfid-20130114_221521_697819_6D1D05D5)
Date: Mon, 14 Jan 2013 22:15:10 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 2/2] ath9k_hw: fix RF bank initialization
References: <1358103298-4017-1-git-send-email-nbd@openwrt.org> <1358103298-4017-2-git-send-email-nbd@openwrt.org> <20130114195851.GB12018@tuxdriver.com>
In-Reply-To: <20130114195851.GB12018@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-14 8:58 PM, John W. Linville wrote:
> On Sun, Jan 13, 2013 at 07:54:58PM +0100, Felix Fietkau wrote:
>> ar900*_init_mode_regs needs to be called before RF banks are allocated,
>> otherwise the storage size of RF banks isn't known. This patch fixes
>> a memory overrun that can show up as a crash on unloading the module.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> <snip>
> 
>> @@ -410,7 +411,10 @@ int ar9002_hw_attach_ops(struct ath_hw *ah)
>>  	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
>>  	int ret;
>>  
>> -	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
>> +	ret = ar9002_hw_init_mode_regs(ah);
>> +	if (ret)
>> +		return ret;
>> +
>>  	priv_ops->init_mode_gain_regs = ar9002_hw_init_mode_gain_regs;
>>  
>>  	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
> 
> This hunk depends on "ath9k_hw: use the devres API for allocations",
> which is queue for 3.9.  Can you revise this for 3.8?  If not, should
> I hold just this one for 3.9?  Or the earlier patch in the series
> as well?
Oh, I got the version mixed up, put this into 3.9 then, 3.8 doesn't need it.

- Felix

