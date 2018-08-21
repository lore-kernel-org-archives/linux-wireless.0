Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:37156 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbeHUWpx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 18:45:53 -0400
Message-ID: <1534879459.25523.48.camel@sipsolutions.net> (sfid-20180821_212430_433649_CC014082)
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 21:24:19 +0200
In-Reply-To: <dbd347a3434c05f48931559818dac8a1@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
         <1534323867.3547.30.camel@sipsolutions.net>
         <4aaa3a6185dbd116ba5c1a2ce76b691f@codeaurora.org>
         <1534407150.3547.58.camel@sipsolutions.net>
         <cd1e8ef5693b81c6b5d25eae36a44fd3@codeaurora.org>
         (sfid-20180818_095014_905997_2F2749FC) <1534757602.6287.4.camel@sipsolutions.net>
         <dbd347a3434c05f48931559818dac8a1@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 11:32 -0700, Pradeep Kumar Chitrapu wrote:
> 
> I wasn't aware of this android api.

OK.

> However, looking at the api, the 
> assumption is that bss is started by a different
> api and the 'enableResponder' api is used for enabling rtt for a given 
> duration.

It looks like. Note that there's also *disable*, which we hadn't even
implemented before.

> The reason we have added enabling ftm responder through start ap is that 
> this can reflect beacon IE change in the
> configuration in the same place. 

Which makes sense, yeah.

> In case of the separate command, 
> enabling responder will not update the beacon,
> however, the application must issue the new command, whenever its 
> updating beacon template.

Right. However, I guess we could allow updating/changing this setting on
the fly through nl80211_set_beacon() which already allows changing other
non-beacon parameters (like the probe or assoc response templates), and
then we can use your approach. Basically changing "SET_BEACON" to be a
bit like "CHANGE_AP". In that case we definitely would need the
attribute to be 0/1 as you had it so that it not present can be used to
indicate "no change".

johannes
