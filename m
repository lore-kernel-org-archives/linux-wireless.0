Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56281 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaAPUI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 15:08:58 -0500
Received: by mail-wi0-f181.google.com with SMTP id hi8so2750385wib.14
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 12:08:57 -0800 (PST)
Message-ID: <52D83C56.5010706@gmail.com> (sfid-20140116_210902_112039_6BBE6B9B)
Date: Thu, 16 Jan 2014 22:08:54 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: Re: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
References: <52B0B72A.5070704@gmail.com> <1387313079-28123-8-git-send-email-egrumbach@gmail.com> <20140113111357.GA4611@magnum.frso.rivierawaves.com> <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com> <20140113124049.GA5796@magnum.frso.rivierawaves.com>
In-Reply-To: <20140113124049.GA5796@magnum.frso.rivierawaves.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>
>>> Hi,
>>>
>>> This broke monitor mode:
>>> (unsetting .power_update_binding does not hang)
>>>
>>> modprobe iwlmvm
>>> iw dev wlan0 set type monitor
>>> iw dev wlan0 set freq 5180 40 5190  # hangs
>>>
>>> Can you reproduce it easily or do you need me to post further dbg info ?
>>>
>>
>> We have an open bug on this internally - thanks for reporting.
> 
> OK, BTW I have errors like
> - "Microcode SW error detected." upon monitor up

reading your mail again - is this related to monitor mode or not?

> - "iwlwifi 0000:02:00.0: FW error in SYNC CMD TXPATH_FLUSH" sometimes
> after the subsequent ieee80211_restart_hw
> - "WARNING: ... iwlwifi/mvm/binding.c:201 iwl_mvm_binding_remove_vif"
>   when removing a monitor iface
> 
> You must have seen those too. I will avoid this tree with iwlwifi then.
> 

I probably misunderstood this last sentence?
