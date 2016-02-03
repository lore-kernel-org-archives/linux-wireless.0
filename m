Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34540 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbcBCXvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:51:16 -0500
Message-ID: <56B291A8.4000701@codeaurora.org> (sfid-20160204_005136_249942_8DC87699)
Date: Wed, 03 Feb 2016 15:47:52 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Neelansh Mittal <Neelansh@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Adjusting_tbtt in mesh capability
References: <loom.20160203T210737-307@post.gmane.org>
In-Reply-To: <loom.20160203T210737-307@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/03/2016 12:18 PM, Neelansh Mittal wrote:
> Currently, for a mesh node ,the mac80211
> sync implementation sets the tbtt
> adjustment bit , when it is adjusting it's
> tsf as part of Neighbour offset
> Synchronization(Function:mesh_sync_offset_
> adjust_tbtt())
> According to ieee80211s specification,
> this bit should(only) be set when tbtt
> adjustment procedure(as part of tbtt
> selection/mbca) is ongoing.
> So why does mac80211 set it as part of
> Offset syncronization, ie , what is
> advantage the when a mesh node announces
> that "my tbtt will be delayed" to it's
> peers?
I guess it's to prevent mesh peers from running TBTT adjustment?
Setting TBTT adjustment bit is good idea although the standard is 
addressing TBTT adjustment bit during MBCA/TBTT selection procedure,
since the key idea of setting the bit is to run TBTT adjustment by only 
one mesh point at a time IMO.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

