Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:53028 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbZGAQut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 12:50:49 -0400
Subject: Compiling wpa_supplicant?
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 11:50:53 -0500
Message-Id: <1246467053.11632.13.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Folks,

Has hostapd's wpa_supplicant code been brought up to a
consistent standard with the current libnl?  In particular,
I'm trying to compile wpa_supplicant to use driver_nl80211,
but it is failing due to the use of the obsolete 'struct nl_handle'
in src/driver/driver_nl80211.c, line 131 or so.

I am using:
    $ git remote -v
    origin	git://w1.fi/srv/git/hostap-06.git
    $ git rev-parse HEAD
    fa4e296f542af01da135d997358d6d45a32dd59e
and:
    $ git remote -v
    origin	git://git.kernel.org/pub/scm/libs/netlink/libnl.git
    $ git rev-parse HEAD
    ef8ba32e0ca7ac7bbbaf87f6fd7b197af18aed25

In libnl, I see this commit:

        commit b624b9ed936f4c23bc4f30d8dce34da49775dd15
        Author: Thomas Graf <tgr@plip.localdomain>
        Date:   Wed Dec 10 18:02:25 2008 +0100
        
            Remove obsoleted struct nl_handle definition

Is there a version of hostapd/wpa_suppliant that is more
up-to-date WRT libnl-2.0?  Or should I just use the wext
driver for now?

Thanks,
jdl


