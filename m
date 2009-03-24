Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759907AbZCXOru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 10:47:50 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Date: Tue, 24 Mar 2009 07:47:46 -0700
Subject: RE: wireless powersaving (in NM?)
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3546DA95D4@orsmsx506.amr.corp.intel.com> (sfid-20090324_154810_059379_6445E561)
References: <1237891149.4320.73.camel@johannes.local>
	 (sfid-20090324_133306_274219_3B7517AB)
 <1237902786.4320.92.camel@johannes.local>
In-Reply-To: <1237902786.4320.92.camel@johannes.local>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Especially for Netbook and Handle devices with newer processor. Putting system into lower C-state and having longer battery life is very important. I think letting driver making the default choice based on the power source is the right way to go, but always can be overwritten by upper layer (mac80211 or NM?).

I do not think we need to expose all the power levels to user space; those should be internal decision (mac80211 or driver). User space can make the choice of turn power saving mode on/off and leave the detail decision to the lower layer which has better knowledge of how to balance the power and performance.  


Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                 
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
 

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Tuesday, March 24, 2009 6:53 AM
To: Dan Williams
Cc: Guy, Wey-Yi W; linux-wireless; Kalle Valo; Matthew Garrett; Marcel Holtmann
Subject: Re: wireless powersaving (in NM?)


> Therefore, I think the "power saving level" needs to be determined by
> pm_qos.

Cf. http://www.lesswatts.org/projects/power-qos/ too, which is the old
description of pm_qos, see Documentation/power/pm_qos_interface.txt too
of course.

johannes
