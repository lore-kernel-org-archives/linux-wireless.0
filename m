Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC79C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C049C21850
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbeLRN2H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:28:07 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41058 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbeLRN2G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 08:28:06 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZFPo-0006tM-Hv; Tue, 18 Dec 2018 14:28:04 +0100
Message-ID: <dd3263b2b3f0850a26b316f9e8cb0cba81dc97c7.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Authentication offload to user space in AP
 mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Srinivas Dasari <dasaris@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date:   Tue, 18 Dec 2018 14:28:02 +0100
In-Reply-To: <1544779909-27758-1-git-send-email-dasaris@codeaurora.org> (sfid-20181214_103219_686121_BC072990)
References: <1544779909-27758-1-git-send-email-dasaris@codeaurora.org>
         (sfid-20181214_103219_686121_BC072990)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,


> @@ -2813,6 +2826,7 @@ struct cfg80211_pmk_conf {
>   *	use %WLAN_STATUS_UNSPECIFIED_FAILURE if user space cannot give you
>   *	the real status code for failures. Used only for the authentication
>   *	response command interface (user space to driver).
> + * @pmkid: The identifier to refer a PMKSA.
>   */
>  struct cfg80211_external_auth_params {
>  	enum nl80211_external_auth_action action;
> @@ -2820,6 +2834,7 @@ struct cfg80211_external_auth_params {
>  	struct cfg80211_ssid ssid;
>  	unsigned int key_mgmt_suite;
>  	u16 status;
> +	const u8 *pmkid;

So, interesting - Andrei also added the PMKID but also the PMK here, in
a separate patch:
https://patchwork.kernel.org/patch/10732093/

>   * @NL80211_ATTR_EXTERNAL_AUTH_SUPPORT: Flag attribute indicating that the user
> - *     space supports external authentication. This attribute shall be used
> - *     only with %NL80211_CMD_CONNECT request. The driver may offload
> - *     authentication processing to user space if this capability is indicated
> - *     in NL80211_CMD_CONNECT requests from the user space.
> + *	space supports external authentication. This attribute shall be used
> + *	with %NL80211_CMD_CONNECT and %NL80211_CMD_START_AP request. The driver
> + *	may offload authentication processing to user space if this capability
> + *	is indicated in the respective requests from the user space.

Thanks for indenting this properly.

> @@ -12981,7 +12984,10 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
>  	if (!rdev->ops->external_auth)
>  		return -EOPNOTSUPP;
>  
> -	if (!info->attrs[NL80211_ATTR_SSID])
> +	if (!info->attrs[NL80211_ATTR_SSID] &&
> +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
> +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
> +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>  		return -EINVAL;

Hm. do we really expect this on AP_VLAN?

johannes

