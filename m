Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40599 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbbCELLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 06:11:10 -0500
Received: by wevk48 with SMTP id k48so8752492wev.7
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2015 03:11:08 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: marco@tampabay.rr.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl1970: monitor mode only displaying beacons/probs from APs?
Date: Thu, 05 Mar 2015 12:10:58 +0100
Message-ID: <3859987.D1VAPy8h72@debian64> (sfid-20150305_121114_513954_D9C48610)
In-Reply-To: <20150304230225.J5EHX.13935.root@cdptpa-web27>
References: <20150304230225.J5EHX.13935.root@cdptpa-web27>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wednesday, March 04, 2015 11:02:25 PM marco@tampabay.rr.com wrote:
> Quite a while back after doing an upgrade to the latest (back then)
> compat-wireless, I noticed that I was only seeing beacon,prob requests, and
> the occasional data packet when in monitor mode; which at the time I wrote
> off.  After switching to backports-3.18.1-1 recently, I still see the same
> behavior(on x86 and arm).  I'm sure I'm missing something, but I couldn't
> find any references to this behavior in my search.  I also tried "iw wlanX
> set monitor control otherbss" to no avail.  Switching to a different chipset
> using ath9k-htc showed expected traffic.
> 
> Can anyone point me in the right direction?
maybe. Could it be that you are looking for 802.11n(MCS) data frames?
Because by default, carl9170's monitor mode only catches the legacy 
802.11a/b/g frames. If this is the case, then try setting the right
channel mode (HT20/HT40+/HT40-) when selecting the channel. i.e.:  

# iw dev wlanX set channel Y HT20
# iw dev wlanX set channel Y HT40+

I hope this helps. Otherwise, you could try: 

# iw dev wlanX set monitor [...] fcsfail

and see if you are picking up frames this way. This should work, but you
will be picking up mostly damaged stuff, so some extra frame processing
will be needed to filter out the noise. 

Regards,
  Christian
