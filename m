Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57921 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbZH3TsC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 15:48:02 -0400
Message-ID: <4A9AD768.8040109@free.fr>
Date: Sun, 30 Aug 2009 21:47:52 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH] rt2x00: Reorganize padding & L2 padding
References: <200908292030.45659.IvDoorn@gmail.com> <4A9990A8.1080002@free.fr> <200908301532.47769.IvDoorn@gmail.com>
In-Reply-To: <200908301532.47769.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ivo van Doorn a écrit :
>>> +void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int
>>> header_length) +{ +    struct skb_frame_desc *skbdesc =
>>> get_skb_frame_desc(skb); +    unsigned int l2pad = 4 - (header_length
>>> & 3);
>> This formula is incorrect, it should be at least (4 -
>> (header_length%4)%4). I have a fix in my pending patches...
>> If header_length is 0 => l2pad should be 0 as well.
> 
> Header_length should never be 0 (that was fixed by this patch), so that should
> not be a problem. I'll review your patch so it can be send as update later. But I
> do think this patch can be merged into linux-wireless in regardless.
> 
> Ivo
> 
> P.S. Your mail client is really messing up the replies by removing end-of-line
> characters. :S

Sorry about my mail client (there was an HTML conversion). It should be
fixed now.

Regards,
Benoit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqa12MACgkQOR6EySwP7oIviQCdHXzTBbHuFuJE5BulKy1+a80z
rHMAnA4nL9XEz7sYAK5ifcQypJkNkcki
=Rg+z
-----END PGP SIGNATURE-----
