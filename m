Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab0C2QNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 12:13:52 -0400
Subject: Re: [patch] iwlwifi: range checking issue
From: reinette chatre <reinette.chatre@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>
Cc: Dan Carpenter <error27@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <1269828072.4043.247.camel@debian>
References: <20100328115500.GX5069@bicker>
	 <1269828072.4043.247.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 09:13:51 -0700
Message-ID: <1269879231.2446.3410.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-03-28 at 19:01 -0700, Zhu, Yi wrote:
> On Sun, 2010-03-28 at 19:55 +0800, Dan Carpenter wrote:
> > IWL_RATE_COUNT is 13 and IWL_RATE_COUNT_LEGACY is 12.
> > 
> > IWL_RATE_COUNT_LEGACY is the right one here because iwl3945_rates
> > doesn't support 60M and also that's how "rates" is defined in
> > iwlcore_init_geos() from drivers/net/wireless/iwlwifi/iwl-core.c.
> > 
> >         rates = kzalloc((sizeof(struct ieee80211_rate) * IWL_RATE_COUNT_LEGACY),
> >                         GFP_KERNEL);
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Zhu Yi <yi.zhu@intel.com>

Great catch. Since this is a fix for a buffer overflow ... could you
please pass it on to stable also?

Thank you

Reinette

