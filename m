Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22271 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZFRPjt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 11:39:49 -0400
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching
 bands  and not scanning
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <20090618150119.GD2738@tuxdriver.com>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
	 <1244666973.20900.399.camel@rc-desk>
	 <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com>
	 <1244667817.20900.402.camel@rc-desk>
	 <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com>
	 <1244668077.4706.4.camel@johannes.local>
	 <43e72e890906101542l5064384auf027267a3d19f3ee@mail.gmail.com>
	 <43e72e890906101544i22bacc8fxa0a7d045eea50280@mail.gmail.com>
	 <43e72e890906111204g18e71720w97cb2ea346e5d663@mail.gmail.com>
	 <1244753407.20900.456.camel@rc-desk>  <20090618150119.GD2738@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 08:47:01 -0700
Message-Id: <1245340021.24303.302.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Thu, 2009-06-18 at 08:01 -0700, John W. Linville wrote:
> On Thu, Jun 11, 2009 at 01:50:07PM -0700, reinette chatre wrote:
> 
> > I ran the steps to reproduce on a kernel that is the latest
> > wireless-testing + "mac80211: disconnect when user changes channel" +
> > "iwlwifi: remove rs_get_rate workaround". Unfortunately I still get the
> > rs_get_rate warning. 
> 
> Should I merge the ath9k rate series w/o "iwlwifi: remove rs_get_rate
> workaround"?

The later patch "mac80211: add helper for management / no-ack frame rate
decision" also touches iwlwifi and assumes that "iwlwifi: remove
rs_get_rate workaround" has been applied. 

I do not know if Luis would want that patch to go in because the warning
we get may not be specific to iwlwifi. If you do want that to go in then
please remove the iwlwifi bits.

Reinette


