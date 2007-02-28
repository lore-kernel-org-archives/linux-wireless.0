Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:18277 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbXB1RHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 12:07:33 -0500
Received: by nf-out-0910.google.com with SMTP id o25so614912nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 09:07:32 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/28] rt2x00:
Date: Wed, 28 Feb 2007 18:07:28 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.04933.IvDoorn@gmail.com> <1172681828.5015.47.camel@johannes.berg>
In-Reply-To: <1172681828.5015.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281807.28551.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 17:57, Johannes Berg wrote:
> On Wed, 2007-02-28 at 15:07 +0100, Ivo van Doorn wrote:
> 
> > Here is the patch series to bring rt2x00 up to date.
> 
> Unrelated to this particular patchset, but we've long said how rt*
> drivers are a source of huge amounts of duplicate code.
> 
> I just diffed rt2400pci and rt2500pci just for example and noticed that
> the hardware is basically identical except for the added features. After
> cutting out spurious changes the diff is about 150 lines so it should be
> really simple to support the hw in one driver. It'd be great if you
> could do this, the code duplication currently in there is pretty awkward
> if we change anything externally and need to update 5 almost-identical
> drivers.

That is where rt2x00lib is coming in. This is only a recent addition to rt2x00
so not everything has moved in correctly. So you can expect more to be
merged into rt2x00lib.

Merging rt2400pci and rt2500pci doesn't sound like a good idea to me,
once rt2x00lib has been optimally used most duplicate code is out,
and merging those 2 could make the implementation of hardware encryption
for rt2500pci harder. rt2400pci is the only Ralink chip that is not capable of
hardware encryption.

In the early days of rt2x00 where work on rewriting the drivers has just begun,
those 2 drivers were indeed merged but the checks for which chipset was
currently used became more and more complex. The RF chipsets are
not unique between RT chips, which made checking for which register
should be set and with what value became larger and larger. In the end
it appeared simpler to split the 2 apart. Especially when considering
that more use should be made of the hardware encryption capabilities
of rt2500.

Ivo
