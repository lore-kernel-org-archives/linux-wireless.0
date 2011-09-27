Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3546 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab1I0KIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 06:08:34 -0400
Message-ID: <4E81A098.9040708@broadcom.com> (sfid-20110927_120837_767994_9F234955)
Date: Tue, 27 Sep 2011 12:08:24 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Questions on ieee80211_frame_duration()
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

in response to one of your brcm80211 review comments, I am trying to 
replace functions that calculate frame duration with Mac80211 counterparts.

As such, I have a hard time grasping this function:

http://lxr.free-electrons.com/source/net/mac80211/util.c#L108

A couple of questions:

a. The comment in the 'else' branch does not mention 802.11n, but I 
think it should. Agree ?

b. The long/short preamble choice applies to CCK rates only. But this 
function does not take that into account. Is that on purpose ?

c. In 802.11n there are 4 preamble types possible:
- long (CCK rates)
- short (CCK rates)
- green field
- mixed mode

The function does not seem to take the last two types into account. 
Should it ?

Bye, Roland.

