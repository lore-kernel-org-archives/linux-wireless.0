Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:31353 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZFDVQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 17:16:12 -0400
Received: by qw-out-2122.google.com with SMTP id 5so748551qwd.37
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2009 14:16:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906041353y98a3a13s2b8d60328a9c0c6d@mail.gmail.com>
References: <4A282B92.70609@free.fr>
	 <43e72e890906041353y98a3a13s2b8d60328a9c0c6d@mail.gmail.com>
Date: Thu, 4 Jun 2009 18:16:13 -0300
Message-ID: <ee8eb53d0906041416q52812277x7061070d1d9a683c@mail.gmail.com>
Subject: Re: mac80211 : fix unaligned rx skb
From: Georgy Berdyshev <codingmaster@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: matthieu castet <castet.matthieu@free.fr>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

that's the inline version:
-------
mac80211 is checking is the skb is aligned on 32 bit boundary.
But it is checking against ethernet header, whereas Linux expect IP
header aligned.
And ethernet ether size is 6*2+2=14, so aligning ethernet header make
IP header unaligned.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9776f73..0845fb3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1397,7 +1397,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		 * mac80211. That also explains the __skb_push()
 		 * below.
 		 */
-		align = (unsigned long)skb->data & 3;
+		align = ((unsigned long)(skb->data + sizeof(struct ethhdr))) & 3;
 		if (align) {
 			if (WARN_ON(skb_headroom(skb) < 3)) {
 				dev_kfree_skb(skb);
------------

On Thu, Jun 4, 2009 at 5:53 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Jun 4, 2009 at 1:16 PM, matthieu castet <castet.matthieu@free.fr> wrote:
>>
>
> This is all I see, can you resend with patch inline?
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Georgy Berdyshev

GPG key: 830F68C5
Fingerprint: 0379 ED5A BEE5 65A8 7BD5  31E7 F5B4 1EC7 830F 68C5
