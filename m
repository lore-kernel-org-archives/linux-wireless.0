Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab1F0Imt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 04:42:49 -0400
Subject: Re: [PATCH 18/25] iwlagn: warn about nested SYNC commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1309164053.3911.3.camel@jlt3.sipsolutions.net> (sfid-20110627_104220_919345_63C0C0BA)
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1308411271-26093-19-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110618_180558_166798_E27083E7)  <1309164053.3911.3.camel@jlt3.sipsolutions.net>
	 (sfid-20110627_104220_919345_63C0C0BA)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 10:42:52 +0200
Message-ID: <1309164172.3911.4.camel@jlt3.sipsolutions.net> (sfid-20110627_105905_549661_DC1D8462)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-27 at 10:40 +0200, Johannes Berg wrote:
> On Sat, 2011-06-18 at 08:34 -0700, Wey-Yi Guy wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > Since there is no protection around SYNC host command mechanism, at least WARN
> > when collision happens between two SYNC host comamnds. I am not sure there is a
> > real  issue (beyond the HCMD_ACTIVE flag maintenance) with having two SYNC host
> > commands at the same time, but at least now, we will know about it.
> 
> Please drop this particular patch. We discussed this but then forgot
> about it -- this patch only warns when collisions actually happen, but
> we can use lockdep to warn when collisions _could_ happen as well.

Oops, n/m, I see it's already in. Will submit a follow-up that puts
better code in place instead.

johannes

