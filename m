Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:46429 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbcISIyb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:54:31 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v2 6/9] cfg80211: Provide an API to report NAN function
 termination
Date: Mon, 19 Sep 2016 08:54:25 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED572895B4@hasmsx108.ger.corp.intel.com> (sfid-20160919_105435_456028_6DCB51E4)
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-7-luca@coelho.fi>
 <c72fdae0-fa63-be83-62dc-9c7f409fcc61@broadcom.com>
 <66d12a94-4d7b-eadc-8ee2-b55ab8239296@broadcom.com>
In-Reply-To: <66d12a94-4d7b-eadc-8ee2-b55ab8239296@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Sunday, September 18, 2016 23:00
> To: Luca Coelho <luca@coelho.fi>; johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org; Beker, Ayala <ayala.beker@intel.com>;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>; Grumbach,
> Emmanuel <emmanuel.grumbach@intel.com>; Coelho, Luciano
> <luciano.coelho@intel.com>
> Subject: Re: [PATCH v2 6/9] cfg80211: Provide an API to report NAN function
> termination
> 
> On 18-9-2016 21:56, Arend Van Spriel wrote:
> > On 16-9-2016 10:33, Luca Coelho wrote:
> >> From: Ayala Beker <ayala.beker@intel.com>
> >>
> >> Provide a function that reports NAN DE function termination. The
> >> function may be terminated due to one of the following reasons: user
> >> request, ttl expiration or failure.
> >> If the NAN instance is tied to the owner, the notification will be
> >> sent to the socket that started the NAN interface only
> >
> > So the driver is supposed to use this function from the .rm_nan_func
> > callback (or .del_nan_func). How should the driver use this together
> > with cfg80211_free_nan_func() function.
> 
> Hit Send button too fast. Would it make sense to free the nan func implicitly
> in cfg80211_nan_func_terminated() function or would there be reasons to
> keep it.

Currently when the NAN interface is stopped (ieee80211_do_stop) the termination notification can't be sent, since ieee80211_vif_to_wdev will return NULL after SDATA_STATE_RUNNING bit is cleared.
I guess it's similar not only for mac80211, and in case of interface removal we don't really want to send notifications for each function.

> 
> Regards,
> Arend
