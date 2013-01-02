Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:58580 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab3ABJk5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 04:40:57 -0500
Message-ID: <50E400A7.5060100@lri.fr> (sfid-20130102_104101_421232_B08D8C68)
Date: Wed, 02 Jan 2013 10:40:55 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com> <1355146824-25012-2-git-send-email-antonio@open-mesh.com> <1356706268.9922.23.camel@jlt4.sipsolutions.net> <20130102063255.GA27676@open-mesh.com>
In-Reply-To: <20130102063255.GA27676@open-mesh.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2013 07:32, Antonio Quartulli wrote:
> Hi Johannes,
> 
> On Fri, Dec 28, 2012 at 03:51:08 +0100, Johannes Berg wrote:
>> Anyway this part is really confusing. If userspace is handling auth
>> frames, should the kernel really mark the station as authenticated? What
>> then is the point in handling auth frames in userspace??

In IBSS mode, the "auth" state is essentially a no-op with the current code, just saying.

I do open system authentication in userspace, partly to fix these race conditions in a
clean way, and to have more control over it in a more convenient way. That way, it is
possible to hack things like retrying authentication at the user will if it failed the
first time.
I can also handle stations that do not answer auth frames much easier, such as skipping
open system authentication if the other station engage actually tries to authenticate with us.

>> Any chance we could converge on a single implementation here?
>>
> 
> Maybe yes :)
> 
> I think that leaving the station not AUTHenticated and let userspace do so would
> be the best approach..but then we need a way to enable userspace to do it :)

What would happen to old userspace that expect that to be done in the kernel ?
