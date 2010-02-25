Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36344 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934Ab0BYUWS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 15:22:18 -0500
Subject: Re: [PATCH 1/2] rt2x00 : hw support txdone implementation.
 (without fallback change)
From: Pavel Roskin <proski@gnu.org>
To: prahal@yahoo.com
Cc: John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
In-Reply-To: <4B86D0BD.3000803@yahoo.com>
References: <4B85FA66.2020503@yahoo.com> <1267120092.25296.31.camel@mj>
	 <4B86D0BD.3000803@yahoo.com>
Content-Type: text/plain
Date: Thu, 25 Feb 2010 15:21:58 -0500
Message-Id: <1267129318.16176.15.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-25 at 20:34 +0100, Alban Browaeys wrote:

> > wpa_supplicant worked most of the time.  I believe the occasional
> > failures are due to a preexisting memory corruption issue (I reported
> > earlier that addr3 can be corrupted in probe requests).

That's what I'm referring to:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/46727

> Really interesting. I had access to an Access Point that leading to
> such state of affait a week ago (but not for long enough to decipher the 
> issue).
> All I could tell is the rt2x00mac_config was constantly called and as 
> this function kills
> RX well I ended up with RX off all the time after a few initial pings.
> Does any message comes out with mac80211 and rt2x00 debug on ?
> As I cannot reproduce with both of my 3 different access points I am 
> kind of interested
> by such a setup that break.

There are no kernel messages, but ping stops working after 11 packets
every time.  Wireshark shows that no more pings are sent.

> Does 
> http://git.popipo.fr/?p=rt2x00.git;a=commitdiff;h=f82ab894fdac70954a50507921947facce8d8321 
> helps ?

It's already in the kernel.

This patch should help, but it was criticized and we are waiting for a
better version:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/46713

> >> +		rt2x00_desc_read(txwi, 1,&word);
> >> +		tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
> >> +		tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
> >> +		tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> >> +
> >> +		if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid))
> >> +			WARNING(rt2x00dev, "invalid TX_STA_FIFO content\n");
> >>      
> > Can we make this sanity check optional?
> >
> >    
> Is this a showstopper ? Do you mean only enabling this message telling 
> something totally
> unexpected happened in debug mode ? The sanity of the queue is pretty 
> critical for operation.

I'm not a maintainer, I'm just trying to help with the driver, so I
cannot declare anything a showstopper.  It was just an idea.  We can
make it optional later.

-- 
Regards,
Pavel Roskin
