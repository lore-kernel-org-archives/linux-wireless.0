Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:36186 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZGITtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 15:49:41 -0400
Received: by bwz25 with SMTP id 25so416905bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 12:49:39 -0700 (PDT)
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [PATCH 2/6 2.6.31 and w-t] iwlwifi: only show active power level via sysfs
References: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
	<1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
	<1247160821-14989-3-git-send-email-reinette.chatre@intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 09 Jul 2009 22:49:35 +0300
In-Reply-To: <1247160821-14989-3-git-send-email-reinette.chatre@intel.com> (Reinette Chatre's message of "Thu\,  9 Jul 2009 10\:33\:37 -0700")
Message-ID: <87zlbdprg0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette Chatre <reinette.chatre@intel.com> writes:

> From: Reinette Chatre <reinette.chatre@intel.com>
>
> This changes the power_level file to adhere to the "one value
> per file" sysfs rule. The user will know which power level was
> requested as it will be the number just written to this file. It
> is thus not necessary to create a new sysfs file for this value.
>
> In addition it fixes a problem where powertop's parsing expects
> this value to be the first value in this file without any descriptions.

In the future we need to drop all the driver private interfaces and use
nl80211/wext instead[1]. As this patch shows, they just create problems
for us. I recommend deprecating the file in question as soon as possible
and instead start using proper interfaces.

[1] Even though nl80211 is lacking power save support, but that will be
    fixed soon. Use wext for now.

-- 
Kalle Valo
