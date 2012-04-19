Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55673 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab2DSTsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:48:07 -0400
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
	David Miller <davem@davemloft.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Spinadel, David" <david.spinadel@intel.com>
Subject: RE: net-next iwlwifi breaks compile - was Re: pull request:
 wireless-next 2012-04-18
Date: Thu, 19 Apr 2012 19:47:58 +0000
Message-ID: <4595B4D22AB93C4FABBA84AAD5AA37FD1258AA@ORSMSX103.amr.corp.intel.com> (sfid-20120419_214817_339769_6FDA3871)
References: <20120418190521.GB2436@tuxdriver.com>
 <20120418.153653.2130740499995307564.davem@davemloft.net>
 <4F8F9977.9040703@hartkopp.net>
In-Reply-To: <4F8F9977.9040703@hartkopp.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Oliver,

>Commit "iwlwifi: move scan related declarations out of iwl-core.h"
>
>http://git.kernel.org/?p=linux/kernel/git/davem/net-
>next.git;a=commitdiff;h=8fb96d6e176cbf0a97b2391fa1fa09e608ee86f8
>
>breaks the compile when CONFIG_IWLWIFI_DEBUGFS is not set, see:

[MV] Sorry about breaking net-next. I took a look at the patch that you've pointed to, and actually it's a patch that caused the problem. The commit that broke it is actually:

iwlwifi: expose static methods for MVM use

http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=commit;h=50c1e9a9e3b086465b1467d448c10f7fa1e0eb5c

It was fixed internally in a subsequent patch, but that patch has not made it into net-next. I don't see it in the public iwlwifi repository either. We'll add the fix to the repository so you can pick it up.

Thanks & sorry,
Meenakshi



