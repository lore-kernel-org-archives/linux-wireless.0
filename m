Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fm1nodo1.polito.it ([130.192.180.11]:60415 "EHLO
	antispam.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbaIWLow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 07:44:52 -0400
Message-ID: <1411472676.11571.51.camel@MacGyver> (sfid-20140923_134456_452894_91A568D3)
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
From: Guido Gavilanes <gavilanes@ismb.it>
Reply-To: gavilanes@ismb.it
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: nbd@openwrt.org
Date: Tue, 23 Sep 2014 13:44:36 +0200
Content-Type: multipart/mixed; boundary="=-3CfxyI3dDjM2LbRoHld2"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3CfxyI3dDjM2LbRoHld2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

I write here since I am currently performing experiments in which I need
specifically to disable RTS frames. Intuitively, I tried to set 
iw phyXX set rts off
but btained counter-intuitive results, since RTS effectively
dissappeared
only for low traffic demands from upper layers (around 1Mbps  with 3
nodes). Testing with 3 Mbps makes the RTS appear despite the RTS "off"
setting from iw.
Is there a way to set minstrel_ht not to use RTS (no matter the clever
or not it be) ?
I have searched for a while on the archive but this seems the only
conversation that deals with that.

Thank you very much for any information!
Guido

-- 
Guido Gavilanes <gavilanes@ismb.it>
Istituto Superiore Mario Boella


--=-3CfxyI3dDjM2LbRoHld2
Content-Disposition: inline
Content-Description: Forwarded message - Re: [PATCH] mac80211: minstrel_ht
 should not override user supplied rts setting
Content-Type: message/rfc822

Message-ID: <1411467050.11571.47.camel@MacGyver>
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user
 supplied rts setting
From: Guido Gavilanes <gavilanes@ismb.it>
Reply-To: gavilanes@ismb.it
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, simon.wunderlich@s2003.tu-chemnitz.de,
 lindner_marek@yahoo.de
Date: Tue, 23 Sep 2014 12:10:50 +0200
In-Reply-To: <1339408392-19425-10-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
	 <1339408392-19425-10-git-send-email-johannes@sipsolutions.net>
Organization: Istituto Superiore Mario Boella
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

I write here since I am currently performing experiments in which I need
specifically to disable RTS frames. Intuitively, I tried to set 
iw phyXX set rts off
but btained counter-intuitive results, since RTS effectively dissappear
only for low traffic demands from upper layers (around 1Mbps  with 3
nodes). Testing with 3 Mbps make the RTS appeared despite the RTS
setting.
Is there a way to set minstrel_ht not to use RTS (no matter the clever
or not it is) ?
I have searched a bit on the archive but this seems the only
conversation that deals with that.

Thank you very much for any information!
Gui


On 2012-01-28 11:14 PM, Simon Wunderlich wrote:
> I agree to Marek here - if I want to disable RTS (for whatever
reason), I type
> 
> iw phy0 set rts off
> 
> I would expect to see no RTS frames coming from my WiFi card at all.
If the
> rate control algorithm (whether ath9k or minstrel_ht) wants to be
clever, it should
> still respect this decision. The oven in my kitchen also has a
temperature regulator,
> but if I turn it off I also don't want my oven to be too clever and
burn down the house. ;)
> 
> I know, apples and oranges, but I hope this makes this point
understandable. I also
> had quite a debugging night to find the reason for these "wild rts"
frames.
> 
> Can't we add something two states, like:
>  * "RTS really off" and
>  * "RTS usually off, but rc's may still use it" ?
If you send a patch for that, I'm ok with it. The default should be RTS
off, but rc may still use it.

- Feli
--
To unsubscribe from this list: send the line "unsubscribe
linux-wireless" in
the body of a message to majordomo@...
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-3CfxyI3dDjM2LbRoHld2--

