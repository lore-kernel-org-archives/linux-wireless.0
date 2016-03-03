Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:39530 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755223AbcCCPzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:55:43 -0500
Subject: Re: [PATCH v2 1/2] mac80211: add A-MSDU tx support
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
 <1457016860.2044.11.camel@sipsolutions.net> <56D85428.6090705@openwrt.org>
 <1457019447.2044.24.camel@sipsolutions.net>
Cc: egrumbach@gmail.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56D85E67.1050909@openwrt.org> (sfid-20160303_165605_272461_7AEC5E12)
Date: Thu, 3 Mar 2016 16:55:19 +0100
MIME-Version: 1.0
In-Reply-To: <1457019447.2044.24.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-03 16:37, Johannes Berg wrote:
> On Thu, 2016-03-03 at 16:11 +0100, Felix Fietkau wrote:
>> 
>> For my own uses, I'd be perfectly fine with limiting A-MSDU size to
>> HT limits even when using VHT - in fact I did that in an early RFC
>> patch. I mainly relaxed the limit for VHT based on Emmanuel's
>> feedback. I also have doubts about the value of A-MSDU size beyond
>> 4095 bytes.
>> 
>> Just let me know which way you'd like it, and I'll send v3
>> accordingly.
>> 
> 
> I don't really know, I can live with both ways. I'm just a bit worried
> that we make enabling this feature so complex that nobody will get it
> right.
> 
> Perhaps we could also just remove this, make the default
> for max_rc_amsdu_len be 4095 (or so) and leave the rest to the rate
> control? We could entirely remove this check here, and let minstrel
> only use higher values if VHT is supported (and consequently will be
> used)?
Yeah, that makes sense.

- Felix
