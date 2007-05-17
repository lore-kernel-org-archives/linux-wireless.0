Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:62024 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbXEQTni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 15:43:38 -0400
Received: by py-out-1112.google.com with SMTP id a29so947389pyi
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2007 12:43:38 -0700 (PDT)
Message-ID: <43e72e890705171243g7e3d65e4ne43b5956e13f44db@mail.gmail.com>
Date: Thu, 17 May 2007 15:43:37 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Cc: "John Linville" <linville@tuxdriver.com>,
	"Jeff Garzik" <jeff@garzik.org>, linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>,
	"Andrea Merello" <andrea.merello@gmail.com>
In-Reply-To: <200705111602.18729.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070511195642.8042.20407.stgit@panda.sourmilk.net>
	 <200705111602.18729.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/11/07, Michael Wu <flamingice@sourmilk.net> wrote:

> diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
> new file mode 100644
> index 0000000..10bec9d
> --- /dev/null
> +++ b/drivers/net/wireless/rtl8187_dev.c

...

> +static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
> +                     struct ieee80211_tx_control *control)
> +{

...

> +       info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);

kmemdup can fail, add:

if (!info->control)
  return -ENOMEM;

  Luis
