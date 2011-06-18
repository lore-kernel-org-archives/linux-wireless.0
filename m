Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47098 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1FRJsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 05:48:42 -0400
Received: by gxk21 with SMTP id 21so1586530gxk.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 02:48:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110617171132.GC2200@broadcom.com>
References: <BANLkTi=AP7JKfuL3K+GzB_GhOw=hYmEGpg@mail.gmail.com>
	<20110617171132.GC2200@broadcom.com>
Date: Sat, 18 Jun 2011 11:48:42 +0200
Message-ID: <BANLkTikFBNj0SO3NDPbOc_44VQsPChVc7Q@mail.gmail.com> (sfid-20110618_114848_832175_53B8CBEC)
Subject: Re: disagrees about version of symbol
From: Thomas Novin <thomas@xyz.pp.se>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 17, 2011 at 7:11 PM, Henry Ptasinski <henryp@broadcom.com> wrote:
> On Fri, Jun 17, 2011 at 12:54:28AM -0700, Thomas Novin wrote:
>> Hi
>>
>> I was going to test the brcm80211 driver to replace the wl driver on
>> my gfs laptop to support a BCM4727 chip.
>>
>> After doing scripts/driver-select, choosing that driver, make, make
>> install, make unload and them modprobe brcm80211 I get this:
>
> So you're using compat-wireless, correct?  What version of compat-wireless
> and kernel?
>
> After the "make unload", are cfg80211 and mac80211 actually unloaded?

Yes, version 2011-06-15. They were unloaded.

>> Jun 17 09:43:41 jennie-laptop kernel: [ 5418.241140] brcm80211: module
>> is from the staging directory, the quality is unknown, you have been
>> warned.
>> Jun 17 09:43:41 jennie-laptop kernel: [ 5418.241989] brcm80211:
>> disagrees about version of symbol ieee80211_free_hw
>
> You might have the original mac80211 loaded, not the updated one.

I see now that mac80211/cfg80211 are the correct version but the
driver name actually isn't brcm80211 but brcmsmac? Checking that
brcm80211.ko module I found that it was supplied by a kernel package.
Looking at what 'make install' installed I found brcmsmac.ko,
brcmfmac.ko, brcmutil.ko. I loaded mrcmsmac.ko and I immediately got
connected.

Rgds//TN
