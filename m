Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58375 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1LSNH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 08:07:58 -0500
Received: by dajs34 with SMTP id s34so3420449daj.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 05:07:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111219112845.C748820066@mail.watchdata.com.cn>
References: <4EED232D.3010208@lwfinger.net>
	<20111219112845.C748820066@mail.watchdata.com.cn>
Date: Mon, 19 Dec 2011 14:07:56 +0100
Message-ID: <CAGXE3d9vwwqFUhOW_swJwZjtJVAQuxtnXy1ovcB-Wa+AQeHaNw@mail.gmail.com> (sfid-20111219_140800_882526_F4A38B26)
Subject: Re: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: =?GB2312?B?wO641Q==?= <gang.li@watchdata.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/19 ภ๎ธี <gang.li@watchdata.com>:
> My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag before
> send a packet, but found it no use. It still wait for an ACK.

How did you verify that? For unicast frames with IEEE80211_TX_CTL_NO_ACK
set you will still see an ACK on the air (since the peer has to
generate it according
to the 802.11 spec). The only thing this flag does is to advise the hardware to
ignore a missing ACK and hence to not retry the frame in this case ...

Helmut
