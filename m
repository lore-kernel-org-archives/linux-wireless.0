Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65330 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0CRViX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 17:38:23 -0400
Received: by fxm19 with SMTP id 19so97294fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 14:38:21 -0700 (PDT)
Message-ID: <4BA29D49.80707@lwfinger.net>
Date: Thu, 18 Mar 2010 16:38:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
References: <4BA266FB.1080507@lwfinger.net> <201003182031.25013.mb@bu3sch.de>
In-Reply-To: <201003182031.25013.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2010 02:31 PM, Michael Buesch wrote:
> On Thursday 18 March 2010 18:46:35 Larry Finger wrote:
>> (1) Modify b43-fwcutter to take data from an existing SPROM,
> 
> Why not extend the ssb-sprom tool? I don't think this has anything to do with
> firmware, except that we (ab)use the firmware loading mechanism of the kernel
> for loading the blob into the kernel.

It has nothing to do with firmware, but the existing fwcutter has all the parts
to generate files in the firmware directory, which is a good place to put this
virtual SPROM.
> 
>> I have chosen to implement this in
>> fwcutter rather than ssb_sprom because the ordinary user will not have access to
>> ssb_sprom;
> 
> Huh? ssb-sprom is GPL software. I have no problem relicensing it under BSD or
> even something more liberal. I don't see a problem for "ordinary users" here.

It has nothing to do with the license. My distro, openSUSE, packages fwcutter
along with a script that uses wget to download the Broadcom drivers and extract
firmware for both b43 and b43legacy. The average user only has to execute that
script. Of course, the package could include both fwcutter and ssb_sprom
programs, but that would make a bigger change to the openSUSE package than just
a patch to fwcutter. I suspect that other distros use similar packages.

> Well, but that version won't do anything on the SPROM, too.

Yes, but if fwcutter were modified, it could write the virtual SPROM file.

Larry
