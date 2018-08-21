Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50686 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbeHUVx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 17:53:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 21 Aug 2018 11:32:42 -0700
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
In-Reply-To: <1534757602.6287.4.camel@sipsolutions.net>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
 <1534323867.3547.30.camel@sipsolutions.net>
 <4aaa3a6185dbd116ba5c1a2ce76b691f@codeaurora.org>
 <1534407150.3547.58.camel@sipsolutions.net>
 <cd1e8ef5693b81c6b5d25eae36a44fd3@codeaurora.org>
 (sfid-20180818_095014_905997_2F2749FC)
 <1534757602.6287.4.camel@sipsolutions.net>
Message-ID: <dbd347a3434c05f48931559818dac8a1@codeaurora.org> (sfid-20180821_203246_210319_88EFB283)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-20 02:33, Johannes Berg wrote:
> On Sat, 2018-08-18 at 00:50 -0700, Pradeep Kumar Chitrapu wrote:
>> >
>> I will change the attribute to FLAG type, also add support for 
>> LCI/CIVIC
>> params and repost the patch.
> 
> Looking at Android (for unrelated reasons), I see that they have a
> separate "enable FTM responder" command:
> 
> https://android.googlesource.com/platform/hardware/interfaces/+/master/wifi/1.0/IWifiRttController.hal#158
> 
> Is that something you've seen/worked with? If so, how does it match 
> your
> current approach where FTM responder has to be enabled from the start?
> 
> Or perhaps this API is independent of AP and starts its own AP? But it
> doesn't have any setup for the SSID etc., only the channel, so not 
> clear
> how that'd work?
> 
> johannes

I wasn't aware of this android api. However, looking at the api, the 
assumption is that bss is started by a different
api and the 'enableResponder' api is used for enabling rtt for a given 
duration.

The reason we have added enabling ftm responder through start ap is that 
this can reflect beacon IE change in the
configuration in the same place. In case of the separate command, 
enabling responder will not update the beacon,
however, the application must issue the new command, whenever its 
updating beacon template.
Please let me know your thoughts/suggestions.

Pradeep
