Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:61068 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaGFE45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 00:56:57 -0400
Received: by mail-lb0-f172.google.com with SMTP id c11so2008394lbj.17
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 21:56:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53B8D0AA.7020703@lwfinger.net>
References: <53B756D8.1080909@lwfinger.net>
	<CANUX_P0wGNT-E0TnuMkrHV+LWyZAJjiaz+hEzYDVO9EWpJYzfA@mail.gmail.com>
	<53B8D0AA.7020703@lwfinger.net>
Date: Sun, 6 Jul 2014 07:56:56 +0300
Message-ID: <CANUX_P3vSTDbaQ3fFdacQuCt11vECN0MtGZxJpdMCpqFTfLw3g@mail.gmail.com> (sfid-20140706_065700_958227_391C355C)
Subject: Re: Microcode SW errors for Intel 7260
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> I am obviously missing something. Neither iwlwifi nor iwlwifi_msg are listed
> in /sys/kernel/debug/tracing/available_events/, thus trace-cmd cannot enable
> logging those events. The output is as follows:
>
> finger@linux-rcu3:~/wireless-testing> sudo trace-cmd record -e iwlwifi -e
> iwlwifi_msg
> /sys/kernel/debug/tracing/events/iwlwifi_msg/filter
> /sys/kernel/debug/tracing/events/*/iwlwifi_msg/filter
> trace-cmd: No such file or directory
>   No events enabled with iwlwifi_msg
> finger@linux-rcu3:~/wireless-testing>
>
>
> I compared my .config with one for the openSUSE kernel 3.11.10, and the
> kernel hacking section has the same settings.
>
> Do you have any suggestions?
>

Do you have CONFIG_IWLWIFI_DEVICE_TRACING enabled?
If not, please enable it.
Note that I don't really need iwlwifi_msg. iwlwifi should be enough.

If you have CONFIG_IWLWIFI_DEBUG, then running with debug=0x00000800
as a module parameter should be enough if that can save you a kernel
compilation.

Thanks.
