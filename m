Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58492 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762694Ab3DDAKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 20:10:13 -0400
Message-ID: <515CC4E0.5010706@candelatech.com> (sfid-20130404_021024_931600_92A0486C)
Date: Wed, 03 Apr 2013 17:10:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: sta_info_flush_defer:  Splat in 3.9.0-rc5+
References: <515CB8A3.50805@candelatech.com>  (sfid-20130404_011800_128781_8C70A056) <1365032488.8351.68.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365032488.8351.68.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 04:41 PM, Johannes Berg wrote:
> On Wed, 2013-04-03 at 16:17 -0700, Ben Greear wrote:
>> I'm getting started on testing 3.9.0-rc5+ a bit more seriously.  This is on
>> a tree with some additional patches:
>>
>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.9.dev.y/.git;a=summary
>>
>>
>> The splat below comes from this.  I see lots of these on both station and AP system when
>> bouncing 50 or so stations.
>
> I might be interested if you can reproduce without your hashing patches,
> but with those I suspect you just return an error there that shouldn't
> be returned.

Ahh, yes...I was returning false errors from the sta_info_hash_del.
I just need to ignore vhash remove errors because the vhash is only
populated for station vifs.

Seems to be working better now.

Thanks for the suggestion!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

