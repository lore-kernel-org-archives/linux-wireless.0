Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:57967 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZALJDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 04:03:39 -0500
Received: by bwz14 with SMTP id 14so31758552bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 01:03:37 -0800 (PST)
Message-ID: <da94abde0901120103v6ce9c8abta1fa7e6bb78c2b1d@mail.gmail.com> (sfid-20090112_100402_258603_AE657493)
Date: Mon, 12 Jan 2009 11:03:37 +0200
From: "Kalle Valo" <kalle.valo@iki.fi>
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Subject: Re: [RFC PATCH v1 2/2] mac80211: use ps-poll to request frames in power save mode
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4100901120057n4cea722fo1a78bcbc45341d00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090111070148.3849.10799.stgit@tikku>
	 <20090111070353.3849.5303.stgit@tikku>
	 <8e92b4100901120057n4cea722fo1a78bcbc45341d00@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 12, 2009 at 10:57 AM, Vivek Natarajan
<vivek.natraj@gmail.com> wrote:
> On Sun, Jan 11, 2009 at 12:33 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> When a directed tim bit is set, mac80211 currently disables power save
>> and sends a null frame to the AP. But if dynamic power save is
>> disabled, mac80211 will not enable power save again.
>
> The patch I had sent earlier, 'mac80211: Reset the power save timer
> from master_start_xmit' (44378a8e64b9399...) addresses this issue.
> This enables mac80211 to start the dynamic ps timer after sending a
> null data frame. Hence when the specified time lapses, power save is
> enabled again.

Not based on my tests. Then I tested this few days back power save
mode was suddenly disabled after few seconds and never enabled again.
Please note that his was without dynamic power save, ie. 'iwconfig
wlan0 timeout 0'.

Kalle
