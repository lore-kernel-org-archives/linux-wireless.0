Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:65512 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYABTCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 14:02:43 -0500
Received: by fk-out-0910.google.com with SMTP id z23so6268196fkz.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2008 11:02:41 -0800 (PST)
To: chris2553@googlemail.com
Subject: Re: Warning emited by 2.6.24-rc6-git5
Date: Wed, 2 Jan 2008 20:02:29 +0100
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200712290942.37396.chris2553@googlemail.com> <a32f33a40712302356m46dfce7fu852636f8bc37b41f@mail.gmail.com> <200801020632.31361.chris2553@googlemail.com>
In-Reply-To: <200801020632.31361.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801022002.29262.IvDoorn@gmail.com> (sfid-20080102_190247_657821_3C0A728B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 January 2008, Chris Clayton wrote:
> On Monday 31 December 2007, Ivo Van Doorn wrote:
> > On Dec 31, 2007 8:27 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> > > Ivo van Doorn <ivdoorn@gmail.com> writes:
> > > > +             /*
> > > > +              * Move entire frame 2 bytes to the front.
> > > > +              */
> > > > +             skb_push(skb, 2);
> > > > +             memmove(skb->data, skb->data + 2, skb->len - 2);
> > >
> > > No skb_trim()? Shoudn't there be skb_trim(skb, 2) after memmove()?
> >
> > Good point, I completely forgot about that. :S
> > Thanks. :)
> >
> > Ivo
> 
> Ah, does the patch I have applied and am running need enhancement, please?

---

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index ff399f8..3c10a68 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -386,6 +386,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
+	unsigned int header_size;
 	unsigned int i;
 	int val = 0;
 
@@ -412,6 +413,27 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 		}
 	}
 
+	/*
+	 * Properly align the ieee80211 frame and make sure the
+	 * data behind the ieee80211 header is on a 4 byte boundrary.
+	 */
+	header_size = ieee80211_get_hdrlen_from_skb(skb);
+	if (!header_size) {
+		/*
+		 * Frame is too short to contain a valid header,
+		 * drop the entire frame since it is useless.
+		 */
+		kfree_skb(skb);
+		return;
+	} else if (header_size % 4 == 0) {
+		/*
+		 * Move entire frame 2 bytes to the front.
+		 */
+		skb_push(skb, 2);
+		memmove(skb->data, skb->data + 2, skb->len - 2);
+		skb_trim(skb, skb->len - 2);
+	}
+
 	rt2x00_update_link_rssi(&rt2x00dev->link, desc->rssi);
 	rt2x00dev->link.rx_success++;
 	rx_status->rate = val;
