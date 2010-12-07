Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0LGU55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:57:57 -0500
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	"pstew@google.com" <pstew@google.com>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <AANLkTik-H0WXWjGjMuc_pE1vvbxFSoD2BoXVG3Wqcorw@mail.gmail.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
	 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com>
	 <1291714709.3607.2.camel@jlt3.sipsolutions.net>
	 <AANLkTikrLweKeSR-=XziaJ5rqDRf_Ny=mg1OD=jC4nqA@mail.gmail.com>
	 <1291736887.3607.47.camel@jlt3.sipsolutions.net>
	 <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
	 <1291737298.3607.48.camel@jlt3.sipsolutions.net>
	 <20101207155916.GA1855@tux>
	 <1291743121.3607.50.camel@jlt3.sipsolutions.net>
	 <AANLkTi=Sj7YpKzFHQtf2MdUcRDTzfXszbK7gGg_yup1Y@mail.gmail.com>
	 <1291745567.3607.52.camel@jlt3.sipsolutions.net>
	 <AANLkTimfLGj1=BnRGvJVkP_Ge6KYAtCLcDpBsVoj9o_T@mail.gmail.com>
	 <1291755274.3607.59.camel@jlt3.sipsolutions.net>
	 <AANLkTik-H0WXWjGjMuc_pE1vvbxFSoD2BoXVG3Wqcorw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 21:57:52 +0100
Message-ID: <1291755472.3607.60.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 12:56 -0800, Luis R. Rodriguez wrote:

> > Not really, since we do scan_cancel() within suspend()... I guess I'd
> > like to find out why that doesn't do what I think it does.
> 
> Well lets see, this is only reproducible with the new DBUS APIs, and
> frankly I am not sure what these things do. Is it possible we have a
> race between how it brings down an interface for suspend and canceling
> a scan?

But both suspend and do_stop should run under RTNL.

johannes

