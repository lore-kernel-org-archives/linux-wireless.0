Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50917 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYIKXrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 19:47:11 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221123779.2513.88.camel@debian.sh.intel.com>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 03:47:40 +0200
Message-Id: <1221184060.11498.3.camel@californication> (sfid-20080912_014717_771350_5E804F2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> It should be triggered by the BUG_ON() in the function. Are you able to
> confirm it with netconsole or maybe even a frame buffer enabled console
> (it just shows more lines)? If this is the culprit, Tomas has been
> already working on it. But your BT coexist finding should help us
> reproducing the bug.
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703

so I was looking through the bug and switched some options around based
on wild assumptions made in that bug. The current settings are this:

CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=m
# CONFIG_IWLAGN_SPECTRUM_MEASUREMENT is not set
# CONFIG_IWLAGN_LEDS is not set
CONFIG_IWL4965=y
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set

these seem to be stable and have no problems. I tried to crash the
kernel, but didn't manage it.

Previously I had IWLWIFI_RFKILL off (wich was an oversight) and
IWLAGN_LEDS on.

So my guess is either disabling RFKILL or enabling LEDS makes the
difference. This is another reason to not have all these config options,
because nobody find any bugs :(

Regards

Marcel


