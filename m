Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64016 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZH3Ncs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 09:32:48 -0400
Received: by ewy2 with SMTP id 2so3321508ewy.17
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 06:32:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: Reorganize padding & L2 padding
Date: Sun, 30 Aug 2009 15:32:47 +0200
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908292030.45659.IvDoorn@gmail.com> <4A9990A8.1080002@free.fr>
In-Reply-To: <4A9990A8.1080002@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908301532.47769.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int
> > header_length) +{ +    struct skb_frame_desc *skbdesc =
> > get_skb_frame_desc(skb); +    unsigned int l2pad = 4 - (header_length
> > & 3);
> This formula is incorrect, it should be at least (4 -
> (header_length%4)%4). I have a fix in my pending patches...
> If header_length is 0 => l2pad should be 0 as well.

Header_length should never be 0 (that was fixed by this patch), so that should
not be a problem. I'll review your patch so it can be send as update later. But I
do think this patch can be merged into linux-wireless in regardless.

Ivo

P.S. Your mail client is really messing up the replies by removing end-of-line
characters. :S
