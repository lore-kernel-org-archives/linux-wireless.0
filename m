Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46525 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbbGBLjc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 07:39:32 -0400
Message-ID: <1435837168.2285.8.camel@sipsolutions.net> (sfid-20150702_133935_527438_8B42DAA3)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>
Date: Thu, 02 Jul 2015 13:39:28 +0200
In-Reply-To: <CALhHN=ojLBA1AFGz=atjJhv+fJAr-Rkhd0cgYpma_4Rx+HYOaw@mail.gmail.com> (sfid-20150702_114406_759616_5CDED4CB)
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
	 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
	 <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
	 <1435082418.2777.11.camel@ipeer-box>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
	 <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
	 <1435822032.2285.2.camel@sipsolutions.net>
	 <CALhHN=ojLBA1AFGz=atjJhv+fJAr-Rkhd0cgYpma_4Rx+HYOaw@mail.gmail.com>
	 (sfid-20150702_114406_759616_5CDED4CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-02 at 11:44 +0200, Janusz Dziedzic wrote:
> 
> > The issue above can probably easily fixed by doing the BSS update 
> > after
> > the "direct probe responded" though, no? Like this:
> > https://p.sipsolutions.net/67f9212f0f9f3642.txt
> > 
> This was my first idea, but in such case I suspect we will send
> another direct probe while  bss->proberesp_ies will be not set and
> ieee80211_probe_auth() will send second probe_req?
> 

But why would it not be set? We do rely on ieee80211_rx_bss_info()
setting it, after all.

johannes
