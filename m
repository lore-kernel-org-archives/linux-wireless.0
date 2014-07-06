Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41083 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaGFE3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 00:29:23 -0400
Received: by mail-oa0-f42.google.com with SMTP id eb12so3203398oac.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 21:29:23 -0700 (PDT)
Message-ID: <53B8D0AA.7020703@lwfinger.net> (sfid-20140706_063018_179490_A03D007F)
Date: Sat, 05 Jul 2014 23:29:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Microcode SW errors for Intel 7260
References: <53B756D8.1080909@lwfinger.net> <CANUX_P0wGNT-E0TnuMkrHV+LWyZAJjiaz+hEzYDVO9EWpJYzfA@mail.gmail.com>
In-Reply-To: <CANUX_P0wGNT-E0TnuMkrHV+LWyZAJjiaz+hEzYDVO9EWpJYzfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2014 01:10 PM, Emmanuel Grumbach wrote:
>
> Please run with trace-cmd:
>
> I need -e iwlwifi -e iwlwifi_msg
>

Emmanuel,

I am obviously missing something. Neither iwlwifi nor iwlwifi_msg are listed in 
/sys/kernel/debug/tracing/available_events/, thus trace-cmd cannot enable 
logging those events. The output is as follows:

finger@linux-rcu3:~/wireless-testing> sudo trace-cmd record -e iwlwifi -e 
iwlwifi_msg
/sys/kernel/debug/tracing/events/iwlwifi_msg/filter
/sys/kernel/debug/tracing/events/*/iwlwifi_msg/filter
trace-cmd: No such file or directory
   No events enabled with iwlwifi_msg
finger@linux-rcu3:~/wireless-testing>


I compared my .config with one for the openSUSE kernel 3.11.10, and the kernel 
hacking section has the same settings.

Do you have any suggestions?

Larry

