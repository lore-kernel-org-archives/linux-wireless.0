Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:63787 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYDDXeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 19:34:07 -0400
Received: by wf-out-1314.google.com with SMTP id 28so300042wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2008 16:34:06 -0700 (PDT)
Message-ID: <b3153e950804041634k2c3fd960h3e118deb7c42f0e7@mail.gmail.com> (sfid-20080405_003411_745001_98DF8E31)
Date: Fri, 4 Apr 2008 16:34:06 -0700
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: notify mac from low level driver (iwlwifi)
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Mohamed Abbas" <mabbas@linux.intel.com>
In-Reply-To: <1207345183.3625.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
	 <1207264130-25437-2-git-send-email-reinette.chatre@intel.com>
	 <1207320389.19189.30.camel@johannes.berg>
	 <b3153e950804041435p7233fe3bn23bc017967687e9a@mail.gmail.com>
	 <1207345183.3625.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/4/08, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2008-04-04 at 14:35 -0700, mohamed salim abbas wrote:
> > On 4/4/08, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >
> > > > + * This function must be called by low level driver to inform mac80211 of
> > > > + * low level driver status change or force mac80211 to re-assoc for low
> > > > + * level driver internal error that require re-assoc. A good example to use
> > > > + * this notification to call mac80211 after suspend/resume, some NIC require
> > > > + * re-assoc.
> > >
> > > I think the suspend/resume text should be dropped since IMHO that
> > > requires more work, reprogramming all the hardware crypto keys for
> > > example.
>
> > I can remove the suspend/resume text will be that good enough?
>
> Sure. I hope at some point somebody will implement proper suspend/resume
> (i.e. when the suspend callback is invoked all interfaces, stations,
> keys etc. are removed from the driver) but that's a lot more work. That
> you mention suspend/resume though makes me wonder: does iwlwifi store
> all that information locally and restore it to the hardware so that it
> can actually work with this across suspend/resume? For b43, I at least
> need to reset all WEP keys.

for iwl the driver on suspend behave like the device is going down, on
resume the driver reload the firmware and start fresh. the driver does
save some data to restore on resume.
I guess we can enhance on this to handle more scenario, but atleast
this is good enough for iwl driver.

>
> Thanks,
> johannes
>
>
