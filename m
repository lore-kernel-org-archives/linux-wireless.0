Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:64494 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbZJVNI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:08:29 -0400
Received: by qyk32 with SMTP id 32so5204426qyk.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2009 06:08:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <868263.12588.qm@web51404.mail.re2.yahoo.com>
References: <868263.12588.qm@web51404.mail.re2.yahoo.com>
Date: Thu, 22 Oct 2009 09:08:32 -0400
Message-ID: <b6c5339f0910220608u2183d40cldec6ea427efc60d1@mail.gmail.com>
Subject: Re: ath5k with two NICs runing IBSS and AP mode simultaneously causes
	error
From: Bob Copeland <me@bobcopeland.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2009 at 7:01 AM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:

> ath5k phy0: no further txbuf available, dropping packet.
> The timing makes it very likely that the hostapd on wlan1 disturbed the iperf run on wlan0. Is this a known problem? Is there something I can do to help track this down?

It is a known problem - please do try to track it down.

I think a good place to start is looking at the creation
of tx descriptors, particularly for the beacon and CAB
queues, and make sure they are properly released.  Maybe
printing out a high-water mark of the created vs available
descriptors when transmitting packets would be a useful
data point.

BTW the reason all traffic stops is that we stop the queues
but don't re-enable them in that case -- we should probably
set a timer or something to recover from that situation.

-- 
Bob Copeland %% www.bobcopeland.com
