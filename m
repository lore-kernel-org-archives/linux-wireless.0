Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:34739 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYDDXzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 19:55:17 -0400
Received: by wf-out-1314.google.com with SMTP id 28so307477wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2008 16:55:17 -0700 (PDT)
Message-ID: <b3153e950804041655q6a0c97fay3be5073f02ee9904@mail.gmail.com> (sfid-20080405_005530_329557_5DECEEEB)
Date: Fri, 4 Apr 2008 16:55:17 -0700
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: notify mac from low level driver (iwlwifi)
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Mohamed Abbas" <mabbas@linux.intel.com>
In-Reply-To: <1207352845.6675.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
	 <1207264130-25437-2-git-send-email-reinette.chatre@intel.com>
	 <1207320389.19189.30.camel@johannes.berg>
	 <b3153e950804041435p7233fe3bn23bc017967687e9a@mail.gmail.com>
	 <1207345183.3625.18.camel@johannes.berg>
	 <b3153e950804041634k2c3fd960h3e118deb7c42f0e7@mail.gmail.com>
	 <1207352845.6675.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/4/08, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > for iwl the driver on suspend behave like the device is going down, on
> > resume the driver reload the firmware and start fresh. the driver does
> > save some data to restore on resume.
>
> Right, I think most drivers/hw behave that way.
>
> > I guess we can enhance on this to handle more scenario, but atleast
> > this is good enough for iwl driver.
>
> What happens, for example, when you enable hardware crypto and set a WEP
> key? With b43, after suspend/resume, mac80211 and the driver think the
> key is set in hardware, but it was obviously cleared. It would of course
> be possible to handle that in the driver, but I'd prefer it to be done
> in mac80211 because then the driver doesn't need all the extra code.
>
> johannes
>
>
That exactly what I think should happen and that why iwl need to
notify the mac80211 to re-associate again, we can have the driver do
that but it is cleaner and ii is more safe to have mac80211 to drive
thing than have the driver try extra hard to restore to pre-suspend. I
never involved in the security part of the driver so I need to look it
up.
