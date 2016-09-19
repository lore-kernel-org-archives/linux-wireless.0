Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6664 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752756AbcISIKC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 04:10:02 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v2 3/9] cfg80211: add add_nan_func / rm_nan_func
Date: Mon, 19 Sep 2016 08:09:57 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED57289546@hasmsx108.ger.corp.intel.com> (sfid-20160919_101006_460102_157E336F)
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-4-luca@coelho.fi>
 <d9c124a1-4d25-0f38-c9dc-a6b20cfa7956@broadcom.com>
In-Reply-To: <d9c124a1-4d25-0f38-c9dc-a6b20cfa7956@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Sunday, September 18, 2016 22:54
> To: Luca Coelho <luca@coelho.fi>; johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org; Beker, Ayala <ayala.beker@intel.com>;
> Otcheretianski, Andrei <andrei.otcheretianski@intel.com>; Grumbach,
> Emmanuel <emmanuel.grumbach@intel.com>; Coelho, Luciano
> <luciano.coelho@intel.com>
> Subject: Re: [PATCH v2 3/9] cfg80211: add add_nan_func / rm_nan_func
> 
> On 16-9-2016 10:33, Luca Coelho wrote:
> > From: Ayala Beker <ayala.beker@intel.com>
> >
> > A NAN function can be either publish, subscribe or follow up. Make all
> > the necessary verifications and just pass the request to the driver.
> > Allow the user space application that starts NAN to forbid any other
> > socket to add or remove functions.
> >
> > Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Ayala Beker <ayala.beker@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> 
> [...]
> 
> > diff --git a/include/uapi/linux/nl80211.h
> > b/include/uapi/linux/nl80211.h index 7ab18c8..ab16c8e 100644
> > --- a/include/uapi/linux/nl80211.h
> > +++ b/include/uapi/linux/nl80211.h
> > @@ -847,6 +847,24 @@
> >   *	After this command NAN functions can be added.
> >   * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
> >   *	its %NL80211_ATTR_WDEV interface.
> > + * @NL80211_CMD_ADD_NAN_FUNCTION: Add a NAN function. The
> function is defined
> > + *	with %NL80211_ATTR_NAN_FUNC nested attribute. When called,
> this
> > + *	operation returns the strictly positive and unique instance id
> > + *	(%NL80211_ATTR_NAN_FUNC_INST_ID) and a cookie
> (%NL80211_ATTR_COOKIE)
> > + *	of the function upon success.
> > + *	Since instance ID's can be re-used, this cookie is the right
> > + *	way to identify the function. This will avoid races when a termination
> > + *	event is handled by the user space after it has already added a new
> > + *	function that got the same instance id from the kernel as the one
> > + *	which just terminated.
> > + *	This cookie may be used in NAN events even before the command
> > + *	returns, so userspace shouldn't process NAN events until it
> processes
> > + *	the response to this command.
> > + *	Look at %NL80211_ATTR_SOCKET_OWNER as well.
> > + * @NL80211_CMD_RM_NAN_FUNCTION: Remove a NAN function by
> cookie.
> > + *	This command is also used as a notification sent when a NAN function
> is
> > + *	terminated. This will contain a %NL80211_ATTR_NAN_FUNC_INST_ID
> > + *	and %NL80211_ATTR_COOKIE attributes.
> 
> This patch does not show the notification scenario as it is added in patch 6. So
> those three lines could be added by that patch instead to keep things
> logically together.
> 

Good point. Thanks

> Regards,
> Arend
