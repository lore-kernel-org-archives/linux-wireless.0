Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34660 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab1EFRQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 13:16:15 -0400
Received: by yxs7 with SMTP id 7so1252865yxs.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 10:16:15 -0700 (PDT)
Date: Fri, 6 May 2011 13:16:12 -0400
From: Tom Horsley <horsley1953@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8192cu AP mode?
Message-ID: <20110506131612.7a6d40cb@tomh> (sfid-20110506_191619_240736_FCF6CC9E)
In-Reply-To: <4DC40CEB.5010107@lwfinger.net>
References: <20110506081356.08ac93a8@tomh>
	<4DC40CEB.5010107@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 06 May 2011 09:59:55 -0500
Larry Finger wrote:

> If not, you can always get the compat-wireless 
> sources from http://wireless.kernel.org/en/users/Download.

Well, I worked around the compile errors by reversing the
patch that inserted the kfree_rcu calls, but now when I try
to load the modules I get this:

[root@tomh ~]# modprobe rtl8192cu
WARNING: Error inserting rfkill (/lib/modules/2.6.35.12-90.fc14.x86_64/kernel/net/rfkill/rfkill.ko): Invalid module format
WARNING: Error inserting cfg80211 (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/net/wireless/cfg80211.ko): Invalid module format
WARNING: Error inserting mac80211 (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/net/mac80211/mac80211.ko): Invalid module format
WARNING: Error inserting rtlwifi (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/drivers/net/wireless/rtlwifi/rtlwifi.ko): Invalid module format
WARNING: Error inserting rtl8192c_common (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko): Invalid module format
FATAL: Error inserting rtl8192cu (/lib/modules/2.6.35.12-90.fc14.x86_64/updates/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko): Invalid module format

I guess 2.6.35 is just too old or something.
