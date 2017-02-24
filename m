Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36152 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdBXRvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 12:51:38 -0500
Received: by mail-wr0-f179.google.com with SMTP id 89so17831576wrr.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 09:51:37 -0800 (PST)
Subject: Re: Usage of WoWLAN with iwlwifi driver (Device phy0 failed to
 suspend async: error -16)
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <cc035655-0869-f7d7-bdb4-61e7a38b7fc8@googlemail.com>
 <1487938277.2540.13.camel@sipsolutions.net>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <5d69cf9b-1113-835a-8423-3796586eae20@googlemail.com> (sfid-20170224_185152_223023_9A7EF347)
Date: Fri, 24 Feb 2017 19:51:33 +0100
MIME-Version: 1.0
In-Reply-To: <1487938277.2540.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 24.02.2017 um 13:11 schrieb Johannes Berg:
>> However, when trying to suspend to RAM ( echo mem > /sys/power/state
>> ), I get:
>> [46656.403767] dpm_run_callback(): wiphy_suspend+0x0/0x97 [cfg80211]
>> returns -16
>> [46656.403769] PM: Device phy0 failed to suspend async: error -16
>>
> 
> However, I don't see EBUSY anywhere there in the driver.
> 
> Can you recompile the kernel and run a quick experiment?
> 
> Open drivers/net/wireless/intel/iwlwifi/mvm/mvm.h and put something
> like this after the includes:
> 
> #undef EBUSY
> #define EBUSY ({ WARN_ON(1); 16; })
> 
> that should trigger a warning at the place where the EBUSY came from,
> assuming it did in fact come from the driver. You could repeat it for
> net/mac80211/ieee80211_i.h if that doesn't trigger.

Thanks for your reply and the suggestion! I have put the two lines directly after the last #include
in both files, i.e. both drivers/net/wireless/intel/iwlwifi/mvm/mvm.h and net/mac80211/ieee80211_i.h . 
Sadly, none of them triggers when trying to enter suspend. 

I still get:
[   85.308756] dpm_run_callback(): wiphy_suspend+0x0/0x97 [cfg80211] returns -16
[   85.308757] PM: Device phy0 failed to suspend async: error -16
[   85.310518] sd 5:0:0:0: [sdb] Stopping disk
[   85.857976] PM: Some devices failed to suspend, or early wake event detected
with nothing in between. 

Just to make sure, I can confirm the change is effective, since I get many of:
[   57.819114] WARNING: CPU: 4 PID: 4092 at drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1503 iwl_mvm_rx_tx_cmd+0x51e/0x579 [iwlmvm]
(with the tracebacks) for example when connecting to a different network. But none of these when trying to suspend...

Any other ideas on where I could look, or how I could trace the origin of this -16? 

> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=109591#c25
> 
> That device is like mine, afaict, so this seems to be a different bug.
You are right about the bug report - I provided the wrong link, sorry. 
The report I meant is here:
https://bugzilla.redhat.com/show_bug.cgi?id=1362311
for a 7260 similar to mine. 

I believe that 
 https://bugzilla.kernel.org/show_bug.cgi?id=109591#c25
i.e. comment 25 was made by the same person who just hijacked that kernel
bug report even though it was indeed for a very different hardware. 

I'm open for any other suggestions, let me know if anything comes to mind. 

Cheers and thanks for your reply, 
	Oliver
