Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44889 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FLKm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 06:42:28 -0400
Received: by ghrr11 with SMTP id r11so3232156ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 03:42:27 -0700 (PDT)
Message-ID: <4FD71D0F.2080101@gmail.com> (sfid-20120612_124330_167536_03DE690F)
Date: Tue, 12 Jun 2012 12:42:23 +0200
From: sylvain_gmail <sylvain.roger.rieunier@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: nbd@openwrt.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] minstrel_ht: enable frame aggregation for fixed rate
References: <1339141443-10135-1-git-send-email-sylvain.roger.rieunier@gmail.com>  <1339229456.4539.9.camel@jlt3.sipsolutions.net>  <4FD605DD.9020800@gmail.com> (sfid-20120611_165113_242964_A25B4D05) <1339426690.4520.28.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339426690.4520.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Johannes ans Felix,

This is my new change log version :

"This patch adds frame aggregation for fixed rate mode through debugfs.
Instead of using sample_idx, which set IEEE80211_TX_CTL_RATE_CTRL_PROBE 
flag,
which disabled frame aggregation, we set max_tp_rate and max_tp_rate2 which
  do not disable frame aggregation."

What's is your opinion?

Sylvain

Le 11/06/2012 16:58, Johannes Berg a écrit :
> On Mon, 2012-06-11 at 16:51 +0200, sylvain_gmail wrote:
>> Dear Johannes and Felix ,
>>
>> Here is the description of my patch that I can offer :
>>
>> "After trying to fix rate control with minstrel_ht. I realized that,
>> that fix rate was not allowed to make frames aggregation.
>> This was due to enable  IEEE80211_TX_CTL_RATE_CTRL_PROBE flag of the
>> ieee80211_tx_info structure.
>> Because when IEEE80211_TX_CTL_RATE_CTRL_PROBE flag is set frame
>> aggregation is disabled.
>>   So instead of used sample_idx, who set
>> IEEE80211_TX_CTL_RATE_CTRL_PROBE flag. I suggest using max_tp_rate and
>> max_tp_rate2 which do not disabled frame aggregation."
>>
>> what is your opinion?
> Makes more sense than before, but isn't really a viable changelog entry
> yet :)
>
> johannes
>

