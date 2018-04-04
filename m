Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:46332 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbeDDJVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 05:21:23 -0400
Received: by mail-qt0-f177.google.com with SMTP id h4so22333262qtn.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2018 02:21:22 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Update ERP info using
 NL80211_CMD_UPDATE_CONNECT_PARAMS
To: Johannes Berg <johannes@sipsolutions.net>,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
References: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
 <1512990779.26976.69.camel@sipsolutions.net> <5ABCCA33.8070501@broadcom.com>
 <1522322166.5932.13.camel@sipsolutions.net> <5ABCCE7D.3050702@broadcom.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        amarnath@qti.qualcomm.com, usdutt@qti.qualcomm.com,
        vamsin@qti.qualcomm.com, Jithu Jance <jithu.jance@broadcom.com>,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AC4990E.7060806@broadcom.com> (sfid-20180404_112127_008769_15CC1A6D)
Date: Wed, 4 Apr 2018 11:21:18 +0200
MIME-Version: 1.0
In-Reply-To: <5ABCCE7D.3050702@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/29/2018 1:31 PM, Arend van Spriel wrote:
>> So yeah, I'd argue that what the patch needed was somebody taking a
>> critical look at my review ;-)
>>
>> And perhaps fixing the weird flags thing I pointed out.
>
> Yup. That made sense.

Hi Johannes,

Started working on this and actually the "weird flags thing" is done for 
a reason. Maybe the reason was because it is done like that in the 
CMD_CONNECT case, but the better reason is that we need to return 
-EINVAL for "no-fils-offload-support, any-fils-param" *and* 
"fils-offload-support, not-all-fils-param".

> Also there is a DOC section about FILS shared key authentication
> offload" so I suppose that should be extended as well.

So looking at the DOC section I am reading the following:

  * When FILS shared key authentication is completed, driver needs to 
provide the
  * below additional parameters to userspace.
  *	%NL80211_ATTR_FILS_KEK - used for key renewal
  *	%NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM - used in further EAP-RP exchanges
  *	%NL80211_ATTR_PMKID - used to identify the PMKSA used/generated
  *	%Nl80211_ATTR_PMK - used to update PMKSA cache in userspace
  * The PMKSA can be maintained in userspace persistently so that it can 
be used
  * later after reboots or wifi turn off/on also.

So to me it seems we need these for the ROAM event as well. Agree?

Regards,
Arend
