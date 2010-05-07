Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:43787 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab0EGQW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 12:22:57 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id B2C1C3842C
	for <linux-wireless@vger.kernel.org>; Fri,  7 May 2010 18:13:13 +0200 (CEST)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id axbTC99k4R4v for <linux-wireless@vger.kernel.org>;
	Fri,  7 May 2010 18:13:13 +0200 (CEST)
Received: from [192.168.9.133] (unknown [192.168.9.133])
	by aurora.create-net.org (Postfix) with ESMTPSA id 0F1BF38422
	for <linux-wireless@vger.kernel.org>; Fri,  7 May 2010 18:13:13 +0200 (CEST)
Message-ID: <4BE43C18.2030806@create-net.org>
Date: Fri, 07 May 2010 18:13:12 +0200
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Packet injection with ath9k
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm writing an application to inject traffic over a wireless interface. 
This app
is working fine on an x86 machine. However if i compile the same app for
an arm platform, no frame are sent over the wireless interface (ath9k).

I'm guessing that this is because of some alignment issues but i cannot 
track
the piece of code that is actually parsing the frame. I've found the
__ieee80211_parse_tx_radiotap in net/mac80211/tx.c function, but it is
not called when i try to inject some traffic, so the frame are dropped
before that.

Any hints?

Thanks
R.
