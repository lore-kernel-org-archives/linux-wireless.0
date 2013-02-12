Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41038 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933425Ab3BLTyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:54:35 -0500
Message-ID: <1360698872.17456.11.camel@joe-AO722> (sfid-20130212_205440_378369_4D61C32A)
Subject: Re: [PATCH] rtlwifi: Rework Kconfig
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Feb 2013 11:54:32 -0800
In-Reply-To: <511a9bda.qSVbJjBneEGprv+8%Larry.Finger@lwfinger.net>
References: <511a9bda.qSVbJjBneEGprv+8%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 13:45 -0600, Larry Finger wrote:
> As the number of drivers in the rtlwifi family has grown, the Kconfig
> section for them has grown unwieldy. This change has two effects: (1)
> Variable RTLWIFI_DEBUG is documented, and (2) the entries for the
> drivers that depend on RTLWIFI and indented.

trivial note below:

> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/Kconfig
> @@ -1,8 +1,26 @@
[]
> +config RTLWIFI_DEBUG
> +	bool "Debugging output for rtlwifi driver family"
> +	depends on RTLWIFI
> +	default y
> +	---help---
> +	This option is needed for the "debug=n" module option to produce any
> +	output. For embedded or other memory-limited systems, choose "N".
> +	For all other systems, or if in doubt, use "Y".

using "debug=n" here can be a bit confusing given the
"N" and "Y" that follow it.

maybe debug=<0x...> module parameter to control debug
message level output.


