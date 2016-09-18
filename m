Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37783 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753428AbcIRUAY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 16:00:24 -0400
Received: by mail-wm0-f41.google.com with SMTP id b130so30317014wmc.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2016 13:00:24 -0700 (PDT)
Subject: Re: [PATCH v2 6/9] cfg80211: Provide an API to report NAN function
 termination
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-7-luca@coelho.fi>
 <c72fdae0-fa63-be83-62dc-9c7f409fcc61@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <66d12a94-4d7b-eadc-8ee2-b55ab8239296@broadcom.com> (sfid-20160918_220028_858565_6565A48C)
Date: Sun, 18 Sep 2016 22:00:14 +0200
MIME-Version: 1.0
In-Reply-To: <c72fdae0-fa63-be83-62dc-9c7f409fcc61@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-9-2016 21:56, Arend Van Spriel wrote:
> On 16-9-2016 10:33, Luca Coelho wrote:
>> From: Ayala Beker <ayala.beker@intel.com>
>>
>> Provide a function that reports NAN DE function termination. The function
>> may be terminated due to one of the following reasons: user request,
>> ttl expiration or failure.
>> If the NAN instance is tied to the owner, the notification will be
>> sent to the socket that started the NAN interface only
> 
> So the driver is supposed to use this function from the .rm_nan_func
> callback (or .del_nan_func). How should the driver use this together
> with cfg80211_free_nan_func() function.

Hit Send button too fast. Would it make sense to free the nan func
implicitly in cfg80211_nan_func_terminated() function or would there be
reasons to keep it.

Regards,
Arend
