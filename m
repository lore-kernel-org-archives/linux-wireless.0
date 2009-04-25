Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:9522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZDYQSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 12:18:47 -0400
Received: by fg-out-1718.google.com with SMTP id 16so338770fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Apr 2009 09:18:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904251741.10310.mb@bu3sch.de>
References: <200904251650.17142.mb@bu3sch.de> <69e28c910904250835q4eed1a3if06b0fe214e9801c@mail.gmail.com>
	<200904251741.10310.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 25 Apr 2009 18:18:31 +0200
Message-ID: <69e28c910904250918t866e17t65ef19efc3213574@mail.gmail.com> (sfid-20090425_181852_353502_E6F459B6)
Subject: Re: Warning in tx.c:775 invoke_tx_handlers
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/25 Michael Buesch <mb@bu3sch.de>:
> On Saturday 25 April 2009 17:35:39 G=E1bor Stefanik wrote:
>> Fragmented A-MPDU?
>
> I don't think so. This is an 802.11g card. But fragmentation is enabl=
ed.
>
> --
> Greetings, Michael.
>

This is it, then:
774         /* internal error, why is TX_FRAGMENTED set? */
775         if (WARN_ON(skb->len <=3D frag_threshold))
776                 return TX_DROP;

That is, trying to break a packet into fragments longer than the packet=
 itself.

I guess you aren't using the latest kernel from wireless-testing.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
