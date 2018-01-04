Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52238 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753157AbeADOrj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 09:47:39 -0500
Message-ID: <1515077257.10342.23.camel@sipsolutions.net> (sfid-20180104_154743_914475_2E764D6D)
Subject: Re: [PATCH v2 1/3] cfg80211/nl80211: Optional authentication
 offload to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Date: Thu, 04 Jan 2018 15:47:37 +0100
In-Reply-To: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
References: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


Sorry for the delay - mostly was on vacation while/since you sent this.

>   * @ASSOC_REQ_USE_RRM: Declare RRM capability in this association
> + * @CONNECT_REQ_EXTERNAL_AUTH_SUPP: User space indicates external authentication
> + * capability. Drivers can offload authentication to userspace if this flag is
> + * set. Only applicable for cfg80211_connect() request (connect callback).

That should be indented by a tab, not just a space, for the
continuation lines. I'd have fixed this, but now that I'm commenting on
other things please fix it when you respin.

>  /**
> + * struct cfg80211_external_auth_params - External authentication
> + * trigger parameters. Commonly used across the external auth request and
> + * event interfaces.

This doesn't work - short description has to fit on a single line

> + * @action: action type / trigger for external authentication. Only significant
> + * for the event interface (from driver to user space).
> + * @bssid: BSSID of the peer with which the authentication has
> + *      to happen. Used by both the request and event interface.
> + * @ssid: SSID of the AP. Used by both the request and event interface.
> + * @key_mgmt_suite: AKM suite of the respective authentication. Optional for
> + *	the request interface.

Here it looks indented confusingly - sometimes tab maybe?, sometimes
spaces, sometimes nothing. Please use tabs.

> + * @status: status code, %WLAN_STATUS_SUCCESS for successful authentication,
> + *	use %WLAN_STATUS_UNSPECIFIED_FAILURE if user space cannot give you
> + *	the real status code for failures. Used only for the request
> + *	interface from user space to the driver.

The patch is called "offload to userspace", yet you speak about 
"request from user space". I'm thinking that's confusing? You also
speak about request/event a lot above, and when it's hard to figure out
which is which, that's not very helpful.

I suggest you rephrase this to something like "authentication [request]
event" and "authentication response [command/call]", or so?


You also completely neglected to document how the authentication even
happens. Using NL80211_CMD_AUTHENTICATE? But would a driver needing
this even support that? Or somehow using this new operation?


> + * @NL80211_CMD_EXTERNAL_AUTH: This command/event interface is exclusively
> + *	defined for host drivers that do not define separate commands for
> + *	authentication and association, bute rely on user space SME (e.g., in

typo: "but"

> + *	wpa_supplicant for the ~WPA_DRIVER_FLAGS_SME case) for the
> + *	authentication to happen.

But anyway this can't really be right - you mean use device SME? Please
don't use WPA_DRIVER_FLAGS_SME as documentation here, even as an
example, reword so you don't need the example.

> + *	User space uses the %NL80211_CMD_CONNECT command to the host driver for
> + *	triggering a connection. The host driver selects a BSS and further uses
> + *	this interface to offload only the authentication part to the user
> + *	space.

Yep, this contradicts what you said above.

>  Authentication frames are passed between the driver and user
> + *	space through the %NL80211_CMD_FRAME interface.

Ah, ok, so you did document that here a bit. I guess that works.

>  The status of
> + *	authentication is further indicated by user space to the host driver
> + *	with the %NL80211_CMD_EXTERNAL_AUTH command through
> + *	%NL80211_ATTR_STATUS_CODE attribute. This enables the driver to proceed
> + *	with association on successful authentication. 

Sure, that seems OK, except I don't see why the driver needs a status
code, vs. just "oops, something failed"?

> Driver shall use this
> + *	%NL80211_ATTR_STATUS_CODE attribute to report the connect result to
> + *	user space on an authentication failure.

I don't understand this part.

Ah, actually, ok - I get it - you feed that back to userspace as the
connect result.

Ok, fine, but please reword to make that more evident.

> + * @NL80211_ATTR_EXTERNAL_AUTH_SUPP: Flag attribute indicating that the user

I'd prefer you spell out "SUPPORT". It's just 3 more characters after
all.

> + * @NL80211_EXT_FEATURE_EXTERNAL_AUTH: Driver supports external authentication

Ok, so I seem to remember that I requested this, but does that even
make sense? After all, userspace can set the "I can do it" attribute
all it wants, if the driver never uses it then userspace will never
know whether or not it's because it just wasn't necessary, or because
the driver can't really do it, right?

> +static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	struct cfg80211_external_auth_params params;
> +
> +	if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +				     NL80211_EXT_FEATURE_EXTERNAL_AUTH) ||
> +	    !rdev->ops->external_auth)
> +		return -EOPNOTSUPP;

After all, the driver still has to check "did I request this", right?
Even on the CMD_FRAME.

> +int cfg80211_external_auth_request(struct net_device *dev,
> +				   struct cfg80211_external_auth_params *params,
> +				   gfp_t gfp)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_EXTERNAL_AUTH);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return -ENOMEM;

That's probably better -ENOBUFS too.

And since you free the message, there's no need for calling
genlmsg_cancel() below, and therefore you can just jump to the same
label here.

Anyway, I guess the code overall looks reasonable - some documentation
updates would be good. I'd actually remove the feature bit again and
explain why that isn't needed.

johannes
