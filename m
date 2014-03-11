Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58417 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaCKNOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 09:14:14 -0400
Message-ID: <1394543651.30155.3.camel@jlt4.sipsolutions.net> (sfid-20140311_141424_257671_592B601E)
Subject: Re: [PATCH] mac80211: fix possible NULL dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 11 Mar 2014 15:14:11 +0200
In-Reply-To: <CA+BoTQkVfgkMR_cvv5dUNkzLd7KrDQ7VMYKucJybpF0aAWpESA@mail.gmail.com> (sfid-20140311_123032_763427_A6F329EF)
References: <1394176178-8504-1-git-send-email-michal.kazior@tieto.com>
	 <CA+BoTQkVfgkMR_cvv5dUNkzLd7KrDQ7VMYKucJybpF0aAWpESA@mail.gmail.com>
	 (sfid-20140311_123032_763427_A6F329EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 12:30 +0100, Michal Kazior wrote:
> On 7 March 2014 08:09, Michal Kazior <michal.kazior@tieto.com> wrote:
> > If chanctx is missing on a given vif then the band
> > is assumed to be 2GHz. However if hw doesn't
> > support 2GHz band then mac80211 ended up with a
> > NULL dereference.

> Drop this, please. There are more places that need sband to be
> NULL-checked. I'll send out a more thorough patch later.

Ok. However, I'm not sure that we should ever really run into this? At
least with Luca's patches we want to not go through NULL state to start
with.

johannes

