Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:46526 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918AbaDQRPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 13:15:04 -0400
Message-ID: <1397754900.3104.5.camel@joe-AO725> (sfid-20140417_191509_000613_6CAA08EB)
Subject: Re: [PATCH 1/6] p54: replace wiphy_debug() with wiphy_dbg()
From: Joe Perches <joe@perches.com>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 17 Apr 2014 10:15:00 -0700
In-Reply-To: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
References: <d0cc78c16143f5f54ebcfc4a71e340d8c646aa82.1397741141.git.gamerh2o@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-17 at 21:27 +0800, Zhao, Gang wrote:
> Dynamic debug function wiphy_dbg() is more convenient for debugging,
> and if user doesn't enable CONFIG_DYNAMIC_DEBUG, it will fall back to
> normal static debug, just as what wiphy_debug() does.

Hi.

Your premise is not correct.

wiphy_debug will always emit a message.

wiphy_dbg will only emit a message when #DEBUG
is #defined or CONFIG_DYNAMIC_DEBUG is enabled
and the message is specifically enabled by the
dynamic_debug control file.

> When all the users of wiphy_debug() are gone, wiphy_debug() can be
> removed.

Not really.

Please use git format-patch --cover-letter when
sending a patch series so that these sorts of
replies can be done to the cover letter of the
series instead of individually.

Using a cover-letter "[PATCH 0/N]" also makes it
easier for maintainers to send acknowledgements
if applying the entire series.


