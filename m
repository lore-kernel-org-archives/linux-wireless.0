Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45367 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753303AbdJUKWY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Oct 2017 06:22:24 -0400
Date: Sat, 21 Oct 2017 03:22:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linuxwifi@intel.com
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Message-ID: <20171021102207.jvber4zgag5i75ej@merlins.org> (sfid-20171021_122227_799392_D2703312)
References: <20170816233844.qtigfurckdr44awa@merlins.org>
 <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
 <1508249157.5497.103.camel@coelho.fi>
 <20171017212319.eranorcigrmgcpyo@merlins.org>
 <1508276099.5497.122.camel@coelho.fi>
 <87infduk4b.fsf@purkki.adurom.net>
 <1508307368.5497.125.camel@coelho.fi>
 <87bml4iy40.fsf@kamboji.qca.qualcomm.com>
 <1508322176.5497.152.camel@coelho.fi>
 <20171021005038.mykrmhyrhxhzyztw@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171021005038.mykrmhyrhxhzyztw@merlins.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 20, 2017 at 05:50:38PM -0700, Marc MERLIN wrote:
> Mmmh, still seem to have a problem when I reload the module
> 
> what now?

I've entered bug https://bugzilla.kernel.org/show_bug.cgi?id=197341

But I'm still curious what firmware I'm supposed to use:

-rw-rw-r-- 1 merlin merlin 1745176 Jun 18  2015 /lib/firmware/iwlwifi-8000C-13.ucode
-rw-r--r-- 1 root   root   2345768 Dec  6  2015 /lib/firmware/iwlwifi-8000C-14.ucode
-rw-r--r-- 1 root   root   2351636 Dec  6  2015 /lib/firmware/iwlwifi-8000C-16.ucode
-rw-r--r-- 1 root   root   2390004 Feb 12  2016 /lib/firmware/iwlwifi-8000C-17.ucode
-rw-r--r-- 1 merlin merlin 2382972 Feb 25  2016 /lib/firmware/iwlwifi-8000C-19.ucode
-rw-r--r-- 1 merlin merlin 2227284 Jun  3 09:46 /lib/firmware/iwlwifi-8000C-27.ucode

https://www.intel.com/content/www/us/en/support/articles/000005511/network-and-i-o/wireless-networking.html
still says to install
iwlwifi-8000-ucode-25.30.13.0.tgz
which in turn installs
iwlwifi-8000C-13.ucode
while the driver looks for iwlwifi-8000C-30.ucode iwlwifi-8000C-29.ucode iwlwifi-8000C-28.ucode
before loading iwlwifi-8000C-27.ucode

Do I have the right firmware?
loaded firmware version 27.455470.0 op_mode iwlmvm

I'm still getting
[95473.169147] iwlwifi 0000:04:00.0: Refused to change power state, currently in D3
[95473.185656] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
