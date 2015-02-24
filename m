Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36987 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbbBXK23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:28:29 -0500
Received: by wghk14 with SMTP id k14so4299154wgh.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 02:28:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424772587.2192.14.camel@sipsolutions.net>
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com> <1424772587.2192.14.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 24 Feb 2015 15:58:07 +0530
Message-ID: <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com> (sfid-20150224_112832_461802_E89B7D61)
Subject: Re: Connection issues with BW Tracking in mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2015 at 3:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-02-20 at 02:58 +0530, Krishna Chaitanya wrote:
>
>> Before that i have a basic question? Should we reset our tracking after
>> the connection is lost, in my case above the connection was lost (Config
>> change in A triggers a reboot), still mac80211 is tracking the BW changes?
>
> Huh??
>
> So the AP does restart, but mac80211 tries to stay connected to it? That
> seems pretty unlikely. The tracking *shouldn't* have any knowledge of
> what happened before the association, but there could be bugs in the
> flags assignment I guess.
Let me explain the sequences.

STA (mac80211) connects to AP in VHT-80.
AP is reconfigured to 11n40 (stops beaconing for about 30secs and then
starts again).
STA loses connection (HW_CONN_TRACK), iee80211_connection_loss is called.
STA see's AP again and tries to connect, but due to BW tracking in
mac80211 it doesn't connect.

So i guess we are not resetting the tracking after losing connection.
