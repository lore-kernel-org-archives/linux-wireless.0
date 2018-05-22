Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34156 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752675AbeEVVLV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 17:11:21 -0400
Message-ID: <1527023478.6787.60.camel@sipsolutions.net> (sfid-20180522_231125_128548_9AE043B0)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>
Cc: Tim Kourt <tim.a.kourt@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 22 May 2018 23:11:18 +0200
In-Reply-To: <D2E91785-58E3-46FA-94B9-879E621D5049@gmail.com> (sfid-20180522_230705_275847_981AACBF)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         <1526631206.3805.1.camel@sipsolutions.net>
         <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
         <1527019967.6787.45.camel@sipsolutions.net>
         <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
         <1527021608.6787.47.camel@sipsolutions.net>
         <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com>
         <1527022332.6787.51.camel@sipsolutions.net>
         <D2E91785-58E3-46FA-94B9-879E621D5049@gmail.com>
         (sfid-20180522_230705_275847_981AACBF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-22 at 16:00 -0500, Denis Kenzior wrote:

> > > So what's the practical use of the flush flag?  Or is that something 
> > > that was meant to be 'for-testing-only'?
> > 
> > I think you misunderstand? The value is that it ensures that nothing is
> > present in the list that was received *before* the scan.
> > 
> 
> We misunderstood how it was supposed to work, but no, I get how things
> work now. 

FWIW, even what I said above was slightly lying I think (though I'd have
to go check the code). That's actually what I thought had happened
before, though the timestamps should've allowed you to realize this, and
it wasn't the case here afaict.

But in theory, I think you could've received the beacon with hidden SSID
*before* the scan, yet it might be present in the scan results if the
new scan caused the probe response to be associated with that scan.

> I’m just curious what other potential uses this flag might have.

Well, basically, ensure that your scan data is up-to-date?

I think mostly it's because there are scenarios where the AP is expected
to vary the probe response data, so you need to know if you
 * have a new probe response, or
 * didn't receive a new probe response, or
 * the AP erroneously didn't change the new probe response.

johannes
