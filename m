Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.233]:50086 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYDDVf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 17:35:58 -0400
Received: by qb-out-0506.google.com with SMTP id e11so94166qbe.15
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2008 14:35:55 -0700 (PDT)
Message-ID: <b3153e950804041435p7233fe3bn23bc017967687e9a@mail.gmail.com> (sfid-20080404_223604_229876_F738D251)
Date: Fri, 4 Apr 2008 14:35:55 -0700
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: notify mac from low level driver (iwlwifi)
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Mohamed Abbas" <mabbas@linux.intel.com>
In-Reply-To: <1207320389.19189.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
	 <1207264130-25437-2-git-send-email-reinette.chatre@intel.com>
	 <1207320389.19189.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/4/08, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > + * This function must be called by low level driver to inform mac80211 of
> > + * low level driver status change or force mac80211 to re-assoc for low
> > + * level driver internal error that require re-assoc. A good example to use
> > + * this notification to call mac80211 after suspend/resume, some NIC require
> > + * re-assoc.
>
> I think the suspend/resume text should be dropped since IMHO that
> requires more work, reprogramming all the hardware crypto keys for
> example.
I can remove the suspend/resume text will be that good enough?
>
> > +                     /* No need to wake the master device. */
> > +                     if (sdata->dev == local->mdev)
> > +                             continue;
>
> That looks like a copy&paste bug, we're not waking it in any way. Also,
> it's of IF_TYPE_AP so it's not necessary to test this at all.
>
you are right it is a copy&paste from other part in mac80211, but as
you mentioned this an extra filtering which is not needed. I will
remove it and resubmit again.
> johannes
>
>
