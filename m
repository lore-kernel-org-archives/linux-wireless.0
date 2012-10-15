Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53206 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2JOOPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 10:15:09 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2483053bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2012 07:15:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Krishnan Manivannan <krishnan.manivannan@sasken.com>
Subject: Re: Receive all data packets in Managed mode
Date: Mon, 15 Oct 2012 16:14:52 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DBA@EXGMBX01.sasken.com> <201210131055.46279.chunkeey@googlemail.com> <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DC0@EXGMBX01.sasken.com>
In-Reply-To: <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DC0@EXGMBX01.sasken.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210151614.52617.chunkeey@googlemail.com> (sfid-20121015_161515_095715_D12F7A2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Krishnan (I really hope this is in fact your first name ;) )

On Monday, October 15, 2012 03:24:12 PM Krishnan Manivannan wrote:
> I tried the patch you hadd mentioned, but still Iam unable to
> receive data packets sent by other stations in managed mode.
> wifi device: TP-LINK (TL-WN822N)
> Am I missing something?

maybe. Do you know if your station are using aggregation (i.e.:
802.11n / HT40)? Or is every station still on 11b/g terms? Also,
what about encryption? Because normally, stations in a WPA protected
network use a per-station key to talk to the AP. Only the sending
station an the AP can decipher these frames (other stations can't
because they lack the proper key and drop them).
Of course, there could be more restrictions. However, I would need
more information about your setup then.

> >Just to be clear, do you want to get these frames on the same
> >interface? And do you want the converted 802.3 or are "real"
> >802.11 frames that go over the air good enough (if so, please
> >read on!)?
> 
> Yes, we want these frames on the same interface.
Well, the 802.11 frames are converted into 802.3 frames by the
mac80211 stack and it does the filtering (source, destination
and bssid matching, decryption(key + icv) checks, sequence number
check, ...) too. If you don't want that, you can either:
 - setup an additional virtual interface and get the raw
   802.11 frames from there [see previous post].

 - register with nl80211 and get the raw 802.11 frames
   from there [this is done by hostapd - look for 
   nl80211_register_frame - although I don't know if
   this method can be used to capture data frames as well].

 - change the filtering code in the stack and let all
   frames through.

> > please be advised, that the hardware sniffer mode is more some sort
> >of debug operation. And that with the current kernel code
> >you might experience some interference trouble if you
> >use carl9170 as a pure monitor. In this case you want
> >to apply the following patch.
> 
> https://patchwork.kernel.org/patch/1439881/
> I tried this patch, but still we are unable to receive data packets sent by other stations.
This patch is for the pure monitor mode. However it looks
like you want have a station and want to look at other
station's traffic too. So, I'm afraid this patch is not
related to this.

Regards,
	Chr
