Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 39.mail-out.ovh.net ([213.251.138.60]:42890 "HELO
	39.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753347AbZK2ABx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 19:01:53 -0500
Message-ID: <4B11B860.4080607@free.fr>
Date: Sun, 29 Nov 2009 00:55:12 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] rt2x00: Further L2 padding fixes.
References: <1259433154-2587-1-git-send-email-gwingerde@gmail.com>	<200911282226.58091.IvDoorn@gmail.com> <4B1199A7.7090903@gmail.com>
In-Reply-To: <4B1199A7.7090903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde a écrit :
> On 11/28/09 22:26, Ivo van Doorn wrote:
>>> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>> index b8f0954..562a344 100644
>>> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
>>> @@ -181,7 +181,7 @@ void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
>>>  	unsigned int frame_length = skb->len;
>>>  	unsigned int header_align = ALIGN_SIZE(skb, 0);
>>>  	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
>>> -	unsigned int l2pad = 4 - (payload_align - header_align);
>>> +	unsigned int l2pad = 4 - (header_length & 3);

Humm... is header_length = 24, then your formula gives l2pad = 4. If so,
this is wrong. Do I miss something?

BTW, I'm trying to prepare some patches for rt2800usb and padding. I
must admit the current framework is a bit complex compared to other
drivers (ath9k for instance).

To give something similar to ath9k where the pad position is computed
based on the hdr->frame_control field only (my guess is that's what the
HW does anyway), we have :

int rt2800usb_padpos(__le16 frame_control)
{
  int padpos = 24;
  if (ieee80211_is_data(frame_control)) {
	padpos = ieee80211_hdrlen(frame_control);
  }
  return padpos;
}

then later : int padsize = padpos & 3;

then the usual check before doing the real padding or unpadding :
if (padsize && skb->len>padpos) {
  do padding or unpadding
}

My 2 cents,
Benoit
