Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:53567 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZELVAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 17:00:51 -0400
Received: by bwz22 with SMTP id 22so230519bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 14:00:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890905121259jeb504d7v78fe8f062fca7d21@mail.gmail.com>
References: <1242125077.4331.0.camel@johannes.local>
	 <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
	 <3ace41890905121208s2029db39p730b2e174cd4b1e6@mail.gmail.com>
	 <1242156469.14227.7.camel@johannes.local>
	 <3ace41890905121259jeb504d7v78fe8f062fca7d21@mail.gmail.com>
Date: Tue, 12 May 2009 22:00:49 +0100
Message-ID: <3ace41890905121400g471d14bfn3f60fba77e097079@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 5/12/09, Johannes Berg <johannes@sipsolutions.net> wrote:
>> I have now tested WPA-PSK and WEP with wpa_supplicant and WEP with
>> manual configuration and it all works.

Tried again and it still won't work with NM/wpa_supplicant. FWIW, the
manual way I do it is this:

ifconfig wlan2 up
iwconfig wlan2 ESSID <apname>
iwconfig wlan2 key restrict <key>
iwconfig wlan2 AP <apip>
dhclient wlan2

killing dhclient then runs '/etc/rc.d/init.d/NetworkManager start'
usually switches back to nm-managed connection. (most of the same info
is stored in keyring, so nm-applet re-appears and starts spinning and
some seconds later I get the signal bars).
