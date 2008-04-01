Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:63290 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbYDAXvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 19:51:54 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JYO007O768BFCF0@mta2.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Tue, 01 Apr 2008 19:21:48 -0400 (EDT)
Date: Tue, 01 Apr 2008 19:21:47 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: RE: problem with iwl4965 and kernel 2.6.24.4
To: linux-wireless@vger.kernel.org
Message-id: <1207092107.12301.18.camel@X61.NetworkingUnlimited.com> (sfid-20080402_005156_796457_17269424)
MIME-version: 1.0
Content-type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It should not be necessary to use both iwconfig and wpa_supplicant.
> wpa_supplicant will take care of the association for you. 
> 
> You will need to bring the interface up (ifconfig wlan0 up) before you
> run wpa_supplicant.
> 
> If you run into issues, please also send wpa_supplicant's configuration
> and debug log.
> 
> Thanks
> 
> Reinette

Agree, it should not be necessary to use both iwconfig &
wpa_supplicant, but somewhere between the last official release for
Intel 4965 and the latest the 3/27/2008 release, it has become
necessary, at least for some of us. SuSE 10.3, all kernels tried from
2.6.22 through 2.6.25-rc4. Some data points which might give you a clue:

I only have the problem with 802.11a channels. 2.4GHz associations seem
to work flawlessly (at least until someone uses the phone or microwave
oven :-). 

The scan function in wpa_supplicant (using wpa_gui) returns channel
zero for 802.11A APs rather than the correct channel (I have one on 44
and one on 149). That is, when it reports seeing the APs at all.

Building from the "stable" 1.2.25 iwlwifi bits on Intel's site,
wpa_supplicant works correctly, both in reporting channels and
associating without help from iwconfig.

Incidentally, should the 802.11n work using 802.11n draft on 5Ghz? 

Vince


