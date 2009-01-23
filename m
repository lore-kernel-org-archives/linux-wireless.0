Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:62012 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbZAWR0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:26:33 -0500
Received: by ewy13 with SMTP id 13so3803795ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 09:26:31 -0800 (PST)
Message-ID: <4979FDC5.4030100@gmail.com> (sfid-20090123_182638_920039_78829E3F)
Date: Fri, 23 Jan 2009 18:26:29 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54usb: fix nasty use after free
References: <200901201332.54435.chunkeey@web.de>
In-Reply-To: <200901201332.54435.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently an earlier version of this patch went into w-t, the
committed version is still missing the skb_pull removal shown below.
It's an error path so it doesn't usually get executed.

Also, Christian's patch http://www.spinics.net/lists/linux-wireless/msg27282.html
which makes net2280 devices work still hasn't made it. (it fixes an
unrelated c&p bug it seems, but that change is obviously correct).

artur

Christian Lamparter wrote:
> In theory, the firmware acks the received a data frame, before signaling the driver to free it again.
> However Artur Skawina has shown that it can happen in reverse order as well.
> This is very bad and could lead to memory corruptions, oopses and panics.
>  
> Thanks to Artur Skawina <art.08.09@gmail.com> for reporting and debugging this issue.
> 
> Tested-by: Artur Skawina <art.08.09@gmail.com>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Changes:
> 	- removed a forgotten skb_pull from p54u_tx_net2280 error - path.

> @@ -360,14 +352,12 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
>  		usb_unanchor_urb(data_urb);
>  		goto out;
>  	}
> - out:
> +out:
>  	usb_free_urb(int_urb);
>  	usb_free_urb(data_urb);
>  
> -	if (err) {
> -		skb_pull(skb, sizeof(*hdr));
> +	if (err)
>  		p54_free_skb(dev, skb);
> -	}
>  }

