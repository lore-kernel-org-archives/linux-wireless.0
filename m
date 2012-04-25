Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44634 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab2DYGX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:23:57 -0400
Message-ID: <4F97987B.7050600@candelatech.com> (sfid-20120425_082403_286624_9525EA19)
Date: Tue, 24 Apr 2012 23:23:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Strange problem with ath9k and ASUS N66U AP.
References: <4F972E3F.4020609@candelatech.com> <4F97449F.5040505@candelatech.com> <20120425060853.GA3324@w1.fi>
In-Reply-To: <20120425060853.GA3324@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 11:08 PM, Jouni Malinen wrote:
> On Tue, Apr 24, 2012 at 05:26:07PM -0700, Ben Greear wrote:
>> On 04/24/2012 03:50 PM, Ben Greear wrote:
>>> I am trying some ath9k virtual clients against an ASUS N66U.
>
>>> Here is part of the N66U wifi log showing that it
>>> thinks sta11 is not authorized:
>>>
>>> 00:95:95:00:00:0C  associated
>>> 00:95:95:00:00:0D  associated authorized
>
>> Here's a better log.  Makes me think supplicant might be at fault???
>
> Looks more like an AP bug to me..
>
>> sta8 failed, sta9 works fine.  The difference appears to be the extra
>> RX EAPOL packet that sta8 receives...
>
>> 1335313181.999422: sta8: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
>> 1335313181.999465: sta8: WPA: Sending EAPOL-Key 4/4
>
>> 1335313182.063695: sta8: WPA: RX message 3 of 4-Way Handshake from c8:60:00:e8:88:b0 (ver=2)
>> 1335313182.063745: sta8: WPA: Sending EAPOL-Key 4/4
>
> Either the AP did not receive the first EAPOL-Key 4/4 or processed it
> only after retransmitting 3/4. Supplicant side will need to to reply to
> retransmitted 3/4 to complete the 4-way handshake. If the AP received
> either of these 4/4 messages, it should be fine with the result. If it
> didn't receive either, it should disconnect the station. It does not
> look like either of those happened.

Ok, it seems strange they would have such a lame
bug, but maybe they never tried associating several stations at once.
(I see around 30% failure rate when using just 15 stations).

We have several off-the-shelf APs and home-grown ones (using ath9k) that work fine,
even when associating 100+ stations, so at the least the N66U is weird...

That said, I'll probably need to attempt a work-around for this.  The only
obvious thing I see is the extra RX EAPOL (in all error cases I looked at, and none
where it associated properly), and the fact that DHCP just fails to acquire a lease.

I'll try adding a hack to detect the duplicate RX EAPOL and bounce the connection
if that hits, and see if that helps any...

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
