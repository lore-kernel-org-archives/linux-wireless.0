Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbYJNHiB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 03:38:01 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 15:36:48 +0800
Message-Id: <1223969808.2570.153.camel@debian.sh.intel.com> (sfid-20081014_093807_821558_090F0BAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 01:04 -0600, Luis R. Rodriguez wrote:
> > Why should the intersection be the correct behavior? In my previous
> > example, the intersection of a BG card and an ABG card is the BG
> bands.
> > Why shouldn't the ABG card have the A band support?
> 
> Intersection of ABG and BG is BG.

That's what I'm saying. This is unacceptable for users. There is 2
reasons a channel is not listed in the ieee80211_reg_rule:

1. the channel is not permitted by regulatory
2. the channel is not supported by hardware but it might be permitted by
regulatory

Intersection for the case 2 is wrong. Are you telling me to insert even
A band channels into ieee80211_reg_rule for a BG only card?

Thanks,
-yi

