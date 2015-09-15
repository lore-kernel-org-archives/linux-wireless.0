Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54645 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbIOHVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 03:21:38 -0400
Message-ID: <55F7C6FF.3050802@codeaurora.org> (sfid-20150915_092141_964908_91382148)
Date: Tue, 15 Sep 2015 00:21:35 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com> <1440673024-13696-4-git-send-email-me@bobcopeland.com> <87oahc9g9h.fsf@kamboji.qca.qualcomm.com> <87fv2o9cvl.fsf@kamboji.qca.qualcomm.com> <20150909164945.GA4062@localhost> (sfid-20150909_184950_812635_9318273F) <1441869764.2108.1.camel@sipsolutions.net>
In-Reply-To: <1441869764.2108.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 09/10/2015 12:22 AM, Johannes Berg wrote:
> On Wed, 2015-09-09 at 12:49 -0400, Bob Copeland wrote:
>> On Wed, Sep 09, 2015 at 12:10:38PM +0300, Kalle Valo wrote:
>>>> I did a quick smoke test and saw the splat below. It's this
>>>> warning from
>>>> cfg80211:
>>>>
>>>> 			/*
>>>> 			 * Don't advertise an unsupported type
>>>> 			 * in a combination.
>>>> 			 */
>>>> 			if (WARN_ON((wiphy->interface_modes &
>>>> types) != types))
>>>> 				return -EINVAL;
>> OK, this happens when mesh is configured out (we mask off the mesh
>> interface_modes internally but not the types).  Sent an updated
>> version with appropriate ifdefs added.
> Yeah this is an unfortunate quirk in the APIs ... I think adding the
> ifdefs to the driver is the best thing to do.
>
> johannes
Can we configure mesh point with hostapd or can we use mesh point 
without neither wpa_supplicant nor hostapd?
Currently I'm trying to bring up mesh point, but whenever I run hostpad 
after creating mesh point (iw phy0 interface add mesh type mp), hostapd 
change the interface mode to managed.
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
Thanks,
Peter
