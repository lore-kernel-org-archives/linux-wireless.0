Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34391 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab0I3Pdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 11:33:54 -0400
Received: from mail-ey0-f174.google.com (mail-ey0-f174.google.com [209.85.215.174])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id o8UFXqxW024250
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 10:33:53 -0500
Received: by eyb6 with SMTP id 6so826947eyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 08:33:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <733457.84719.qm@web56801.mail.re3.yahoo.com>
References: <733457.84719.qm@web56801.mail.re3.yahoo.com>
From: Michael Griepentrog <griepent@cs.wisc.edu>
Date: Thu, 30 Sep 2010 10:33:25 -0500
Message-ID: <AANLkTi==09DXcF-Cbon7SFUxU8WbUMx6ZL8OQP5g8=5z@mail.gmail.com>
Subject: Re: [BUG] compat: broken driver-select always compiles ath6kl & brcm80211
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

driver-select currently doesn't modify the Makefiles of drivers in
staging, so they will always be built. You should be able to disable
those drivers from being built by editing your kernel config to enable
CONFIG_STAGING_EXCLUDE_BUILD and/or disabling CONFIG_STAGING.

If we want something to work within the confines of driver-select, we
could place a Makefile in drivers/staging and apply the same policies
that driver-select does to the drivers/net/wireless Makefile. It
wouldn't be very useful as it would always remove the contents of the
Makefile, but if modules in staging were built against something other
than CONFIG_COMPAT_STAGING, it could be used to add brcm80211 to the
list supported drivers for driver-select.

--
Michael

On Wed, Sep 29, 2010 at 8:00 AM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> Latest compat-wireless manifests a bug when "scripts/driver-select" is invoked. Regardless of which driver is selected (zd1211rw for example),  ath6kl and brcm80211 are always compiled along with the designated module of choice.
>
> I tried looking in to it, but don't really have time. Perhaps someone would like to investigate.
>
> Walter.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
