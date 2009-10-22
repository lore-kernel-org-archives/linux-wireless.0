Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51411.mail.re2.yahoo.com ([206.190.39.152]:31962 "HELO
	web51411.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755670AbZJVNYL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:24:11 -0400
Message-ID: <77313.17791.qm@web51411.mail.re2.yahoo.com>
References: <868263.12588.qm@web51404.mail.re2.yahoo.com> <b6c5339f0910220608u2183d40cldec6ea427efc60d1@mail.gmail.com>
Date: Thu, 22 Oct 2009 06:17:33 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: RE: ath5k with two NICs runing IBSS and AP mode simultaneously causes  error
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <b6c5339f0910220608u2183d40cldec6ea427efc60d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interesting. I tried to reproduce this problem and couldn't so I assumed that this was just a fluke.

By the way, please have a look at http://marc.info/?l=linux-wireless&m=125621556504279&w=2
I don't have an ath5k trace (yet), but I think this might be a problem shared by ath5k and ath9k.

 -- 
Regards 
Joerg 




----- Ursprüngliche Mail ----
Von: Bob Copeland <me@bobcopeland.com>
An: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org; ath5k-devel@lists.ath5k.org
Gesendet: Donnerstag, den 22. Oktober 2009, 15:08:32 Uhr
Betreff: Re: ath5k with two NICs runing IBSS and AP mode simultaneously causes  error

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



      
