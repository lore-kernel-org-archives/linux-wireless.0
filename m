Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:16525 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbZBLA7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 19:59:16 -0500
Received: by fg-out-1718.google.com with SMTP id 16so155457fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 16:59:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090211181727.8162.26564.XPN@L622132.user.x-privat.org>
References: <20090210172817.9004.60065.XPN@L622132.user.x-privat.org>
	 <20090210181915.GA4248@tesla>
	 <20090211181727.8162.26564.XPN@L622132.user.x-privat.org>
Date: Thu, 12 Feb 2009 00:59:14 +0000
Message-ID: <3ace41890902111659s6a75a243p3a7de11272c703bf@mail.gmail.com> (sfid-20090212_015921_128982_9DD3CE8D)
Subject: Re: Merge compat-wireless-old into 2.6.26
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Lurkos <lurkos.usenet@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 6:17 PM, Lurkos <lurkos.usenet@gmail.com> wrote:

> In fact probably no.
> I would like only to use the new iwl3945, because the one provided with
> 2.6.26 gives me lots of problem (*) and then I have to use
> compat-wirelss-old version.
> At the same time I would prefer not to put files outside my home without
> a corresponding deb package, to keep administration of the machine more
> simple. It's quite simple to forget these type of customization (like
> installing compat-wireless)... a package with the flag installed makes
> simpler to keep track on what exactly you have done with the laptop.
> Of course it's also a way learn more about Linux...

compat-wireless only install files under /lib/modules/<kernel_version>/updates

(and "make install" just copy files to that directory and runs depmod
afterwards, which updates a few dependency files in
/lib/modules/<kernel_version>/ - this change is reversible by just
removing the "updates" directory
and re-run depmod ).

If you want to revert the changes made by compat-wireless, you can
just blow away
the updates directories, and re-run depmod:
   rm -rf /lib/modules/*/updates
   depmod -a

I do that occasionally when a specific compat-wireless daily snapshot is bad.
