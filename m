Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2895 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759980AbcISH4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:56:33 -0400
From: "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Luca Coelho <luca@coelho.fi>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH v2 3/9] cfg80211: add add_nan_func / rm_nan_func
Date: Mon, 19 Sep 2016 07:56:24 +0000
Message-ID: <B2CD83211F5FDD478D7EFFF030D107ED572894EC@hasmsx108.ger.corp.intel.com> (sfid-20160919_095637_502635_D30EECD6)
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-4-luca@coelho.fi>
 <33437eef-ab4b-4648-010d-1e35f426adab@broadcom.com>
In-Reply-To: <33437eef-ab4b-4648-010d-1e35f426adab@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Sunday, September 18, 2016 22:29
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
> >  include/net/cfg80211.h       |  91 +++++++++++
> >  include/uapi/linux/nl80211.h | 153 ++++++++++++++++++
> >  net/wireless/core.c          |   3 +-
> >  net/wireless/nl80211.c       | 368
> +++++++++++++++++++++++++++++++++++++++++++
> >  net/wireless/rdev-ops.h      |  21 +++
> >  net/wireless/trace.h         |  39 +++++
> >  net/wireless/util.c          |  22 +++
> >  7 files changed, 696 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h index
> > ca64d69..ced5b8a 100644
> > --- a/include/net/cfg80211.h
> > +++ b/include/net/cfg80211.h
> > @@ -2306,6 +2306,73 @@ struct cfg80211_nan_conf {  };
> >
> >  /**
> > + * struct cfg80211_nan_func_filter - a NAN function Rx / Tx filter
> > + *
> > + * @filter: the content of the filter
> > + * @len: the length of the filter
> > + */
> > +struct cfg80211_nan_func_filter {
> > +	const u8 *filter;
> > +	u8 len;
> > +};
> > +
> > +/**
> > + * struct cfg80211_nan_func - a NAN function
> > + *
> > + * @type: &enum nl80211_nan_function_type
> > + * @service_id: the service ID of the function
> > + * @publish_type: &nl80211_nan_publish_type
> > + * @close_range: if true, the range should be limited. Threshold is
> > + *	implementation specific.
> > + * @publish_bcast: if true, the solicited publish should be
> > +broadcasted
> > + * @subscribe_active: if true, the subscribe is active
> > + * @followup_id: the instance ID for follow up
> > + * @followup_reqid: the requestor instance ID for follow up
> > + * @followup_dest: MAC address of the recipient of the follow up
> > + * @ttl: time to live counter in DW.
> > + * @serv_spec_info: Service Specific Info
> > + * @serv_spec_info_len: Service Specific Info length
> > + * @srf_include: if true, SRF is inclusive
> > + * @srf_bf: Bloom Filter
> > + * @srf_bf_len: Bloom Filter length
> > + * @srf_bf_idx: Bloom Filter index
> > + * @srf_macs: SRF MAC addresses
> > + * @srf_num_macs: number of MAC addresses in SRF
> > + * @rx_filters: rx filters that are matched with corresponding peer's
> > +tx_filter
> > + * @tx_filters: filters that should be transmitted in the SDF.
> > + * @num_rx_filters: length of &rx_filters.
> > + * @num_tx_filters: length of &tx_filters.
> > + * @instance_id: driver allocated id of the function.
> > + * @cookie: unique NAN function identifier.
> 
> Might be wrong but it seems a subset of the fields is used depending on the
> type of NAN function. Maybe better to separate the function type specific
> field in a sub structure defintion.

Most of the fields are common for all the function types. Of course some combinations aren't valid.
And there are few followup specific fields. The spec defines a single "NAN function" entity (for publish, subscribe and followup) which is represented in an SDA (service descriptor attribute).
This is what this struct tries to reflect.

> 
> > + */
> > +struct cfg80211_nan_func {
> > +	enum nl80211_nan_function_type type;
> > +	u8 service_id[NL80211_NAN_FUNC_SERVICE_ID_LEN];
> > +	u8 publish_type;
> > +	bool close_range;
> > +	bool publish_bcast;
> > +	bool subscribe_active;
> > +	u8 followup_id;
> > +	u8 followup_reqid;
> > +	struct mac_address followup_dest;
> > +	u32 ttl;
> > +	const u8 *serv_spec_info;
> > +	u8 serv_spec_info_len;
> > +	bool srf_include;
> > +	const u8 *srf_bf;
> > +	u8 srf_bf_len;
> > +	u8 srf_bf_idx;
> > +	struct mac_address *srf_macs;
> > +	int srf_num_macs;
> > +	struct cfg80211_nan_func_filter *rx_filters;
> > +	struct cfg80211_nan_func_filter *tx_filters;
> > +	u8 num_tx_filters;
> > +	u8 num_rx_filters;
> > +	u8 instance_id;
> > +	u64 cookie;
> > +};
> > +
> > +/**
> >   * struct cfg80211_ops - backend description for wireless configuration
> >   *
> >   * This struct is registered by fullmac card drivers and/or wireless
> > stacks @@ -2595,6 +2662,14 @@ struct cfg80211_nan_conf {
> >   *	peers must be on the base channel when the call completes.
> >   * @start_nan: Start the NAN interface.
> >   * @stop_nan: Stop the NAN interface.
> > + * @add_nan_func: Add a NAN function. Returns negative value on
> failure.
> > + *	On success @nan_func ownership is transferred to the driver and
> > + *	it may access it outside of the scope of this function. The driver
> > + *	should free the @nan_func when no longer needed by calling
> > + *	cfg80211_free_nan_func().
> > + *	On success the driver should assign an instance_id in the
> > + *	provided @nan_func.
> > + * @rm_nan_func: Remove a NAN function.
> 
> Would prefer del_nan_func here. At least all other add_* callbacks in this
> structure have a del_* counter part.

Hmm..  A little bit nitpicky ;) but ok..
( I personally prefer to use "remove" to reflect removal from a list and del for "erase" like operations - here it does both)

> 
> >   */
> >  struct cfg80211_ops {
> >  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan
> *wow);
> > @@ -2863,6 +2938,10 @@ struct cfg80211_ops {
> >  	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev
> *wdev,
> >  			     struct cfg80211_nan_conf *conf);
> >  	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev
> *wdev);
> > +	int	(*add_nan_func)(struct wiphy *wiphy, struct wireless_dev
> *wdev,
> > +				struct cfg80211_nan_func *nan_func);
> > +	void	(*rm_nan_func)(struct wiphy *wiphy, struct wireless_dev
> *wdev,
> > +			       u64 cookie);
> >  };
> >
> >  /*
> > @@ -3311,6 +3390,8 @@ struct wiphy_iftype_ext_capab {
> >   * @bss_select_support: bitmask indicating the BSS selection criteria
> supported
> >   *	by the driver in the .connect() callback. The bit position maps to the
> >   *	attribute indices defined in &enum nl80211_bss_select_attr.
> > + *
> > + * @cookie_counter: unique generic cookie counter, used to identify
> objects.
> >   */
> >  struct wiphy {
> >  	/* assign these fields before you register the wiphy */ @@ -3440,6
> > +3521,8 @@ struct wiphy {
> >
> >  	u32 bss_select_support;
> >
> > +	u64 cookie_counter;
> > +
> >  	char priv[0] __aligned(NETDEV_ALIGN);  };
> >
> > @@ -5529,6 +5612,14 @@ wiphy_ext_feature_isset(struct wiphy *wiphy,
> >  	return (ft_byte & BIT(ftidx % 8)) != 0;  }
> >
> > +/**
> > + * cfg80211_free_nan_func - free NAN function
> > + * @f: NAN function that should be freed
> > + *
> > + * Frees all the NAN function and all it's allocated members.
> > + */
> > +void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
> > +
> >  /* ethtool helper */
> >  void cfg80211_get_drvinfo(struct net_device *dev, struct
> > ethtool_drvinfo *info);
> >
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
> >   *
> >   * @NL80211_CMD_MAX: highest used command number
> >   * @__NL80211_CMD_AFTER_LAST: internal use @@ -1038,6 +1056,8 @@
> enum
> > nl80211_commands {
> >
> >  	NL80211_CMD_START_NAN,
> >  	NL80211_CMD_STOP_NAN,
> > +	NL80211_CMD_ADD_NAN_FUNCTION,
> > +	NL80211_CMD_RM_NAN_FUNCTION,
> 
> NL80211_CMD_DEL_NAN_FUNCTION?
> 
> Regards,
> Arend
