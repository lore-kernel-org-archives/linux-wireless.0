Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34557 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1GUVzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 17:55:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qk1D2-0001VB-Ka
	for linux-wireless@vger.kernel.org; Thu, 21 Jul 2011 23:55:08 +0200
Received: from c-24-7-178-169.hsd1.ca.comcast.net ([24.7.178.169])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 23:55:08 +0200
Received: from bugtrack2 by c-24-7-178-169.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 23:55:08 +0200
To: linux-wireless@vger.kernel.org
From: Vic O <bugtrack2@gmail.com>
Subject: Re: ath9k<-->ath9k ad-hoc does not associate
Date: Thu, 21 Jul 2011 21:49:35 +0000 (UTC)
Message-ID: <loom.20110721T233131-976@post.gmane.org> (sfid-20110721_235514_309048_6FC5349F)
References: <489C5B6C.4030108@ozo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>Alexandros C. Couloumbis <alex <at> ozo.com> writes:

> iwconfig, ifconfig & iwlist wlan0 scan from the wrap board:
> 
> wlan0     IEEE 802.11abgn  ESSID:"awmn"
>           Mode:Ad-Hoc  Frequency:5.745 GHz  Cell: 0E:18:12:1E:75:73
>           Tx-Power=23 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>           Encryption key:off
>           Power Management:off
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 

> 
> iwconfig, ifconfig & iwlist wlan0 scan on the alix board:
> 
> wlan0     IEEE 802.11abgn  ESSID:"awmn"
>           Mode:Ad-Hoc  Frequency:5.745 GHz  Cell: E6:FE:0E:A1:77:22
>           Tx-Power=23 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>           Encryption key:off
>           Power Management:off
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> 
This reply is almost a year in the making, but it looks like 
your ad-hoc interfaces are creating new cells(new IBSS) 
on initialization (you'll see that the 48-bit cell IDs are different).
 Thus, even though they are on the same channel, same ESS ("awmn") 
and within wireless range, they can't talk.

The 802.11 standards for IBSS (ad-hoc) mode specifies that 
this problem should be solved by having the first interface to 
establish a BSS periodically broadcasting a beacon so that newer 
nodes get this beacon and associate to that cell.

However, for some reason ath9k doesn't handle this problem 
correctly (ath5k did a good job with it). 

In the meantime, you can specifically set the cell ID using 
the iw command on all your interfaces (in this case the cell 
ID is the 48-bit value made up of twos).


iw dev wlan0 ibss join "awmn" 5745 22:22:22:22:22:22




