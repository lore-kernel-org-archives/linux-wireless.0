Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58238 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1ILS6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 14:58:50 -0400
Received: by qyk30 with SMTP id 30so1972379qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 11:58:49 -0700 (PDT)
Message-ID: <4E6E5666.50901@lwfinger.net> (sfid-20110912_205853_416953_869BCED3)
Date: Mon, 12 Sep 2011 13:58:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Missing routines for iwlagn on PowerPC build
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using a clone of wireless-testing (git describe 
master-2011-08-30-272-g811462b) to compile 3.1-rc4 for a Powerbook G4 Titanium. 
The default configuration was taken from the standard one that comes with 
MintPPC for kernel 2.6.32 as updated for 3.1.

When the build reaches the final stage of the module build, it errors with these 
messages:

ERROR: "iwl_dump_fh" [drivers/net/wireless/iwlwifi/iwlagn.ko] undefined!
ERROR: "iwl_dump_csr" [drivers/net/wireless/iwlwifi/iwlagn.ko] undefined!

I "fixed" it by disabling the build of iwlagn. It appears that the first one 
would be fixed by a patch submitted by Johannes and there is probably a second 
patch for error #2.

Thanks,

Larry
