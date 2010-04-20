Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-92-33-14-100.sme.bredbandsbolaget.se ([92.33.14.100]:10811
	"EHLO mailhost.lundinova.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754519Ab0DTLG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 07:06:59 -0400
Date: Tue, 20 Apr 2010 13:06:57 +0200
From: Johan Hovold <johan.hovold@lundinova.se>
To: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Cc: Johan Hovold <johan.hovold@lundinova.se>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: corrupt frames forwarded to mac80211 as
 decrypted
Message-ID: <20100420110657.GH5288@lundinova.se>
References: <20100331191058.GD18913@lundinova.se>
 <20100416104850.GA13329@lundinova.se>
 <20100420082519.GB5288@lundinova.se>
 <1271754651.14253.112.camel@ranga-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271754651.14253.112.camel@ranga-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 20, 2010 at 02:40:51PM +0530, Ranga Rao Ravuri wrote:
> Can you please tell us more about your test, 
> what exactly is your test is ? 
> What kind of traffic are you running 
> what is your AP ?. 

I have a powerpc-based platform running AR9280 in AP mode. My STA is an
Intel 5300 (but I have been able to reproduce it also with an STA using
AR5008).

After connecting I run iperf in client mode on the STA thus sending data
to the STA. After a short while the AP stops receiving any data
(including TCP-acks) and the transfer stalls.

I've verified that frames that look ok in the air can still be corrupt
in ath9k. In particular, the status field is trashed so that frames are
incorrectly forwarded to mac80211 marked as decrypted which can trigger
countermeasures or update CCMP PN incorrectly (thereby dropping later,
correct frames).

Discarding frames which appear to have trashed status makes 802.11n
work.

> Are you testing with aggregated traffic or non-aggregate legacy
> traffic ?

Aggregated.

> Are you seeing only when CCMP is enabled or in WEP/TKIP also ?

Only with 802.11n (CCMP). Everything works perfectly with 802.11g and
WEP/TKIP/CCMP and I never see any corrupt frame status.

> Can you please set register 0x8120 bit 28 to 1 and test this again to
> see that helps ?

I'll try that.

Thanks,
Johan

