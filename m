Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaAVIxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 03:53:36 -0500
Message-ID: <1390380813.4334.5.camel@jlt4.sipsolutions.net> (sfid-20140122_095338_928834_01181664)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 09:53:33 +0100
In-Reply-To: <CA+BoTQ=sWMSN5NveRf0aw98mMYWks2eXKWzZvk4NZgGLOctuQQ@mail.gmail.com> (sfid-20140122_073624_359003_A16909B4)
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	 <1390319550.6199.59.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=sWMSN5NveRf0aw98mMYWks2eXKWzZvk4NZgGLOctuQQ@mail.gmail.com>
	 (sfid-20140122_073624_359003_A16909B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 07:36 +0100, Michal Kazior wrote:

> >> +     if (!attrs[NL80211_ATTR_IFINDEX])
> >> +             return -EINVAL;
> >
> > Hmm, shouldn't you use the ifindex from the csa_attrs? Or are you
> > requiring one to be in the outer data to identify the wiphy? But that
> > seems odd too, you can just get the wiphy in whatever way by asking the
> > pre_doit for that?
> 
> I'm not sure I understand you.
> 
> There are two command variants now:
> 
> 1: the old one, which has ifindex in the root
> 2: the new one, which has wiphy in the root, and an array of (1)
> within CH_SWITCH_IFACES (and each entry has ifindex at its root)

Yeah I think I confused the two. This is handling case 1 only, right?
But you have to check the ifindex manually since for case 2 you can only
require the pre_doit() to give you the wiphy.

johannes

