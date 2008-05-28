Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:24252 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYE1GRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 02:17:11 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3107085waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2008 23:17:10 -0700 (PDT)
Message-ID: <1ba2fa240805272317t359e79d2xb1913779939ac7c9@mail.gmail.com> (sfid-20080528_081716_548167_E605A693)
Date: Wed, 28 May 2008 09:17:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>
Subject: Re: [PATCH 1/1] mac80211: sends HT IE to user level through wext
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1211909055.3930.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com>
	 <1211907892.3930.19.camel@johannes.berg>
	 <20080527172032.GN4932@jm.kir.nu>
	 <1211909055.3930.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2008 at 8:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> I would prefer to get all IEs in one blob (assuming WEXT does not have
>> length limits on this data that could be up to about 2250 bytes long).
>
> Good point. That should actually be doable quite easily.
>
>> This would avoid need to add new IEs one by one in the future (e.g., for
>> IEEE 802.11r).
>
> Yeah, precisely.
>
>> wpa_supplicant should be able to combine multiple IEs (or even multiple
>> IE groups) together, so I'm not too concerned of this being done
>> separately, but in general, it would be simpler to just pass all IEs as
>> a single blob. It might even be worthwhile to start storing the IEs as a
>> single buffer and have helper functions to fetch pointer to the
>> beginning of whatever IE is needed in the MLME code (this is how the
>> current wpa_supplicant processes IEs from scan results).
>
> Actually, we do store them in one blob and then hand out pointers to the
> various parts.
>
> johannes
>

Would this work with current and older version of  wpa_supplicant?.
I'm concern with backward compatibility,

Thanks
Tomas
