Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbcDFKn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 06:43:28 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCHv3 RESEND 06/11] cfg80211: Provide an API to report NAN
 function termination
Date: Wed, 6 Apr 2016 10:43:24 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED5701D8BD@hasmsx108.ger.corp.intel.com> (sfid-20160406_124331_859868_4844BBFD)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
 <1459244109-16038-6-git-send-email-emmanuel.grumbach@intel.com>
 <20160406094011.GC10595@jouni.qca.qualcomm.com>
In-Reply-To: <20160406094011.GC10595@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Malinen, Jouni [mailto:jouni@qca.qualcomm.com]
> Sent: Wednesday, April 6, 2016 12:40 PM
> To: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>
> Cc: johannes@sipsolutions.net; linux-wireless@vger.kernel.org;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>
> Subject: Re: [PATCHv3 RESEND 06/11] cfg80211: Provide an API to report
> NAN function termination
> 
> On Tue, Mar 29, 2016 at 12:35:04PM +0300, Emmanuel Grumbach wrote:
> > Provide a function that reports NAN DE function termination. The
> > function may be terminated due to one of the following reasons: user
> > request, ttl expiration or failure.
> 
> > diff --git a/include/uapi/linux/nl80211.h
> > b/include/uapi/linux/nl80211.h
> 
> > +/**
> > + * enum nl80211_nan_func_term_reason - NAN functions termination
> > +reason
> > + *
> > + * Defines termination reasons of a NAN function
> > + *
> > + * @NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST: requested
> by user
> > + * @NL80211_NAN_FUNC_TERM_REASON_TTL_EXPIRED: timeout
> > + * @NL80211_NAN_FUNC_TERM_REASON_ERROR: errored  */ enum
> > +nl80211_nan_func_term_reason {
> > +	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST,
> > +	NL80211_NAN_FUNC_TERM_REASON_TTL_EXPIRED,
> > +	NL80211_NAN_FUNC_TERM_REASON_ERROR,
> > +};
> 
> Can you please add
> NL80211_NAN_FUNC_TERM_REASON_VENDOR_SPECIFIC? That would help
> vendors to implement and send vendor specific reason codes if any.
> 

The termination reasons are defined in the spec. Also adding a single enum value will not help much if the vendor has multiple error codes.
So I think this info should be in a different attribute, if needed.

Andrei.

> --
> Jouni Malinen                                            PGP id EFC895FA
