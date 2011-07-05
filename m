Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2021 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1GEOLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 10:11:38 -0400
Message-ID: <4E131B86.2030202@broadcom.com> (sfid-20110705_161142_039079_135B9C36)
Date: Tue, 5 Jul 2011 16:11:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 017/119] staging: brcm80211: change FOREACH_BSS
 macro to remove checkpatch error
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-18-git-send-email-frankyl@broadcom.com>
 <20110630083700.GK14591@shale.localdomain>
 <4E0C4DB2.7090506@broadcom.com>
In-Reply-To: <4E0C4DB2.7090506@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 12:19 PM, Arend van Spriel wrote:
> On 06/30/2011 10:37 AM, Dan Carpenter wrote:
>> That's pretty ugly.  Better to leave the original in and ignore the
>> checkpatch warning.  Or maybe do something like this:
>>
>> 	for (idx = 0; (int) idx<   WLC_MAXBSSCFG; idx++) { \
>> 		cfg = (wlc)->bsscfg[idx];		  \
>> 		if (!cfg)				  \
>> 			continue;			  \
>>
>> Then #define END_FOREACH_BSS() }
> Hi Dan,
>
> I agree this is not the nicest solution. It was a checkpatch error so we
> felt an urge to fix it. A warning would have been easier to ignore. I
> will have a look and see whether the patch can be dropped without
> issues. Your feedback is noted so I will look for a better iteration
> solution to replace this.

Hi Greg,

Can you please drop this patch from the series? There are no 
dependencies with the other patches.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


