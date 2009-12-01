Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:51994 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZLANSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 08:18:03 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: cfg80211: questions regarding cfg80211_ibss_joined()
Date: Tue, 1 Dec 2009 14:17:34 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200912011347.38068.holgerschurig@gmail.com> <1259672064.32171.76.camel@johannes.local>
In-Reply-To: <1259672064.32171.76.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912011417.34706.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Are you running into the WARN_ON(!bss)?

No, I didn't get a bug, warning nor any output.


In the mean-time I found that this was because I didn't provide 
any IE (I just submitted NULL & 0 to cfg80211_inform_bss).

Now I make a fake-IE with just WLAN_EID_SSID, and now I get 
some "iw event" output:

# iw event
wlan0 (phy #0): IBSS 02:2a:ea:f0:a5:ef joined




> >    need to fake some beacon data. Correct?  Which IEs should 
> >    I add?
> 
> As close to what your firmware is generating as you can get ...

Okay, will fire up wireshark :-)


-- 
http://www.holgerschurig.de
