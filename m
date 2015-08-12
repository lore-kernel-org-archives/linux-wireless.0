Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36656 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbHLUmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 16:42:55 -0400
Received: by oiev193 with SMTP id v193so15793688oie.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 13:42:54 -0700 (PDT)
Subject: Re: Wireless driver issue
To: "Richards, Sean" <srichards@gpo.gov>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <BY1PR09MB061612E4649D00B899E62DF9B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
 <55CB88DC.9070502@lwfinger.net>
 <BY1PR09MB0616CB744753A6CE34AA0DB2B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
Cc: "ft86drifter@cox.net" <ft86drifter@cox.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55CBAF98.4020602@lwfinger.net> (sfid-20150812_230540_453009_D9E93AF2)
Date: Wed, 12 Aug 2015 15:42:00 -0500
MIME-Version: 1.0
In-Reply-To: <BY1PR09MB0616CB744753A6CE34AA0DB2B57E0@BY1PR09MB0616.namprd09.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2015 02:15 PM, Richards, Sean wrote:
> No I am sorry it's not obvious.  I was told to report the bug to you.  I did so.  I honestly don't know much about Linux.  I like using it and reported the bug to help the community.  I am sure I won't be the only one to purchase this device and Put RedHat / Fedora on it.

Since you are new, I will offer a little tutorial.

Firstly, it is better if you do not post your response before the quoted 
material - called top posting.

A. It puts the answer out of order and before the question.
Q. Why is top posting bad?

The person that told you to report this problem to us did not know what they 
were saying. This mailing list is for open-source drivers. As I said in the 
first E-mail, and as I will explain a little more fully here, your device has no 
open-source driver available.

A third point is that when you will be posting the output from lspci, always 
include the "-nn" switch in the command. That way the PCI IDs will be listed. 
Those are the codes used by the system to recognize what driver the device will 
use. There is always a possibility that the BCMXXXX designation may be misleading.

There are three sources of drivers for Broadcom wireless devices:

1. Driver b43 is open source and mostly covers older devices. It has been 
written by the community based on clean-room reverse engineering. As stated 
earlier, the more complicated the wireless technology, the more difficult the 
reverse process.

2. Drivers brcmsmac and brcmfmac are open source and cover newer devices. These 
drivers have been written by Broadcom employees, thus they have access to the 
details of the internals of the wireless chips; however, not all new devices are 
supported.

3. Driver wl, which is partly closed source, has been written by a different set 
of Broadcom developers. It is a hybrid driver with two parts. The first is 
open-source code that handles the interfacing between the wireless chip control 
routines and the rest of Linux. The second part, which handles the actual 
operation of the wireless chip, is only provided as a binary blob. The probable 
reason for hiding this code is to preserve the "secrets" of the chips.

The list of what drivers are available for the various devices is available at 
https://wireless.wiki.kernel.org/en/users/Drivers/b43. As shown there, driver wl 
is the only option for your device.

Larry

