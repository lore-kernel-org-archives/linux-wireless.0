Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab0GAP7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 11:59:44 -0400
Subject: Re: rfkill failure in 2.6.35-rc3+
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <andy@luto.us>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <AANLkTikqJzkFFtmOowq-OzzDFSC9_1SFuAfT4UGZBhqW@mail.gmail.com>
References: <AANLkTikqJzkFFtmOowq-OzzDFSC9_1SFuAfT4UGZBhqW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 08:59:27 -0700
Message-ID: <1277999967.4197.92.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-30 at 19:59 -0700, Andrew Lutomirski wrote:
> I just toggled rfkill on and back off on my X200s (WiFi Link 5350, rev
> 0x24) and the link didn't come up.  Toggling rfkill again didn't fix
> it, but rmmod + modprobe did.
> 
> dmesg said:
> 
> [13629.424869] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.
> [13629.432761] iwlagn 0000:03:00.0: Not sending command - RF KILL
> [13629.432771] iwlagn 0000:03:00.0: Error sending REPLY_RXON:
> enqueue_hcmd failed: -5
> [13629.432778] iwlagn 0000:03:00.0: Error setting new RXON (-5)
> [13631.268646] iwlagn 0000:03:00.0: RF_KILL bit toggled to enable radio.
> [13631.311232] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [13675.710821] iwlagn 0000:03:00.0: RF_KILL bit toggled to disable radio.
> [13675.713438] iwlagn 0000:03:00.0: Not sending command - RF KILL
> [13675.713448] iwlagn 0000:03:00.0: Error sending REPLY_RXON:
> enqueue_hcmd failed: -5
> [13675.713455] iwlagn 0000:03:00.0: Error setting new RXON (-5)
> [13683.090789] iwlagn 0000:03:00.0: RF_KILL bit toggled to enable radio.
> [13683.145267] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> This is 2.6.35-rc3+ with firmware 8.24.2.12.  I've never seen this before.

Recently we have seen a few issues with rfkill state changes not being
seen by the driver. In all cases it was "resolved" by unloading (or not
loading from the beginning via blacklisting) of the platform driver. Can
you try that?

Reinette


