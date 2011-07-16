Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3049 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab1GPJ71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 05:59:27 -0400
Message-ID: <4E2160EC.8020003@broadcom.com> (sfid-20110716_115930_724080_25CAA5ED)
Date: Sat, 16 Jul 2011 11:59:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <error27@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 22/35] staging: brcm80211: fix for checkpatch 'avoid
 externs in c file' warning
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
 <1310678971-28952-23-git-send-email-frankyl@broadcom.com>
 <20110716000626.GI18655@shale.localdomain>
In-Reply-To: <20110716000626.GI18655@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2011 02:06 AM, Dan Carpenter wrote:
>> @@ -3552,8 +3552,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
>>   		if (wlc->shortslot)
>>   			cfg->current_bss->capability |=
>>   					WLAN_CAPABILITY_SHORT_SLOT_TIME;
>> -	END_FOREACH_BSS
>> -
>> +	END_FOREACH_BSS /* this comment fixes a checkpatch warning */
> I don't have strong feelings about this, but another way to do that
> would be to write it like:
>
> 	FOR_EACH(blah, blah) {
> 		frob();
> 		frob();
> 		frob();
> 	} END_FOREACH_BSS();

Maybe have to revisit the macro definitions. Will look into this. As 
this patch fixes some true extern warnings I suggest to let this one go 
in the tree.

> Or if you know perl, you could look into why checkpatch is printing
> the wrong warning here...

I moved on to python scripting and perl got flushed from memory ;-)

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


