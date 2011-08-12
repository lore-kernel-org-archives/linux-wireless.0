Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2936 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab1HLTKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 15:10:43 -0400
Message-ID: <4E457AA4.3030401@broadcom.com> (sfid-20110812_211045_069321_B67F3088)
Date: Fri, 12 Aug 2011 21:10:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"=?UTF-8?B?UmFmYcWCIE1p?= =?UTF-8?B?xYJlY2tp?=" <zajec5@gmail.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/14] staging: brcm80211: use wait queues instead
 of semaphores in wl_cfg80211.c
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
 <1313156101-16817-2-git-send-email-arend@broadcom.com>
 <CACna6rzmaxzezN-OPTLvXyFOZOsoq6XCds4P-FOEz27FzJz+Jg@mail.gmail.com>
 <4E455877.6090901@broadcom.com> <4E45781E.8070508@broadcom.com>
 <4E457A30.3010701@lwfinger.net>
In-Reply-To: <4E457A30.3010701@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 09:08 PM, Larry Finger wrote:
> On 08/12/2011 01:59 PM, Franky Lin wrote:
>> If you are refering to this line
>>   >>>  + } while ((e = brcmf_deq_event(cfg_priv)));
>>
>> The extra parentheses are added to fix a compiler warning:
>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c: In function
>> ‘brcmf_event_handler’:
>> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:3576: warning: suggest
>> parentheses around assignment used as truth value
> Does checkpatch allow that assignment in the while statement? I would expect it
> to want you to
>
> 		e = brcmf_deq_event(cfg_priv);
> 	} while (e);
>
> Larry
>

Yep. That is the v2 I sent. btw checkpatch did not complain on the 
original patch.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


