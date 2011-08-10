Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51666 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1HJABn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 20:01:43 -0400
Received: by qwk3 with SMTP id 3so276292qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 17:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312808606.4372.16.camel@jlt3.sipsolutions.net>
References: <1311695709.2974.15.camel@alex-2> <1312808606.4372.16.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Aug 2011 17:01:21 -0700
Message-ID: <CAB=NE6XWzWieSZ1ktqAM7_gMqNYrF4xuX8BNQM2aH1KQ2TSESQ@mail.gmail.com> (sfid-20110810_020147_741101_1D13D916)
Subject: Re: mac80211: ibss.c, missing regdom check?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexander Simon <alexander.simon@saxnet.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 6:03 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-07-26 at 17:55 +0200, Alexander Simon wrote:
>
>> When we want to join an IBSS, we first fire a scan. When a network is
>> found, then we join it.
>> This happens in ieee80211_sta_find_ibss when we call
>> ieee80211_sta_join_ibss.
>>
>> But in both functions there is no check if we are allowed to do IBSS on
>> that channel.
>> Is this intended?
>> I could join an existing network on channel 8 with a modified crda
>> having the NO-IBSS flag on all 2.4GHz channels.
>
> Sounds like there ought to be a check -- but what do we do in that case?
> Just create the network elsewhere and hope the other one merges? Luis?

Indeed, additionally based on the htcaps we must also ensure that we
follow the exisitng regulatory rules. A base example is provided
through ieee80211_enable_ht(). A similar check will be implemented to
start Mesh for example. This must also ensure that when you set the
channel type with iw, say, iw dev wlan0 set freq 2412 HT20 that you
switch to using only HT20 and not HT40. If you do not set HT20 or HT40
then you should not use HT on an IBSS.

Let me know if you are up to try the changes otherwise I can work on them.

  Luis
