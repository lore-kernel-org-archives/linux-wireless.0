Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63072 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1L3Ja7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 04:30:59 -0500
Received: by vcbfk14 with SMTP id fk14so10574501vcb.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Dec 2011 01:30:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111230080554.DE64420052@mail.watchdata.com.cn>
References: <CADGLRPmkbTp-azGJ2=CJum=Y8Mrf7fTbaE9Oi8Om+DQyu7d9uA@mail.gmail.com>
	<20111230080554.DE64420052@mail.watchdata.com.cn>
Date: Fri, 30 Dec 2011 01:30:58 -0800
Message-ID: <CAJ-VmomR_1iN5rryyvui6iQGuN+3aWAets5NQjx+sHpZe8ck0w@mail.gmail.com> (sfid-20111230_103103_317169_711B87BF)
Subject: Re: Question: ieee80211_rx called twice after one ieee80211_subif_start_xmit
 call
From: Adrian Chadd <adrian@freebsd.org>
To: =?GB2312?B?wO641Q==?= <gang.li@watchdata.com>
Cc: linux-wireless@vger.kernel.org,
	Ath9k Devel List <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/12/30 ภ๎ธี <gang.li@watchdata.com>:
> Hi sirs,
>
>        Today, I noticed that when an data frame is sent by
> ieee80211_subif_start_xmit, then ieee80211_rx will be called twice , first
> is an Acknowledgement frame and second is the response data frame.  Is this
> the normal case?   It seems the RA frame is nonsense and just be freed in
> ieee80211_rx_monitor.
>
>        Is there anyway to tell the hardware not report RA frame to
> mac80211?

.. its receiving ACKs? I thought it only did that when either promisc
or control was enabled. Try fiddling around with the RX filter bitmask
and see if you can determine (for your NIC :) which filter bit is
doing it.

Maybe the interface is in promisc mode in hostap mode and this is why
you're seeing ACKs.


Adrian
