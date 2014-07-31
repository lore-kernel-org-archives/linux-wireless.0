Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57409 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaGaOII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 10:08:08 -0400
Date: Thu, 31 Jul 2014 16:07:53 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Martin Townsend <mtownsend1973@gmail.com>,
	linux-zigbee-devel@lists.sourceforge.net,
	BlueZ development <linux-bluetooth@vger.kernel.org>,
	Martin Townsend <martin.townsend@xsilon.com>,
	Network Development <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] linux-wpan-next: lowpan_rcv - skb is freed within
 function and fix return values.
Message-ID: <20140731140751.GA10599@omega> (sfid-20140731_160823_505090_7EB9B84B)
References: <1406732105-17500-1-git-send-email-martin.townsend@xsilon.com>
 <C8606BA6-2918-4313-BEC5-FC3A377DE347@holtmann.org>
 <20140730182738.GA21664@omega>
 <362B23B3-72BB-4E0E-9E06-ABD19C1F2BEF@holtmann.org>
 <20140731135945.GB17560@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140731135945.GB17560@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jul 31, 2014 at 09:59:46AM -0400, John W. Linville wrote:
> On Wed, Jul 30, 2014 at 11:32:16AM -0700, Marcel Holtmann wrote:
> > Hi Alex,
> > 
> > >>> Currently it is up to the functions below lowpan_rcv to free the skb on error
> > >>>   conditions.  This patch now removes all the UAPI error codes and process data
> > >>>   now returns -1 if there is a problem.  In this scenario lowpan_rcv will free
> > >>>   the skb and return NET_RX_DROP.  This also fixes the problem where
> > >>>   NET_RX_SUCCESS is returned on error
> > >>> 
> > >>> Martin Townsend (2):
> > >>> Remove dev parameter from skb_delivery_cb in 6lowpan.
> > >>> Change lowpan_rcv so skb is freed within function and fix return
> > >>>   values.
> > >>> 
> > >>> include/net/6lowpan.h         |  4 ++--
> > >>> net/6lowpan/iphc.c            | 37 ++++++++++++++++++------------------
> > >>> net/bluetooth/6lowpan.c       | 21 ++++++++++-----------
> > >>> net/ieee802154/6lowpan_rtnl.c | 44 +++++++++++++++++++++----------------------
> > >>> 4 files changed, 52 insertions(+), 54 deletions(-)
> > >> 
> > >> I can not take these patches at this point.
> > >> 
> > >> checking file net/ieee802154/6lowpan_rtnl.c
> > >> Hunk #1 FAILED at 143.
> > >> Hunk #2 succeeded at 480 (offset -4 lines).
> > >> 1 out of 2 hunks FAILED
> > >> 
> > >> We need to get the IEEE 802.15.4 changes merged through John's wireless-next tree. IEEE 802.15.4 going straight into net-next and Bluetooth going into wireless-next will not work out smoothly when both technologies are now utilizing 6LoWPAN and we are heavily working on 6LoWPAN.
> > >> 
> > > 
> > > I already told Martin that these patches should be based on bluetooth
> > > (better bluetooth-next, 802.15.4 hasn't a real stable strategie and there
> > > are also some known other issues in the current implementation). I don't
> > > think that the current implementation is used in a real environment.
> > > 
> > > I get this patch-series in a resend of this series, after Martin
> > > subscribed the linux-zigbee-devel mailinglist, then I told Martin that I
> > > need some time for review and he want to resend them tomorrow or friday.
> > > The resend should based on bluetooth-next then, if this is okay for you.
> > 
> > if patches are based on bluetooth-next, then we have no problem here. I can easily merge them.
> 
> Does that resolve it?  That probably won't make 3.17, fwiw...
> 

there are some issues on this patch series. Martin need to work on and
resend them as v2.

I told about the issues on an another thread which should be the same series.
I don't get exactly this patch series, I think Marcel add me in CC later.

So it needs some time anyway. Thanks.

- Alex
