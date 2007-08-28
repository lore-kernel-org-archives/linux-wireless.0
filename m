Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.172]:31120 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbXH1Fyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 01:54:36 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-ext13.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id l7S5sLCg008157
	for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2007 08:54:33 +0300
Received: from tikku (essapo-nirac252124.europe.nokia.com [10.162.252.124])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id l7S5sSkt000750
	for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2007 08:54:28 +0300
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: which hostapd version for which wireless driver
References: <20070827223833.GA15515@seehuhn.de>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Tue, 28 Aug 2007 08:54:28 +0300
In-Reply-To: <20070827223833.GA15515@seehuhn.de> (ext Jochen Voss's message of "Mon\, 27 Aug 2007 23\:38\:33 +0100")
Message-ID: <871wdouru3.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ext Jochen Voss" <voss@seehuhn.de> writes:

> I am trying to get hostapd up and running on my Soekris net4521 board,
> until now without much success.  One of the problems might be that I
> am completely at a loss which version of hostapd is supposed to work
> together with which driver.

I tried hostapd for the first time last night and it worked with my
old PII laptop and b43. So it should work :)

> Any help about which combinations of hostapd and device driver have at
> least a chance of working together would be more than welcome.

I used latest git for both the kernel and hostapd. My notes here:

http://marc.info/?l=linux-wireless&m=118823232032439&w=2

>     root@funk [~] iwconfig wlan1 mode master
>     root@funk [~] iwconfig wlan1 essid "SR20"
>     root@funk [~] iwconfig wlan1 channel 6
>     root@funk [~] iwconfig wlan1 rate 11M

I did not issue these commands, but I don't know if it makes any
difference in practice.

>     root@funk [~] ifconfig wlan1 up

I think I didn't do this, but can't be sure anymore.

My advice is to double check that you are really using the correct
hostapd compiled for the kernel you are running. And did you remember
to do make clean for hostapd between compilations?

-- 
Kalle Valo
