Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbYFPOb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 10:31:57 -0400
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Joonwoo Park <joonwpark81@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	JMF <tolas_feup@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1213605989.3803.24.camel@johannes.berg>
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>
	 <loom.20080527T105701-941@post.gmane.org>
	 <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com>
	 <1211896423.1746.9.camel@localhost.localdomain>
	 <20080528004100.GG7779@tuxdriver.com> <20080615164617.GA27699@tp64>
	 <1ba2fa240806150953t4b61b213y3488940ef05b762e@mail.gmail.com>
	 (sfid-20080615_185357_450305_0D547871)  <1213605989.3803.24.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 10:30:59 -0400
Message-Id: <1213626659.14862.10.camel@localhost.localdomain> (sfid-20080616_163201_934154_2AAAD2A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-16 at 10:46 +0200, Johannes Berg wrote:
> > > [PATCH] wireless: Limit wep key size to 128/104-bits
> > >
> > > This patch prevents overflow which is occured by invalid long wep key
> > > insertion
> > >
> > > $sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA
> > >
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> > > IP: [memcpy_c+0xb/0x20] memcpy_c+0xb/0x20
> > > PGD 13a590067 PUD 12e471067 PMD 0
> > > Oops: 0000 [1] PREEMPT SMP
> > > CPU 1
> > > ...
> > > Pid: 10, comm: events/1 Not tainted 2.6.26-rc2 #9
> > > ...
> > > Call Trace:
> > >  [iwl4965:iwl4965_rx_scan_start_notif+0xb/0x20] ? :iwl4965:iwl4965_enqueue_hcmd+0x12b/0x220
> > >  [hci_usb:init_module+0xe97/0x28cb0] :iwlcore:iwl_send_cmd_sync+0x67/0x290
> > >  [save_trace+0x3f/0xb0] ? save_trace+0x3f/0xb0
> > > ...
> > >
> > > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> > > ---
> > >  net/wireless/wext.c |   11 ++++++++++-
> 
> I'm sure Jean will cry murder because he expects there are some stupid
> full-mac cards that actually support other sizes.
> 
> Can't somebody just post a patch to mac80211 that only accepts the two
> correct sizes like cfg80211 does?

I'd +1 that.

The hardware that appears to support 152-bit WEP would be driven by
madwifi/ath5k [1] [2], and maybe rtl8185 [3].  Most other references
I've found to 152-bit encryption support are for "108Mbps" or "Turbo"
products, which are almost always Atheros-based chipsets.  Since they
are mac80211-driven cards with ath5k, they will obviously support WPA
too.

The only case I can think of for really supporting 152-bit WEP is if
some fullmac part can't handle WPA but can handle 152-bit WEP.  And no
fullmac parts that I know of support 152-bit WEP.

Dan

[1] http://www.seattlewireless.net/HardwareComparison (Proxim Orinoco Atheros-based)
[2] http://support.dlink.com/products/view.asp?productid=DWL%2DAB650
[3] http://svp.co.uk/product/tp-link_tl-wn353g_54mbps_wireless_pci_adapter_4669


