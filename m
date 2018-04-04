Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43450 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbeDDKgY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 06:36:24 -0400
Message-ID: <1522838180.3042.1.camel@sipsolutions.net> (sfid-20180404_123635_188613_A8861AA3)
Subject: Re: [PATCH] nl80211: Update ERP info using
 NL80211_CMD_UPDATE_CONNECT_PARAMS
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        amarnath@qti.qualcomm.com, usdutt@qti.qualcomm.com,
        vamsin@qti.qualcomm.com, Jithu Jance <jithu.jance@broadcom.com>,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>
Date: Wed, 04 Apr 2018 12:36:20 +0200
In-Reply-To: <5AC4990E.7060806@broadcom.com> (sfid-20180404_112123_933188_E2922C74)
References: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
         <1512990779.26976.69.camel@sipsolutions.net>
         <5ABCCA33.8070501@broadcom.com> <1522322166.5932.13.camel@sipsolutions.net>
         <5ABCCE7D.3050702@broadcom.com> <5AC4990E.7060806@broadcom.com>
         (sfid-20180404_112123_933188_E2922C74)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Started working on this and actually the "weird flags thing" is done for 
> a reason. Maybe the reason was because it is done like that in the 
> CMD_CONNECT case, but the better reason is that we need to return 
> -EINVAL for "no-fils-offload-support, any-fils-param" *and* 
> "fils-offload-support, not-all-fils-param".

Ok, fair enough.

> > Also there is a DOC section about FILS shared key authentication
> > offload" so I suppose that should be extended as well.
> 
> So looking at the DOC section I am reading the following:
> 
>   * When FILS shared key authentication is completed, driver needs to 
> provide the
>   * below additional parameters to userspace.
>   *	%NL80211_ATTR_FILS_KEK - used for key renewal
>   *	%NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM - used in further EAP-RP exchanges
>   *	%NL80211_ATTR_PMKID - used to identify the PMKSA used/generated
>   *	%Nl80211_ATTR_PMK - used to update PMKSA cache in userspace
>   * The PMKSA can be maintained in userspace persistently so that it can 
> be used
>   * later after reboots or wifi turn off/on also.
> 
> So to me it seems we need these for the ROAM event as well. Agree?

Maybe not all of them, you could be using the same PMKSA, but yes, I
tend to agree.

johannes
