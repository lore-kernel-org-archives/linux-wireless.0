Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:60834 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0DSRij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:38:39 -0400
Received: by bwz25 with SMTP id 25so5901961bwz.28
        for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:38:38 -0700 (PDT)
Date: Mon, 19 Apr 2010 19:41:01 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rc80211_minstrel.c:70 WARNING with 2.6.34-rc4
Message-ID: <20100419174100.GA5312@linux-m68k.org>
References: <20100418085653.GA7345@linux-m68k.org> <1271694855.9026.51.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271694855.9026.51.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

> > I am getting tons of these http://www.kerneloops.org/submitresult.php?number=3048061,
> > appears every packet triggers that.
> 
> The warning comes from the function rix_to_ndx() in rc80211_minstrel.c:
> 
> /* convert mac80211 rate index to local array index */
> static inline int
> rix_to_ndx(struct minstrel_sta_info *mi, int rix)
> {
>         int i = rix;
>         for (i = rix; i >= 0; i--)
>                 if (mi->r[i].rix == rix)
>                         break;
>         WARN_ON(i < 0);
>         return i;
> }
> 
> > Can provide lots of debugging info.
> 
> My impression is that WARN_ON is not warranted in that function, but it
> would be interesting to know how you got to that point.

I am using the rt73usb, WEP, adhoc, fixed rate(11M) on both ends:

wlan0     IEEE 802.11bg  ESSID:"XXXXXXXX"  
          Mode:Ad-Hoc  Frequency:2.442 GHz  Cell: F6:B2:CB:FC:62:6C   
          Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:  XXXXXXXXXX
          Power Management:on

It is 2.6.34-rc4, no compat-wireless.

As of unusual circumstances - the  rt73usb driver has some bug that causes
very high retransmit rates. On the opposite end the ath5k driver complains "cant
handle jumbo frames".
I had it perfectly working some time ago but need to figure out which off the many 
patches did it and apply it to the new kernel. 
This might stress minstrel more than needed but otoh it was my impression that the
warning was triggered by every single packet.

Let me know if you want any more info.

Richard
