Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55967 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0JNWov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 18:44:51 -0400
Message-ID: <4CB787E1.9000201@candelatech.com>
Date: Thu, 14 Oct 2010 15:44:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAE1DFB.303@candelatech.com> <1286479642.20974.32.camel@jlt3.sipsolutions.net> <AANLkTimxp703Gy_Atg8=wpFszRDR=OJCXwOUKRh-a-d7@mail.gmail.com> <AANLkTi=t-P_5c14brJohM8UgxeOknv+3syO=7W=ix6qf@mail.gmail.com> <AANLkTinC46a+nE-XOQuBCmRJwjzgh24uC7ZJ7HtbVHnT@mail.gmail.com> <4CB378CD.1080800@candelatech.com> <AANLkTim42zmDwf744BCrPwa1kT5ph57bNMyvSyOpesVv@mail.gmail.com> <4CB3D598.7050904@candelatech.com> <AANLkTimPEg3ZU8CQUXfdpGdfbmhdE9O=GNY=g9gysTo4@mail.gmail.com> <4CB4AA89.1070009@candelatech.com> <20101013053141.GA15798@vasanth-laptop> <4CB5E0A8.5020502@candelatech.com> <AANLkTimp_GSwwX_RnQSyN9QNe55HQ+0HZJ1yd8Xp+dWG@mail.gmail.com> <AANLkTinyVqdgPqzpyihuaPtVVqDmzj-ZbXzQ-4qdA2yH@mail.gmail.com> <4CB77EA0.1000005@candelatech.com> <AANLkTimC0+6PiqWO+LmtBV7uKCVpZueAQs6m_6kAnbq9@mail.gmail.com> <AANLkTi=1oOCcdvBHo+8WAVHv-M8tE14ntmK4M_09SWh5@mail.gmail.com> <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
In-Reply-To: <AANLkTi=pp2Ob06YCi6GsR9rtRaDWPP95n2M72qWLdbwM@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2010 03:35 PM, Luis R. Rodriguez wrote:
> On Thu, Oct 14, 2010 at 3:29 PM, Luis R. Rodriguez<mcgrof@gmail.com>  wrote:
>> Fun enough if I just create one monitor interface and loop quickly
>> over some 2 GHz channels where I know I have traffic nearby I don't
>> see the poison. So channel changes don't seem to do much because this
>> is changing channels as fast as possible from userspace. I also can
>> confirm that I see frames from the different channels as I move along.
>
> Even forcing a band change doesn't help trigger it with just one mon0
> and one regular device scanning in a loop;
>
> while true; do for i in 2412 5745 2417 5745 2422 5745 2427 5745 2432
> 5745 2442; do echo $i iw dev mon0 set freq $i; done; done
> while true; do iw dev wlan0 scan; done

What if you just make a bunch of skb copies in ath9k before it
sends them up the stack, and then delete them?  (That's basically
what a bunch of monitor devices would be doing, eh?)

Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

