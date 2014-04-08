Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51927 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaDHI7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:59:53 -0400
Received: by mail-vc0-f179.google.com with SMTP id ij19so512710vcb.10
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 01:59:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396947132.5936.5.camel@jlt4.sipsolutions.net>
References: <1396411509-4660-1-git-send-email-yeohchunyeow@gmail.com>
	<1396947132.5936.5.camel@jlt4.sipsolutions.net>
Date: Tue, 8 Apr 2014 16:59:53 +0800
Message-ID: <CAEFj986dM9S9=SYUL1CZz8cNNgbhScDn-_Rz_2-hgv_9+K0D4Q@mail.gmail.com> (sfid-20140408_105957_408581_DB73293C)
Subject: Re: [PATCH] mac80211: update last_tx_rate only for data frame
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 8, 2014 at 4:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-04-02 at 12:05 +0800, Chun-Yeow Yeoh wrote:
>> Rate controller in firmware may also return the Tx Rate
>> used for management frame that is usually sent as lowest
>> Tx Rate (1Mbps in 2.4GHz). So update the last_tx_rate only
>> if it is data frame.
>
> I guess this makes some sense, although maybe the rate shouldn't be
> reported then?

If you are referring to the last_tx_rate, we are using this to
calculate the Airtime Link Metric in the mesh mode.

----
Chun-Yeow
