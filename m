Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:39738 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250Ab2EVD7t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 23:59:49 -0400
From: Amit SHAKYA <amit.shakya@stericsson.com>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless (linux-wireless@vger.kernel.org)"
	<linux-wireless@vger.kernel.org>,
	"Johannes Berg (johannes@sipsolutions.net)"
	<johannes@sipsolutions.net>
Date: Tue, 22 May 2012 05:59:16 +0200
Subject: RE: [PATCH] mac80211: Handle race condition in replay handling
Message-ID: <ECD438FDEF6BD742895E554C24725A40229472E35E@EXDCVYMBSTM005.EQ1STM.local> (sfid-20120522_055952_990902_4A230BBD)
References: <ECD438FDEF6BD742895E554C24725A4022946BBD16@EXDCVYMBSTM005.EQ1STM.local>
 <20120518133935.GA13088@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

Some more additional information:

In our solution,
1. Decryption happens in FW. 
2. Reordering and replay detection happen in MAC.

-----Original Message-----
From: Amit SHAKYA 
Sent: Monday, May 21, 2012 6:13 PM
To: 'Jouni Malinen'
Cc: John W. Linville; linux-wireless (linux-wireless@vger.kernel.org); Johannes Berg (johannes@sipsolutions.net)
Subject: RE: [PATCH] mac80211: Handle race condition in replay handling

Hi Jouni,

My comments inline [AS]:

-----Original Message-----
From: Jouni Malinen [mailto:j@w1.fi] 
Sent: Friday, May 18, 2012 7:10 PM
To: Amit SHAKYA
Cc: John W. Linville; linux-wireless (linux-wireless@vger.kernel.org); Johannes Berg (johannes@sipsolutions.net)
Subject: Re: [PATCH] mac80211: Handle race condition in replay handling

On Thu, May 17, 2012 at 11:40:16AM +0200, Amit SHAKYA wrote:
> Added fix for the issue where the Rx throughput use to get stuck,
> with unicast key rotation feature enabled in the Cisco AP.
> The issue is that due to race condition during EAPOL key
> handshake and packet reception, the PN gets reset at MAC, while
> it still receives previous PN range packets for a while from AP.

How would that happen? I would assume the previous PN range is still
used with the old key and as such, the PN updates should not be accepted
for the new key.

[AS] What I mean here is that the during the period when the EAPOL is
received by supplicant till new key is applied (PN reset) at FW, there is
some delay. During which, due to ongoing high throughput, some packets are
received which are decrypted by FW with old key and had been handed
over to host driver but not yet delivered to MAC or are in transit from
FW to the host driver to be finally delivered to MAC. They have been
decrypted successfully by the FW using the old key during this phase
but not yet received by MAC.

> At MAC, there is a memcpy of the PN from the received PN
> and as a result the maintained PN is overwritten with the
> previous PN sequence value after being reset at the time, new
> key is plumbed by supplicant.
> 
> As a result, when this change in sequence number happens, the
> replay detection handling in MAC gets triggered, causing the
> traffic to stops for some while till PN re-match, with the
> one last updated at MAC.
> 
> The fix takes care of selectively updating the Rx PN during
> this transition phase.

This sounds incorrect.. I don't really like the idea of adding the extra
hack here and the additional memcmp() calls either.

Would you be able to provide more detailed description on how the PN
values are used based on the key (old/new) and how the PN value for the
new key gets updated based on the old range?

[AS] In the race condition scenario, i.e. new key updated at MAC and
MAC receiving packets from driver, __ieee80211_key_replace function is invoked
to apply the new keys. It replaces the key entry in sta->ptk to the new key
entry (PN reset to 0). Note the sta is connected all this while and just the
PTK is renewed.
However due to race condition mentioned above, it is still receiving old PN
packets from driver. At this point of time on receiving old PN packets, 
ieee80211_rx_h_decrypt will just dereference the new key entry from
rx->sta->ptk and store it in rx->key.


Refer code
	if (rx->sta)
		sta_ptk = rcu_dereference(rx->sta->ptk);

...
	if (!is_multicast_ether_addr(hdr->addr1) && sta_ptk) {
		rx->key = sta_ptk;


Now within ieee80211_crypto_ccmp_decrypt function, this key is dereferenced and
used for key replay detection as well as the received PN is also updated in it.
 	memcpy(key->u.ccmp.rx_pn[queue], pn, CCMP_PN_LEN);

This triggers the issue wherein the PN gets updated with the old PN and mentioned
issue happens.

Hope this explains. 
Please let me know, in case more details are required.

-- 
Jouni Malinen                                            PGP id EFC895FA
