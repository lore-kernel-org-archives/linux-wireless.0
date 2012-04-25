Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:51869 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab2DYI2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 04:28:13 -0400
Message-ID: <4F97B357.1030609@lri.fr> (sfid-20120425_102821_021371_9CB5E715)
Date: Wed, 25 Apr 2012 10:18:31 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Strange problem with ath9k and ASUS N66U AP.
References: <4F972E3F.4020609@candelatech.com> <4F97449F.5040505@candelatech.com> <20120425060853.GA3324@w1.fi> <4F97987B.7050600@candelatech.com>
In-Reply-To: <4F97987B.7050600@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/04/2012 08:23, Ben Greear wrote:
> On 04/24/2012 11:08 PM, Jouni Malinen wrote:
>> Either the AP did not receive the first EAPOL-Key 4/4 or processed it
>> only after retransmitting 3/4. Supplicant side will need to to reply to
>> retransmitted 3/4 to complete the 4-way handshake. If the AP received
>> either of these 4/4 messages, it should be fine with the result. If it
>> didn't receive either, it should disconnect the station. It does not
>> look like either of those happened.
> 
> Ok, it seems strange they would have such a lame
> bug, but maybe they never tried associating several stations at once.
> (I see around 30% failure rate when using just 15 stations).
> 
> We have several off-the-shelf APs and home-grown ones (using ath9k) that work fine,
> even when associating 100+ stations, so at the least the N66U is weird...
> 
> That said, I'll probably need to attempt a work-around for this.  The only
> obvious thing I see is the extra RX EAPOL (in all error cases I looked at, and none
> where it associated properly), and the fact that DHCP just fails to acquire a lease.
> 
> I'll try adding a hack to detect the duplicate RX EAPOL and bounce the connection
> if that hits, and see if that helps any...
> 

It could look like the old bug i had, where the station would send
EAPOL-Key 4/4 encrypted when associating. Normally, the AP should
disconnect the station, it would retry and hopefully succeed next time,
and no one would have noticed anything, except this AP doesn't
disconnect the station and it doesn't recover.

Basically, wpa_supplicant sends the EAPOL-Key 4/4, then adds the PTK/GTK
in the kernel, but due to scheduling/queuing/buffering of the EAPOL
packet, it would be sent encrypted with the PTK ...

If when monitoring, you don't see any plaintext EAPOL-Key 4/4 coming
from the failed stations, then it could be the same problem.
