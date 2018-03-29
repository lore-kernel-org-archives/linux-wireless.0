Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36812 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbeC2LQJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 07:16:09 -0400
Message-ID: <1522322166.5932.13.camel@sipsolutions.net> (sfid-20180329_131613_723858_57BA74F5)
Subject: Re: [PATCH] nl80211: Update ERP info using
 NL80211_CMD_UPDATE_CONNECT_PARAMS
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        vkanchan@qti.qualcomm.com, amarnath@qti.qualcomm.com,
        usdutt@qti.qualcomm.com, vamsin@qti.qualcomm.com
Date: Thu, 29 Mar 2018 13:16:06 +0200
In-Reply-To: <5ABCCA33.8070501@broadcom.com> (sfid-20180329_131256_170260_82227DE0)
References: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
         <1512990779.26976.69.camel@sipsolutions.net>
         <5ABCCA33.8070501@broadcom.com> (sfid-20180329_131256_170260_82227DE0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> Picking up a somewhat old thread as I did not see a follow-up on this 
> patch. I got queried about it over here by our FILS team. So what is 
> needed for this patch to pass the bar?

That's indeed a bit old :-)

> > > + * @UPDATE_FILS_ERP_INFO: Indicates that FILS connection parameters (realm,
> > > + *	username, erp sequence number and rrk) are updated
> > > + * @UPDATE_AUTH_TYPE: Indicates that Authentication type is updated
> > 
> > These are new here, but you don't know if they were actually supported:
> > 
> > > +	if (wiphy_ext_feature_isset(&rdev->wiphy,
> > > +				    NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&
> > 
> > here.
> 
> The description of the FILS_SK_OFFLOAD currently says:
> 
>   * @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD: Driver SME supports FILS 
> shared key
>   *      authentication with %NL80211_CMD_CONNECT.
> 
> Are you suggesting a new flag to cover the new update attributes?

[snip]

> > Again, how do you know the driver will actually look at
> > UPDATE_AUTH_TYPE?
> 
> If they don't they are broken, right? And if they are broken, the 
> connection will drop and regular connect will happen anyway, no?
> 
> We could add a new flag to signal driver will handle the extra 
> parameters in UPDATE_CONNECT_PARAMS, but it is not clear why it would be 
> needed. Seems to me user-space has all the info needed with the existing 
> flag(s).

Agree, and we don't even have any drivers that are setting the
FILS_SK_OFFLOAD flag anyway, so we can still redefine its semantics to
some extent.

So yeah, I'd argue that what the patch needed was somebody taking a
critical look at my review ;-)

And perhaps fixing the weird flags thing I pointed out.

johannes
