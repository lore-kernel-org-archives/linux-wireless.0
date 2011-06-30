Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1547 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab1F3KUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 06:20:37 -0400
Message-ID: <4E0C4DB2.7090506@broadcom.com> (sfid-20110630_122040_936267_779ACCA4)
Date: Thu, 30 Jun 2011 12:19:30 +0200
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
In-Reply-To: <20110630083700.GK14591@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2011 10:37 AM, Dan Carpenter wrote:
> On Wed, Jun 29, 2011 at 04:46:41PM -0700, Franky Lin wrote:
>>   #define FOREACH_BSS(wlc, idx, cfg) \
>> -	for (idx = 0; (int) idx<  WLC_MAXBSSCFG; idx++) \
>> -		if ((cfg = (wlc)->bsscfg[idx]))
>> +	for (idx = 0, cfg = (wlc)->bsscfg[idx]; \
>> +	     idx<  WLC_MAXBSSCFG; cfg = (wlc)->bsscfg[++idx]) \
>> +		if (cfg)
>>
> That's pretty ugly.  Better to leave the original in and ignore the
> checkpatch warning.  Or maybe do something like this:
>
> 	for (idx = 0; (int) idx<  WLC_MAXBSSCFG; idx++) { \
> 		cfg = (wlc)->bsscfg[idx];		  \
> 		if (!cfg)				  \
> 			continue;			  \
>
> Then #define END_FOREACH_BSS() }

Hi Dan,

I agree this is not the nicest solution. It was a checkpatch error so we 
felt an urge to fix it. A warning would have been easier to ignore. I 
will have a look and see whether the patch can be dropped without 
issues. Your feedback is noted so I will look for a better iteration 
solution to replace this.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


