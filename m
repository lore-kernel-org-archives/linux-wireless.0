Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:52027 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3JBMwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 08:52:54 -0400
Received: by mail-oa0-f53.google.com with SMTP id i7so694605oag.40
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 05:52:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380708715.13329.16.camel@jlt4.sipsolutions.net>
References: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1380704100.13329.6.camel@jlt4.sipsolutions.net>
	<CAA2SeN+nhLU7vGDNLJCD=UrNRSFm5hT6HGEEhUqr1kAcMF3O-A@mail.gmail.com>
	<1380708715.13329.16.camel@jlt4.sipsolutions.net>
Date: Wed, 2 Oct 2013 14:52:54 +0200
Message-ID: <CAA2SeNLFSN0tAyABk=MoFDxS6purc6Tgx6R-U5xhuRJZRCZ6ig@mail.gmail.com> (sfid-20131002_145257_840784_1217ABC7)
Subject: Re: [PATCH] mac80211: allow mgmt frame transmission on DFS channels
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am not using latest mac80211/hostapd (in particular
compat-wireless-2013-04-16/hostapd-20130807) because I have to port
some personal stuff. In this scenario I was not able to establish an
AP/STA connection on DFS channel. Anyway I will update these packages.

Lorenzo

2013/10/2 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2013-10-02 at 12:07 +0200, Lorenzo Bianconi wrote:
>> Before start beaconing cfg80211_reg_can_beacon() verifies the channel
>> is CAC checked and available calling cfg80211_secondary_chans_ok().
>> Although the channel is marked NL80211_DFS_AVAILABLE after a CAC
>> period, ieee80211_monitor_start_xmit() does not allow to inject mgmt
>> frames on DFS channels causing association failures.
>
> I don't see how this can cause association failures? Please explain.
> DFS-capable hostapd doesn't use monitor interfaces with mac80211 any
> more.
>
> johannes
>



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
