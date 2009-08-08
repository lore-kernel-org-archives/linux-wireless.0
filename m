Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33195 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZHHIZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 04:25:13 -0400
Received: by bwz19 with SMTP id 19so1820481bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 01:25:13 -0700 (PDT)
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [PATCH 16/16] iwlwifi: disable powersave mode
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
	<1249684912-22936-17-git-send-email-reinette.chatre@intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 08 Aug 2009 11:25:09 +0300
In-Reply-To: <1249684912-22936-17-git-send-email-reinette.chatre@intel.com> (Reinette Chatre's message of "Fri\,  7 Aug 2009 15\:41\:52 -0700")
Message-ID: <878whun256.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette Chatre <reinette.chatre@intel.com> writes:

> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>
> The enabling of powersaving had a big impact on reliability and
> performance. Throughput on n band suffered especially. With power save
> support enabled we see significant ping response times, dropped frames, and
> reduced throughput. These are captured in the following bug reports:
>
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2051
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2053
>
> Disable power save by default, add "iwl_support_ps" module parameter
> that can be used to enable it again.

You are again creating driver specific parameters. But we should be
moving away from this and instead use just generic interfaces. Please,
think three times (or even more) whenever creating new driver specific
interfaces, be it module parameters, sysfs files etc.. It's a
maintenance nightmare and also very confusing for the users. We need to
focus on nl80211 and make it work properly with all drivers.

For the problem at hand, I see two options:

1. Users seeing the problem disable power save either via wext or with
   CONFIG_CFG80211_DEFAULT_PS and everyone else still can use power
   save. The issue will be investigated and fixed. If the AP is buggy,
   there isn't much we can do.

2. If you think the problem is widespread, remove
   IEEE80211_HW_SUPPORTS_PS from the driver, fix the issues and renable
   power save support.

-- 
Kalle Valo
