Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaCGSUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 13:20:47 -0500
Message-ID: <1394216443.4653.17.camel@jlt4.sipsolutions.net> (sfid-20140307_192056_335447_6524DC46)
Subject: Re: [RFC PATCH 6/8] nl80211: Support for 5/10 MHz channels when
 reporting BW restrictions
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
	s.sander@nordsys.de, jan-niklas.meier@volkswagen.de
Date: Fri, 07 Mar 2014 19:20:43 +0100
In-Reply-To: <1394213496.25640.4.camel@umadbro> (sfid-20140307_183143_827312_15997133)
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1394199475-5208-7-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140307_143812_856469_1F424A6E) <1394202590.4653.8.camel@jlt4.sipsolutions.net>
	 <1394213496.25640.4.camel@umadbro> (sfid-20140307_183143_827312_15997133)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 18:31 +0100, Rostislav Lisovy wrote:
> On Fri, 2014-03-07 at 15:29 +0100, Johannes Berg wrote:
> > This is the part of the code that I was referring to before, you
> > should
> > skip these channels if (!large) to not break older tools with too much
> > data.
> 
> The whole channel (not only these attributes) should be excluded if the
> 'split wiphy info' is not supported? I thought that reporting these
> attributes only 'if (large)' is a safe solution (except the userspace
> will be lacking some information).

The issue is that if all those channels are included, the data is
guaranteed to become too large, and nothing will be shown in those older
tools at all. So it's safer to just skip those channels that the old
tools won't be able to use anyway.

johannes

