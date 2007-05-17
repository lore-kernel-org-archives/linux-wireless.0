Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44373
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbXEQUmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 16:42:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Date: Thu, 17 May 2007 22:41:18 +0200
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	"John Linville" <linville@tuxdriver.com>,
	"Jeff Garzik" <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>,
	"Andrea Merello" <andrea.merello@gmail.com>
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net> <200705111602.18729.flamingice@sourmilk.net> <43e72e890705171243g7e3d65e4ne43b5956e13f44db@mail.gmail.com>
In-Reply-To: <43e72e890705171243g7e3d65e4ne43b5956e13f44db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200705172241.18515.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 17 May 2007 21:43:37 Luis R. Rodriguez wrote:
> On 5/11/07, Michael Wu <flamingice@sourmilk.net> wrote:
> 
> > diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
> > new file mode 100644
> > index 0000000..10bec9d
> > --- /dev/null
> > +++ b/drivers/net/wireless/rtl8187_dev.c
> 
> ...
> 
> > +static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
> > +                     struct ieee80211_tx_control *control)
> > +{
> 
> ...
> 
> > +       info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);
> 
> kmemdup can fail, add:
> 
> if (!info->control)
>   return -ENOMEM;

The TX callback expects one of the following return types:

080 /* Driver transmit return codes */
081 #define NETDEV_TX_OK 0          /* driver took care of packet */
082 #define NETDEV_TX_BUSY 1        /* driver tx path was busy*/
083 #define NETDEV_TX_LOCKED -1     /* driver tx lock was already taken */

So most likely you want NETDEV_TX_BUSY here.

-- 
Greetings Michael.
