Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:49360 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbZLCSn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 13:43:27 -0500
Received: by ewy2 with SMTP id 2so892708ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 10:43:33 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH v3 0/4] Further L2 padding fixes.
Date: Thu, 3 Dec 2009 19:36:12 +0100
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org
References: <1259615298-2305-1-git-send-email-gwingerde@gmail.com> <4B163956.1060709@free.fr> <14add3d10912030132r251779efq10dc08768aefd8c1@mail.gmail.com>
In-Reply-To: <14add3d10912030132r251779efq10dc08768aefd8c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912031936.12557.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > * L2PAD is only present for data frame and an easy way to check for that is
> > * to compare header_length with 24 bytes.
> > */
> > #define L2PAD_SIZE(__header) \
> >      ((__header)<24 ? 0 : ((4 - ((__header)%4))%4))
> >
> 
> That depends on what the purpose of the L2PAD_SIZE macro is going to
> be. At the moment
> the intention is to have L2PAD_SIZE compute the number of l2pad bytes
> necessary, if a
> payload is present. Detection on whether actually a payload is present
> and whether the
> outcome of this macro should be used should be at the call-sites of this macro.

I personally prefer the current version, I don't see a valid reason for
L2PAD_SIZE to depend on the header size. The caller should check if
the payload is present and L2 padding is required.

Ivo
