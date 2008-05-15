Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:58260 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYEOLUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 07:20:08 -0400
Received: by nf-out-0910.google.com with SMTP id d3so130060nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 04:20:06 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: move TX info into skb->cb
Date: Thu, 15 May 2008 13:32:34 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
References: <20080515105524.359863000@sipsolutions.net> <20080515105948.820956000@sipsolutions.net> <1210849867.8709.0.camel@johannes.berg>
In-Reply-To: <1210849867.8709.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805151332.35758.IvDoorn@gmail.com> (sfid-20080515_132014_777615_04CAF9E1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 May 2008, Johannes Berg wrote:
> On Thu, 2008-05-15 at 12:55 +0200, Johannes Berg wrote:
> > plain text document attachment (019-mac80211-tx-info-skb-cb.patch)
> > This patch converts mac80211 and all drivers to have transmit
> > information and status in skb->cb rather than allocating extra
> > memory for it and copying all the data around. To make it fit,
> > a union is used where only data that is necessary for all steps
> > is kept outside of the union.
> > 
> > A number of fixes were done by Ivo, as well as the rt2x00 part
> > of this patch.
> 
> I mangled it a bit though so you may want to check it, mac80211 now sets
> REQ_TX_STATUS so you can use that for status reporting, but you can't
> use it for queue kicking at least not in the future when mac80211 might
> not set it on all frames.

Well queue kicking from driver to mac80211 is in rt2x00 based on txdone
events on a particular queue. (When frame was succesfully transmitted
and is no longer full, then the queue will be awakened by rt2x00).
I am changing this a bit to support burst events that will send all
fragments in a single run, but that is currently under testing in rt2x00.git. 

Ivo
