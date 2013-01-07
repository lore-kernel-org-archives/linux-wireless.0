Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:64215 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab3AGNQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 08:16:07 -0500
Message-ID: <50EACA95.8040004@lri.fr> (sfid-20130107_141613_373725_8B037388)
Date: Mon, 07 Jan 2013 14:16:05 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
CC: Antonio Quartulli <antonio@open-mesh.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com> <1355146824-25012-2-git-send-email-antonio@open-mesh.com> <1356706268.9922.23.camel@jlt4.sipsolutions.net> <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr> <20130107114048.GH27589@ritirata.org>
In-Reply-To: <20130107114048.GH27589@ritirata.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/01/2013 12:40, Antonio Quartulli wrote:
> On Wed, Jan 02, 2013 at 10:40:55AM +0100, Nicolas Cavallari wrote:
>> On 02/01/2013 07:32, Antonio Quartulli wrote:
>>> On Fri, Dec 28, 2012 at 03:51:08 +0100, Johannes Berg wrote:
>>>> Any chance we could converge on a single implementation here?
>>>
>>> Maybe yes :)
>>>
>>> I think that leaving the station not AUTHenticated and let userspace do so would
>>> be the best approach..but then we need a way to enable userspace to do it :)
>>
>> What would happen to old userspace that expect that to be done in the kernel ?
> 
> if the userspace did not register for auth frames, then authentication will be
> handled in the kernel (as I'm doing/changing now), while if the userspace
> registered for such frames, then the kernel will assume that the authentication
> will be handled by the userspace somehow and will not deal with it (but again,
> in this way we need a command to let userspace set the AUTHenticated flag on a
> station).

That means two implementations, not one.

And even with this current patch, old wpasupplicant starts 4 way handshake as soon as the
NEW_STA event is received, even if the station is not authenticated by the kernel. I
expect that some EAPOL frames will be dropped as a result.
