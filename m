Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab3IML2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 07:28:07 -0400
Date: Fri, 13 Sep 2013 13:26:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/5] mac80211: add generic quiesce procedure
Message-ID: <20130913112608.GA27628@redhat.com> (sfid-20130913_132815_972577_F5672294)
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
 <1379068568-27552-5-git-send-email-sgruszka@redhat.com>
 <1379070837.14883.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379070837.14883.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 13, 2013 at 01:13:57PM +0200, Johannes Berg wrote:
> On Fri, 2013-09-13 at 12:36 +0200, Stanislaw Gruszka wrote:
> > Add function ieee80211_quiesce() end export it to allow be used by
> > drivers. It is intended to be used before restart_hw to stop mac80211
> > timers/works . Reverse quiesce on ieee80211_reconfig().
> 
> Why can't this be done inside restart_hw()?

iwlwifi stop device before call restart_hw() and we need to
quiesce before iwlwifi stop device (like done in patch 5).

Stanislaw
