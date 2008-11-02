Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:3924 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbYKBM3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 07:29:24 -0500
Received: by ik-out-1112.google.com with SMTP id c29so706250ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 04:29:21 -0800 (PST)
Message-ID: <490D9D19.5070600@gmail.com> (sfid-20081102_132945_110106_091676C6)
Date: Sun, 02 Nov 2008 12:29:13 +0000
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	linux-pm@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/2] orinoco: Don't keep cached firmware around permanently
References: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com> <200811021335.20241.arvidjaar@mail.ru>
In-Reply-To: <200811021335.20241.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On Friday 31 October 2008, David Kilroy wrote:
>> The first patch uses the new power management notifiers to load and
>> release the firmware prior to suspend and after resume (for both Agere
>> and Symbol). I'm not an expert on where suspend/resume is headed, so I'd
>> appreciate any advice from linux-pm on whether this is the preferred way
>> to do things.
> 
> I tested this and it works, and looking how callbacks are invoked I think
> it is techically correct. But I have some concerns about general idea of
> requesting firmware multiple times that are not related to PM.
> 
> Many properties for the currently running device/driver instance depend on
> particular firmware type and version. Now we blindly replace firmware; how
> can we be sure it is actually the same one as was at the time feature set
> was detected?
> 
> Even if some sort of checksumming were impemented we still have to be
> prepared to completely reinitialize card on FW mismatch.

Right. We actually have the same problem on card reset (which can happen
via private ioctl or firmware lockup). We certainly need to be able to
reinitialise the driver flags. I think it would involve something like

--> On init, resume, reset
1. fw download.
2. detect version (+checksum?).
3a. if version unchanged continue.
3b. if version different reset all driver settings.
4. record fw version.

3b requires some refactorring of initialisation. And I'm not sure how
this would interact with userspace on resume - presumably the driver
should call netif_device_detach or something.


Dave.

> I checked what the rest of drivers/net does and either they do not cache at
> all (does not work in this case) or they cache FW im memory after initial
> request.
