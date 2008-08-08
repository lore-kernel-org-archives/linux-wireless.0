Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:33942 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYHHSYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 14:24:36 -0400
Received: by an-out-0708.google.com with SMTP id d40so180697and.103
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2008 11:24:35 -0700 (PDT)
Message-ID: <43e72e890808081124q2244b7f4k257b85d93e144f76@mail.gmail.com> (sfid-20080808_202439_556746_A22A72AA)
Date: Fri, 8 Aug 2008 11:24:35 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 1/2] mac80211: change number of pre-assoc scans
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>, linville@tuxdriver.com,
	johannes@sipsolutions.net, "Zhu, Yi" <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB0542F64C@hasmsx411.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1218149447-28968-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890808071559k207a34e3we21cb2633f5e248d@mail.gmail.com>
	 <1879838866982C46A9CB3D56BA49ADEB0542F64C@hasmsx411.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 8, 2008 at 7:18 AM, Rindjunsky, Ron
<ron.rindjunsky@intel.com> wrote:
>
>>> -       int auth_tries, assoc_tries;
>>> +       int assoc_scan_tries; /* number of scans done pre-association
> */
>>> +       int auth_tries; /* retries for auth req */
>>> +       int assoc_tries; /* retries for assoc req */
>>
>> This last variable seems unused.
>>
>
> If you mean auth_tries or assoc_tries they are being used in other
> flows.

Oh sorry, yes I see.

>>>                ieee80211_sta_reset_auth(dev, ifsta);
>>>                return 0;
>>>        } else {
>>> -               if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE)
> {
>>> +               if (ifsta->assoc_scan_tries <
> IEEE80211_ASSOC_SCANS_MAX_TRIES) {
>>> +                       ifsta->assoc_scan_tries++;
>>>                        if (ifsta->flags &
> IEEE80211_STA_AUTO_SSID_SEL)
>>>                                ieee80211_sta_start_scan(dev, NULL,
> 0);
>>>                        else
>>
>> Interesting, is there a race then?
>>
>
> Not more then before this patch :).. if you mean protecting the mlme
> states

Yeah that's what I meant.

>  I think this should be carefully handled, for sure not under this
> patch

Sure.

  Luis
