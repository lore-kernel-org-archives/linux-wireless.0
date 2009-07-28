Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:42331 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZG1ISO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 04:18:14 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] libertas: Read buffer overflow
Date: Tue, 28 Jul 2009 10:19:56 +0200
Cc: dcbw@redhat.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <4A6EB00D.5010401@gmail.com>
In-Reply-To: <4A6EB00D.5010401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907281019.56855.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -	size_t num_card_rates = sizeof(lbs_bg_rates);
> +	size_t num_card_rates = ARRAY_SIZE(lbs_bg_rates);

Hmm, not sure about this.  First I don't know if we need a 
variable for this at all. Can't you simply use ARRAY_SIZE() 
whenever it's needed?

If you want to keep num_card_rates, you should change it's 
type. "size_t" is normally used to denote sizes in bytes, e.g. 
it's the type for the length of malloc and friends. But now the 
variable holds a number of elements and should be int or 
unsigned int.

-- 
http://www.holgerschurig.de
