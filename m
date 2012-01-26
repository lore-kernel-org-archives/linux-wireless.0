Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab2AZKlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 05:41:16 -0500
Date: Thu, 26 Jan 2012 11:41:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Luigi Tarenga <luigi.tarenga@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: unable to associate to some AP with new iwl_legacy
 driver
Message-ID: <20120126104112.GA2451@redhat.com> (sfid-20120126_114120_122054_B2E872CE)
References: <CAKkO-EgieZkXTAeHn7XkTQG8EXHEHP6zUOedGUre0+CRjBMS9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKkO-EgieZkXTAeHn7XkTQG8EXHEHP6zUOedGUre0+CRjBMS9g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

On Wed, Jan 25, 2012 at 04:25:20PM +0100, Luigi Tarenga wrote:
> I sent a bug report to the wrong team (ilw@linux.intel.com), I hope
> this time I get it right :)
> 
> [1.] One line summary of the problem:
> unable to associate to some AP with new iwl_legacy driver
> 
> [2.] Full description of the problem/report:
> I'm unable to connect to one of mine AP with a 4965AGN with new 3.2 kernel.
> Using stock Centos 6.2 kernel it works while with custom kernel 3.2 compiled
> from vanilla wpa_supplicant return a timeout error during the
> authentication phase.
> Using another WNIC (ralink rt2870) with new 3.2 kernel on the same AP
> works fine.
> The AP is D-Link DIR-300 with OpenWrt compiled from trunk, it's based
> on the RT3050F SoC.
> With the 4965AGN I can connect other AP correctly, I'm not sure if the bug is on
> other layer or on AP, what makes me think about a problem on the
> iwl4965/iwl_legacy
> is the fact that from the Centos kernel I can connect to the very same AP.

Please provide verbose debug logs on working and not working kernel 
for compare.

Kernel has to be compiled with CONFIG_IWLWIFI_LEGACY_DEBUG or
CONFIG_IWLWIFI_DEBUG, or CONFIG_IWLEGACY_DEBUG (depend on kernel
version). On CentOS, kernel-debug should has proper option enabled.

Please configure syslog to log debug messages into /var/log/kernel
(some hint here: https://fedoraproject.org/wiki/DebugWireless), restart
syslog, then do:

modprobe -r iwl4965
echo > /var/log/kernel
modprobe iwl4965 debug=0x47ffffff
wait for association failure (bad kernel) or association success (good kernel)
modprobe -r iwl4965

And post me compress /var/log/kernel files.

On CentOS there is iwlagn module instead of iwl4965.

Would be great if you can find two consecutive kernel versions
where the things get broken. Most likely this is 2.6.38 -> 2.6.39
regression where the iwlwifi driver split into iwlegacy happen.
And provide logs from there. But if you don't want to bother
with trying different kernel version, verbose logs from CentOS
and 3.2 are fine, just will be a bit harder for me to analyze
them.

Thanks
Stanislaw
