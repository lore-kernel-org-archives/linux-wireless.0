Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35891 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbcBXMA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 07:00:59 -0500
From: "Kolli, Anilkumar" <akolli@qti.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath10k: Reduce number of peers to support peer stats
 feature
Date: Wed, 24 Feb 2016 12:00:42 +0000
Message-ID: <0f84723798674549adbf41ef948703a9@aphydexm01a.ap.qualcomm.com> (sfid-20160224_130113_031905_91E88207)
References: <1456210197-27892-1-git-send-email-akolli@qti.qualcomm.com>
 <56CC6471.8050204@candelatech.com>
In-Reply-To: <56CC6471.8050204@candelatech.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

We have one more patch to enable/disable this feature.
If we do not need this feature, disable this feature and number
of peers won't be reduced.

Thanks,
Anil.

-----Original Message-----
From: Ben Greear [mailto:greearb@candelatech.com] 
Sent: Tuesday, February 23, 2016 7:24 PM
To: Kolli, Anilkumar; ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Reduce number of peers to support peer stats feature



On 02/22/2016 10:49 PM, akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> To enable per peer stats feature we are reducing the number of peers.
> Firmware has introduced tx stats feature. We have memory limitation in 
> firmware to add these additional bytes.

Maybe this is OK for defaults, but we should also give the user the ability to configure various things, including disabling pktlog, setting number of vdevs, peers, tids, etc.  Maybe something like the parseable config file patch I linked too earlier?

http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=commit;h=6708e4047d91edf234239943332bc2f0d124d009

You can also save a lot of RAM in your firmware if you naturally pack your structs better, and remove un-used members from various structures, etc.

Thanks,
Ben

--
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
