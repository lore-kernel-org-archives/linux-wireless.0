Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38447 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZBMNbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 08:31:06 -0500
Date: Fri, 13 Feb 2009 08:17:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: orinoco: fix broken make allyesconfig due to multiple defs of
	michael_mic
Message-ID: <20090213131725.GA3792@tuxdriver.com> (sfid-20090213_143110_905857_A62B6AF4)
References: <1234509680.1327.30.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234509680.1327.30.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 08:21:20AM +0100, Johannes Berg wrote:
> I don't think the fix is correct:
> 
> -       priv->tx_tfm_mic = crypto_alloc_hash("michael_mic", 0, 0);
> +       priv->tx_tfm_mic = crypto_alloc_hash("orinoco_mic", 0, 0);
> 
> that'll never find anything. Renaming the function name was a good plan,
> but not changing the string here :)

Good point... :-)  I'll fix it up some more...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
