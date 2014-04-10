Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59077 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934745AbaDJLQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 07:16:28 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so4785579wiv.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 04:16:26 -0700 (PDT)
Message-ID: <53467D87.7010402@gmail.com> (sfid-20140410_131632_806409_38FAD6D5)
Date: Thu, 10 Apr 2014 14:16:23 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@inai.de>, ilw@linux.intel.com
CC: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com
Subject: Re: iwlwifi resets and causes a panic
References: <alpine.LSU.2.11.1404101208050.20275@nerf08.vanv.qr>
In-Reply-To: <alpine.LSU.2.11.1404101208050.20275@nerf08.vanv.qr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/10/2014 01:12 PM, Jan Engelhardt wrote:
> Hi,
> 
> 
> iwlwifi flakes out (trace below) and seems to be taking out the
> entire machine sometimes towards a panic (no trace available).
> 
> 	iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
> 

[snip]

> iwlwifi 0000:03:00.0: loaded firmware version 22.0.7.0 op_mode iwlmvm

This firmware is very old - please update it. I know that the specific firmware error you are seeing has been fixed in any newer version.
If you run 3.13, please take -8.ucode. You can find the new firmware in linux-firmware.git or in http://wireless.kernel.org/en/users/Drivers/iwlwifi#Firmware.

Of course, a firmware error shouldn't cause a panic, but since we have no trace, it will be hard to address the issue.
