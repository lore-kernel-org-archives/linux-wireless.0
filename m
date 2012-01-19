Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2ASSGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 13:06:09 -0500
Subject: Re: [PATCH 2/2] mac80211: make CQM RSSI support per virtual
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CA+XVXff7LdscHL046d0h=s7W9b-YdfLa24EVSed9yrdv0OU75A@mail.gmail.com> (sfid-20120119_183740_990346_DEE58B30)
References: <20120119082956.486569312@sipsolutions.net>
	 <20120119083102.873553392@sipsolutions.net>
	 <CA+XVXff7LdscHL046d0h=s7W9b-YdfLa24EVSed9yrdv0OU75A@mail.gmail.com>
	 (sfid-20120119_183740_990346_DEE58B30)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 19:06:04 +0100
Message-ID: <1326996364.3631.9.camel@jlt3.sipsolutions.net> (sfid-20120119_190613_833234_37F3DEE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-19 at 19:36 +0200, Arik Nemtsov wrote:
> On Thu, Jan 19, 2012 at 10:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Similar to the previous beacon filtering patch,
> > make CQM RSSI support depend on the flags that
> > the driver set for virtual interfaces.
> 
> Up until now we circumvented the issue by having mode specific HW
> flags (e.g. IEEE80211_HW_AP_LINK_PS). Usually the mode of the FW
> determines the HW capabilities and this is enough.
> It also has the advantages of only touching mode-specific code-paths.
> 
> Since this is a STA-mode only flag I assume this is something for
> multi-role (multiple stations)?

Yes. I don't know how your multi-role support works, but I'm not really
comfortable with changing the HW flags on the fly (it will work for
these, but not really for many others I think).

johannes

