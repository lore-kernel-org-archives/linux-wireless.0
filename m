Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732489AbeHPEps (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 00:45:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 15 Aug 2018 18:50:52 -0700
From: pradeepc@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
In-Reply-To: <1534323867.3547.30.camel@sipsolutions.net>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
 <1534323867.3547.30.camel@sipsolutions.net>
Message-ID: <4aaa3a6185dbd116ba5c1a2ce76b691f@codeaurora.org> (sfid-20180816_035200_871224_FADC43C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-15 02:04, Johannes Berg wrote:
> On Tue, 2018-08-14 at 17:30 -0700, Pradeep Kumar Chitrapu wrote:
>> Currently ftm_responder parameter in hostapd.conf is only used for 
>> fine
>> timing measurement (FTM) capability advertisement and actual control 
>> of
>> the functionality is with low-level device/driver. This leads to 
>> confusion
>> to the user when the capability advertisement is different from actual 
>> FTM
>> responder functionality.
>> 
>> For example, FTM responder capability advertisement is set to 
>> 'disabled',
>> which would imply that AP must not respond to FTM requests, but user 
>> sees
>> AP still responding to FTM requests, as the functionality is enabled 
>> in
>> the driver.
> 
Hi Johannes,
Thanks for the review..

> All you describe above is really a driver bug - it shouldn't have
> enabled it to start with?

Sure.. But isn't it justifiable for drivers/firmware choosing to enable
ftm responder by default when there is no way for userspace to specify 
this
parameter?

> 
>> The patch set allows userspace to configure FTM responder 
>> functionality
>> with the addition of new Netlink attribute NL80211_ATTR_FTM_RESPONDER
>> and also adds extended feature flag for the drivers to advertise the
>> support. Sending '0' to disable FTM responder would imply AP does not
>> respond to FTM requests and sending '1' to enable FTM responder would
>> imply that AP responds to all FTM requests.
> 
> This makes sense anyway. Funny you should post this within hours of me
> doing the same, basically.
Sorry, I missed your patches before posting mine :)

> 
> I have no objection to your approach, though I guess it'd be nice if 
> you
> could take a look at the statistics I have exposed and see if those
> makes sense or if additional ones are desirable for you, and then we 
> can
> combine the work that way, i.e. have your configuration and our stats?

I looked at the patch you posted and this makes sense. I will try to 
align
ath10k driver changes with your approach.

Thanks
Pradeep
> 
> johannes
