Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:16505 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610AbcDFJpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:45:25 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Subject: RE: [PATCHv3 RESEND 01/11] cfg80211: add start / stop NAN commands
Date: Wed, 6 Apr 2016 09:44:56 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EAA5599@hasmsx107.ger.corp.intel.com> (sfid-20160406_114529_231318_06C5B030)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
 <20160406093402.GA10595@jouni.qca.qualcomm.com>
In-Reply-To: <20160406093402.GA10595@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
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

Yes, but you can still have this default being defined in user space. While I agree that
the kernel could accept the command even if that attribute is not present, this code,
by itself, doesn't mean that it does not comply with the spec. It just defines a different
partition of the roles.

I read the spec again, and I fail to see how you deduce from this that 128 should be the default.
Different devices will have different master preferences. Infrastructure devices will have >=128
which hints that they want to be master (consume more power) most probably because they
are powered. Other devices that would prefer to avoid being master should set their out of the
box master preference to <128.
