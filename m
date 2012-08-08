Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44308 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2HHGuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 02:50:01 -0400
Received: by obbuo13 with SMTP id uo13so709480obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2012 23:50:00 -0700 (PDT)
Message-ID: <50220C0B.9080009@gmail.com> (sfid-20120808_085019_029230_4C17F776)
Date: Wed, 08 Aug 2012 01:49:47 -0500
From: Nathan Schulte <nmschulte@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	598144@bugs.debian.org
Subject: Re: rt2500pci: very low transfers and link quality
References: <20120806090054.4290.94602.reportbug@desmas-s.desmas> <20120806093051.GB28150@mannheim-rule.local> <501F96C4.1090400@gmail.com> <20120806215236.GA268@mannheim-rule.local>
In-Reply-To: <20120806215236.GA268@mannheim-rule.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks.

I've been requested to report a bug that I've discovered regarding 
troubles with the rt2500pci kernel module.  As the subject suggests, 
with my card I'm receiving very poor transfer rate and link quality. 
The Debian bug report for this issue can be found here:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=598144

Initially, I noticed the following line repeated in the logs:

> phy0 -> rt2500pci_set_device_state: Error - Device failed to enter state 1 (-16).

which led me to the (closed) Ubuntu bug report:

https://bugs.launchpad.net/bugs/456977

The initial error message appears to be a red herring of sorts, as it 
can be quieted by turning off power control for the interface:

# iwconfig wlan0 power off

Even with the message silenced, I am still receiving poor link 
throughput and quality.  The initial bug reporter noticed the issues 
with kernel 2.6.32, and I've experienced it with 2.6.32 and 3.2.21 (as 
packaged by Debian).  I tried with 3.5 from Debian experimental, but I 
receive a kernel panic (after which the kernel becomes unresponsive) 
whenever I bring up the interface.  This is all noted in the bug report 
log where copies of the kernel logs can be found.

The request for upstream notification can be seen below.  Please let me 
know how I can help!

--

Jonathan Nieder wrote:
> Afterwards, please report this upstream (regardless of
> the result) to linux-wireless@vger.kernel.org, cc-ing
> users@rt2x00.serialmonkey.com, Gertjan van Wingerde
> <gwingerde@gmail.com>, and either me or this bug log so we can track
> it.
>
> Then hopefully someone upstream can provide commands or a patch to try
> to track down the cause and work toward a fix.

Thanks!
-- 
Nate
