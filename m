Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53768 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZHLR76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 13:59:58 -0400
Message-ID: <4A830310.2030709@candelatech.com>
Date: Wed, 12 Aug 2009 10:59:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Stephen Hemminger <shemminger@vyatta.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Multiple SSID
References: <20090812100416.744dc5ba@nehalam> <43e72e890908121025p75b141b6o86c30518bf9de7ea@mail.gmail.com>
In-Reply-To: <43e72e890908121025p75b141b6o86c30518bf9de7ea@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2009 10:25 AM, Luis R. Rodriguez wrote:
> On Wed, Aug 12, 2009 at 10:04 AM, Stephen
> Hemminger<shemminger@vyatta.com>  wrote:
>> I have a dumb questions. How does one setup multiple SSID's with
>> current (ie not madwifi) wireless API?

> Anyway I believe AP-enabled devices right now only support creating 1
> AP interfface. I believe the exception to this right now is ath9k
> through the private virtual interface stuff Jouni created, but to be
> honest I have to go and review that to make sure you can create 2 APs.

We're *still* working on virtualizing ath5k.  Over the last few days,
we have gotten this working pretty well, including virtual APs, virtual STAs with
WPA &  no security.  I haven't tested WEP lately.

We are chasing a few remaining buglets and optimizations currently.

I have a page up here to help get started using this:
http://www.candelatech.com/oss/vsta.html

NOTE:  The .31 tree mentioned there has a bunch of other patches in it
that we use for various purposes.  There is no clean way to get *just*
our wifi changes at this point.

We plan to submit the patches upstream, but there is a lot of churn in wifi code
so it will be a bit longer before we can get the patches tested on stable
code and then ported to the development branches.

I haven't tried out ath9k yet, but look forward to it once we get
ath5k nailed down.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

