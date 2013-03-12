Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54875 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab3CLKMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 06:12:36 -0400
Received: by mail-wg0-f42.google.com with SMTP id 12so3063149wgh.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2013 03:12:35 -0700 (PDT)
Date: Tue, 12 Mar 2013 11:09:46 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Enable sw scan with chan context
Message-ID: <20130312100946.GB23062@magnum.frso.rivierawaves.com> (sfid-20130312_111239_877382_E03DF0E8)
References: <513DE4BB.9010104@posedge.com>
 <1363012784.5284.5.camel@jlt4.sipsolutions.net>
 <513DF675.3000800@posedge.com>
 <1363015558.5284.11.camel@jlt4.sipsolutions.net>
 <1363057766.778.8.camel@WLAN-SW-TEST-03>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363057766.778.8.camel@WLAN-SW-TEST-03>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 12, 2013 at 08:39:26AM +0530, Mahesh Palivela wrote:
> On Mon, 2013-03-11 at 17:25 +0200, Johannes Berg wrote:
> > On Mon, 2013-03-11 at 20:51 +0530, Mahesh Palivela wrote:
> > 
> > > I tested this patch. scan works. 
> > 
> > Works how? It never tells the driver to go to a different channel ...
> 
> sorry. I missed this. But my patch takes care of crash in mac80211 once
> we remove 'use_chanctx' check in sw_scan function.
> 
> > 
> > Besides, telling the driver to go to one channel via the hw_config call,
> > and using chanctx for vif configuration seems like a really bad idea.
> > 
> 
> Agree.
> 
> > > Anyways chan context is a WIP.
> > 
> > It pretty much works.
> 
> For AP mode yes it works. But for STA mode, we have work I guess.
> 
> > 
> > > There is no driver which is using the chan ctx work yet.
> > 
> > There is, our mvm driver uses it.
> > 
> 
It uses hw scan and roc, and thus can use the chanctxes as is.
 
Karl
