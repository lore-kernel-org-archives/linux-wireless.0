Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2HAPyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:54:07 -0400
Message-ID: <1343836438.4638.5.camel@jlt3.sipsolutions.net> (sfid-20120801_175412_359524_458C7981)
Subject: Re: assert_cfg80211_lock warning with Linux v3.5-8833-g2d53492
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>
Date: Wed, 01 Aug 2012 17:53:58 +0200
In-Reply-To: <5019506C.6020707@broadcom.com>
References: <20120801131232.GA1785@zod.bos.redhat.com>
	 <20120801141810.GB27433@tuxdriver.com> <50194D7A.6060400@broadcom.com>
	 <5019506C.6020707@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 17:51 +0200, Arend van Spriel wrote:
> On 08/01/2012 05:38 PM, Arend van Spriel wrote:
> >> brcmsmac needs to hold cfg80211_mutex before calling freq_reg_info...
> >> > 
> >> > It looks like those calls were added in mid-June.
> >> > 
> > I think mid-june sounds about right. We never observed the warning when
> > changes to use regulatory infrastructure were tested/reviewed. Should
> > this precondition be mentioned in cfg80211.h?
> > 
> > Gr. AvS
> 
> Diving in further it seems brcmsmac can not grab the cfg80211_mutex. So
> another solution is needed.

Yeah I was going to say -- how can it possibly access that? It seems
that in some patch the API got broken, it should be taking the lock or
whatever ... I'll leave it to Luis to sort out though :-P

johannes

