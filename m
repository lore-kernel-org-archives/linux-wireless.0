Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964881AbcDFKO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 06:14:56 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN commands
Date: Wed, 6 Apr 2016 10:14:52 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED5701D866@hasmsx108.ger.corp.intel.com> (sfid-20160406_121521_089963_E32DA325)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
 <20160406093402.GA10595@jouni.qca.qualcomm.com>
In-Reply-To: <20160406093402.GA10595@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Malinen, Jouni [mailto:jouni@qca.qualcomm.com]
> Sent: Wednesday, April 6, 2016 12:34 PM
> To: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>
> Cc: johannes@sipsolutions.net; linux-wireless@vger.kernel.org;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>
> Subject: Re: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN
> commands
> 
> On Tue, Mar 29, 2016 at 12:34:59PM +0300, Emmanuel Grumbach wrote:
> > Define several attributes that may be configured by user space when
> > starting NAN functionality (master preference and dual band operation)
> 
> > diff --git a/include/uapi/linux/nl80211.h
> > b/include/uapi/linux/nl80211.h @@ -826,6 +826,16 @@
> > + * @NL80211_CMD_START_NAN: Start NAN operation, identified by its
> > + *	%NL80211_ATTR_WDEV interface. This interface must have been
> previously
> > + *	created with %NL80211_CMD_NEW_INTERFACE. After it has been
> started, the
> > + *	NAN interface will create or join a cluster. This command must have a
> > + *	valid %NL80211_ATTR_NAN_MASTER_PREF attribute and optional
> > + *	%NL80211_ATTR_NAN_DUAL attributes.
> 
> 
> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> 
> > +static int nl80211_start_nan(struct sk_buff *skb, struct genl_info
> > +*info)
> 
> > +	if (!info->attrs[NL80211_ATTR_NAN_MASTER_PREF])
> > +		return -EINVAL;
> 
> Why NL80211_ATTR_NAN_MASTER_PREF is mandatory? The spec suggests
> to assume master preference value of 128 if not provided. Please see quoted
> text from NAN 1.0 specification:
> "A NAN Device which out-of-the-box will have a Master Preference greater
> than or equal to 128 with the intention of being a NAN Master Device"
> 
I think that this quote just defines "NAN infrastructure device".
I don't see where the spec specifies that 128 should be used as a default value.

Andrei

> --
> Jouni Malinen                                            PGP id EFC895FA
