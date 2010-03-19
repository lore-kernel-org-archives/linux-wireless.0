Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52419 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab0CSHhC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 03:37:02 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
Date: Fri, 19 Mar 2010 08:36:58 +0100
Cc: bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <4BA266FB.1080507@lwfinger.net> <201003182031.25013.mb@bu3sch.de> <4BA29D49.80707@lwfinger.net>
In-Reply-To: <4BA29D49.80707@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003190836.58688.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 March 2010 22:38:17 Larry Finger wrote:
> On 03/18/2010 02:31 PM, Michael Buesch wrote:
> > On Thursday 18 March 2010 18:46:35 Larry Finger wrote:
> >> (1) Modify b43-fwcutter to take data from an existing SPROM,
> > 
> > Why not extend the ssb-sprom tool? I don't think this has anything to do with
> > firmware, except that we (ab)use the firmware loading mechanism of the kernel
> > for loading the blob into the kernel.
> 
> It has nothing to do with firmware, but the existing fwcutter has all the parts
> to generate files in the firmware directory,

Everything needed to "generate a file in the firmware directory" are the open()
write() and close() syscalls.

> > 
> >> I have chosen to implement this in
> >> fwcutter rather than ssb_sprom because the ordinary user will not have access to
> >> ssb_sprom;
> > 
> > Huh? ssb-sprom is GPL software. I have no problem relicensing it under BSD or
> > even something more liberal. I don't see a problem for "ordinary users" here.
> 
> It has nothing to do with the license. My distro, openSUSE, packages fwcutter
> along with a script that uses wget to download the Broadcom drivers and extract
> firmware for both b43 and b43legacy. The average user only has to execute that
> script. Of course, the package could include both fwcutter and ssb_sprom
> programs, but that would make a bigger change to the openSUSE package than just
> a patch to fwcutter. I suspect that other distros use similar packages.
> 
> > Well, but that version won't do anything on the SPROM, too.
> 
> Yes, but if fwcutter were modified, it could write the virtual SPROM file.

I think it really is abuse of fwcutter.
What if you don't want any proprietary firmware at all, but still want an SPROM image?
What about distros that do _not_ automatically use fwcutter to put proprietary fw in place
for legal reasons? (Which most likely is the majority of distributions).

Why create yet another dependency on fwcutter. I thought the long term plan was to get rid
of proprietary firmware and fwcutter?

Is it really such a big deal for a distribution to include yet another tiny opensource
package? If that really is a problem for a distribution, they should just completely
stop doing their distro.

-- 
Greetings, Michael.
