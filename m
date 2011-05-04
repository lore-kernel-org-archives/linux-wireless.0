Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47290 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1EDROR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 13:14:17 -0400
Received: by vxi39 with SMTP id 39so1369600vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 10:14:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC165D7.50403@openwrt.org>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
 <1304467039-7730-14-git-send-email-javier@cozybit.com> <4DC165D7.50403@openwrt.org>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 4 May 2011 10:13:56 -0700
Message-ID: <BANLkTikOOvGfzV4YK6_0LWnF3jFQy-N0ig@mail.gmail.com> (sfid-20110504_191421_441702_E0BB1B39)
Subject: Re: [PATCH 13/13] ath9k: fix beaconing for mesh interfaces
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 4, 2011 at 7:42 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-05-04 1:57 AM, Javier Cardona wrote:
>>
>> Mesh beaconing on ath9k was broken by this commit:
>>
>> commit 4801416c76a3a355076d6d371c00270dfe332e1c
>> Author: Ben Greear<greearb@candelatech.com>
>> Date:   Sat Jan 15 19:13:48 2011 +0000
>>
>> This patch assigns the right opmode when the device is used in mesh
>> mode.
>>
>> Reported-by: Fabrice Deyber fabricedeyber@agilemesh.com
>> Signed-off-by: Javier Cardona<javier@cozybit.com>
>
> Any idea why exactly ath9k needs to use this opmode? If I understand the
> specs correctly, 802.11s does not use distributed beacons like ad-hoc mode,
> so theoretically it should be fine with using the AP iftype.
> If beacons don't work at all in this opmode for 802.11s then this patch may
> just be covering up an underlying bug rather than fixing the real issue.

Older versions of the 11s draft let implementers decide whether mesh
nodes would beacon in ad-hoc or AP mode.  Apparently on ath9k ad-hoc
mode was chosen when the earlier mesh draft was implemented.

The current version of the draft defines a different beaconing mode
specific for mesh.  This is very unlikely to change since 11s has
already passed sponsor ballot.  My suggestion would be to keep using
ad-hoc style beaconing in ath9k for mesh and to leave the opmode
around for when mesh-specific beaconing is implemented in the driver.

But I know little about ath9k.  If someone can suggest a better way to
"unbreak" mesh beaconing I'll be equally happy.

Thanks!

Javier
