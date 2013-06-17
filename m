Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59396 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3FQPAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 11:00:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UoauZ-0006vL-Fs
	for linux-wireless@vger.kernel.org; Mon, 17 Jun 2013 17:00:03 +0200
Received: from md-vtisato.hh.med.ic.ac.uk ([129.31.117.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 17:00:03 +0200
Received: from antoniotrabalza by md-vtisato.hh.med.ic.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 17:00:03 +0200
To: linux-wireless@vger.kernel.org
From: antonio <antoniotrabalza@gmail.com>
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
Date: Mon, 17 Jun 2013 14:57:07 +0000 (UTC)
Message-ID: <loom.20130617T165559-455@post.gmane.org> (sfid-20130617_170009_606358_5FBAA2FD)
References: <502D0C72.2050207@lwfinger.net>  <1345459509.4459.5.camel@jlt3.sipsolutions.net>  <50325D89.9080209@lwfinger.net>  <1345478494.4459.30.camel@jlt3.sipsolutions.net>  <CA+XFjiqyqAiZGcBZB6u13FquBbkgBLDbDFAMLnHRMiK6P0Heww@mail.gmail.com>  <5033194A.6030308@lwfinger.net> (sfid-20120821_071459_049721_50621351) <1345531562.4676.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Your suggestion would handle the case where hardware that is only 
supposed to be 
> > available internally has somehow been leaked to the public. In the case 
of the 
> > 2030, it is a device that was intended to be available to the public, 
and I 
> > suspect that Windows and OS X drivers were available with built-in 
firmware.
> 
> Yes, that was likely the case. Except there are no OS X drivers at
> all 
> 
> > My feeling is that the reviewers will need to watch the situation. I 
certainly 
> > plan to monitor every Intel patch for a firmware change, and I will NACK 
every 
> > instance for which that firmware file is not already in linux-firmware. 
John 
> > might not honor my NACK; however, I will be on record.
> 
> You're free to, of course, but I don't think we've ever (intentionally)
> changed the driver from working with a released firmware image to
> working only with unreleased firmware images. In fact, this is the
> reason we have firmware versions and try to load multiple versions, so
> we can begin working on a newer version internally while the driver
> continues to work with older, released versions.
> 
> The situation with 2030 devices was different: we worked on a driver and
> submitted code into the kernel that given the right firmware could work
> with the device. I don't remember, but we may even have thought at the
> time that we'd release the -5 firmware version, but then had to use -6.
> There was definitely a chance that we could release the right firmware
> version and thereby make the previously submitted code work. As it turns
> out, we couldn't or didn't (and that we've released a -6 one I can't
> just release another one), but that wasn't necessarily something anyone
> would have known at the time we submitted the code.
> 
> So I guess we could simply not submit the code before the firmware was
> released, but it would really just have the same effect on users that
> the released code has now -- their old kernel doesn't work with the
> device. Today, it's because we ended up releasing the wrong firmware, if
> we didn't release the code before the firmware it would be because they
> didn't have any driver code at all. I don't see how that would help.
> 
> > At least Ben Hutchings 
> > caught the attempt to delete the older version of the firmware for the 
6205. His 
> > diligence saved some users of older kernels from having to scramble to 
find 
> > firmware not in the firmware repo.
> 
> Yes, that was indeed a mistake. I guess I got over-excited with the new
> firmware being available  Different situation though.
> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

HI,

I am sorry, I cannot really understand why the iwlwifi -2030-5.ucode 
firmware has been removed, just leave it there along with the -6 version for 
people that might need it ! I respect your work, but I am loosing my mental 
health in order to find it and I really need it, I must use MeeGo, a system 
that I am not familiar with. The driver is asking *strictly* for -5 version 
and I don't want to fiddle about kernel compilation every damn time for tiny 
bits of proprietary code, I just want to use as it is (I don't even know if 
there is a possibility to recompile the kernel in MeeGo, and I am not a 
developer)
It should have been in the topic of the post really a link to the -5 version 
if you are the mantainers.
Regards.
Antonio

