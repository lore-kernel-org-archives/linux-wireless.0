Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51405.mail.re2.yahoo.com ([206.190.38.184]:30975 "HELO
	web51405.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933373Ab0DHUHh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:07:37 -0400
Message-ID: <195455.53971.qm@web51405.mail.re2.yahoo.com>
References: <282382.19639.qm@web51406.mail.re2.yahoo.com> <20100408194349.GA27848@jm.kir.nu>
Date: Thu, 8 Apr 2010 13:07:36 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: Any news regarding multicast rate configuration?
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100408194349.GA27848@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni,
do you mean that I can't configure a separate rate
for multicast frames? I thought that the rate bitmask
was a way to tell the RC algorithm what rates to
consider. Since multicast frames do not get acknowledged
they are not subject to the automatic rate selection.

In fact, I'm perfectly happy to leave the rate selection
for unicast frames in the capable hands of Minstrel, but
I need something better than 1Mb/s for multicast. The
lowest data rate just isn't enough for live video feeds.

What I need is a way to tell mac80211 to use one specific
basic rate for broadcast and multicast. 
 -- 
Regards 
Joerg 




----- Ursprüngliche Mail ----
> Von: Jouni Malinen <j@w1.fi>
> An: Joerg Pommnitz <pommnitz@yahoo.com>
> CC: linux-wireless@vger.kernel.org
> Gesendet: Donnerstag, den 8. April 2010, 21:43:49 Uhr
> Betreff: Re: Any news regarding multicast rate configuration?
> 
> On Thu, Apr 08, 2010 at 06:45:15AM -0700, Joerg Pommnitz wrote:
> sometime 
> ago I asked about a way to configure the multicast
> data rate for 
> mac80211 based drivers. At the time the answer
> was, that the groundwork 
> was in place but that this still
> needed an API that would make this 
> feature accessible for
> users.
> Is there any progress in this 
> regard? What needs to be done?

If you are fine with disabling the lowest 
> rates for both unicast and
multicast frames, then yes, you should be able to 
> do this with
NL80211_CMD_SET_TX_BITRATE_MASK. As an example, removing rates 
> 1, 2,
5.5, and 11 Mbps from the mask would make multicast frames go out at 
> 6
Mbps in case of 802.11g.

-- 
Jouni Malinen      
>                       
>                 PGP id EFC895FA

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
