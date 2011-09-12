Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1049 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab1ILNfD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 09:35:03 -0400
Message-ID: <4E6E0A7A.9010801@broadcom.com> (sfid-20110912_153511_893272_4ECCE117)
Date: Mon, 12 Sep 2011 15:34:50 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/20] staging: brcm80211: remove static variables
 from wl_cfg80211.c
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
 <1315822504-24210-10-git-send-email-rvossen@broadcom.com>
 <20110912130640.GH14370@shale.localdomain>
In-Reply-To: <20110912130640.GH14370@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2011 03:06 PM, Dan Carpenter wrote:
> On Mon, Sep 12, 2011 at 12:14:53PM +0200, Roland Vossen wrote:
>> -	cfg80211_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
>> -	if (unlikely(!cfg80211_dev)) {
>> +	cfg_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
>> +	if (unlikely(!cfg_dev)) {
>>   		WL_ERR("wl_cfg80211_dev is invalid\n");
>
> This message is wrong.  Also it isn't needed because kzalloc() prints
> its own more complete message.

Understood. Will remove this in a subsequent patch.

> Also unlikely() isn't needed here in the attach function.  Likely and
> unlikely hints only belong in the fast path, and generally shouldn't
> be included in driver code (only in core kernel code).

I will remove all likely/unlikely instances in the drivers except for 
places where we think they are justified, which I suspect is in 0 places.

Thanks for the review,

Roland.

