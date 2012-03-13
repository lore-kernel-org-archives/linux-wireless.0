Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2CMOjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 10:39:22 -0400
Date: Tue, 13 Mar 2012 15:39:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: oops upon driver unload
Message-ID: <20120313143916.GA2396@redhat.com> (sfid-20120313_153926_550441_56A119D6)
References: <4F5F4300.6090103@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F5F4300.6090103@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2012 at 01:52:16PM +0100, Arend van Spriel wrote:
> During testing I got an OOPS with the brcmsmac (see attachment). I
> suspect mac80211 is using a driver callback after the module is
> removed (could be wrong here). The connection with the AP is
> dropped, and after 1 sec. the driver is unloaded using rmmod, which
> causes the driver to unregister from mac80211.
> 
> Any clues?
[snip]

> Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Call Trace:
> Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c103f0ea>] ? run_timer_softirq+0x11a/0x2d0
Those options are useful to debug such problems:

CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y

Stanislaw 
