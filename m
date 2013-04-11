Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-5.exch022.serverdata.net ([64.78.56.50]:21319 "EHLO
	HUB022-ca-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061Ab3DKFVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 01:21:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Date: Wed, 10 Apr 2013 22:21:44 -0700
From: <vivekanandah@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Patch] mac80211: SMPS for AP Mode
In-Reply-To: <1365592730.8388.8.camel@jlt4.sipsolutions.net>
References: <516541FD.9050109@posedge.com>
 <1365592730.8388.8.camel@jlt4.sipsolutions.net>
Message-ID: <403b23c5df64cb4e0d6ffbabb7ca804f@posedge.com> (sfid-20130411_072150_579881_0CE68ECA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi johannes,

my first patch was based on the premise that an AP cannot switch its 
receive chains off as it would be servicing multiple clients.
i was not aware if an AP can set SMPS at its end, hence i wanted to 
make sure that control be provided to the lower layer driver to take a 
call on the same.

in my hurry to submit my first patch, i did overlook the MCS rate 
dependency and accept my mistake.

i have outlined three requirements based on my understanding for SMPS 
code and have also incorporated a code snippet. if you are okay with the 
code snippet, i will provide a patch for the same.

1) check if the receiving station has Dynamic SMPS on
2) check if the current MCS rate is greater than a single stream rate 
for the first rate
3) if conditions 1 and 2 are true, set the RTS_CTS flag for the first 
rate that will
    be attempted to be transmitted

  if ((sta->smps_mode == IEEE80211_SMPS_DYNAMIC) && (ar[0].idx > 7))
         ar[0].flags |= IEEE80211_TX_RC_USE_RTS_CTS;

i respect the time you have spent on looking into my code and apologize 
for the inconvenience caused. this is my first patch submission and i 
have made some mistakes :)

thanks and regards
Vivek


On Wed, 10 Apr 2013 13:18:50 +0200, Johannes Berg wrote:
> On Wed, 2013-04-10 at 16:12 +0530, Vivekananda Holla wrote:
>> patch for SMPS mode. after discussion, setting the 
>> IEEE80211_TX_RC_USE_RTS_CTS flag for first rate if dynamic SMPS is on 
>> in the receiving station
>
> Please line-break your description and remove all the 
> discussion-related
> stuff etc. from the commit log -- see
> 
> http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
>
> Also, it should set the flag depending on the MCS ... Please try to
> understand what you're actually doing and trying to do before 
> submitting
> random patches. It's not an effective use of my time to be reviewing
> patches if you don't know what you're doing.
>
> johannes
