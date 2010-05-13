Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0EMXQk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 19:16:40 -0400
Subject: Re: [PATCH 0/2] iwlwifi fixes for 2.6.34
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTilireLxaN70NBPVqZwugHoKk1Iy2_I-cg0ev2oq@mail.gmail.com>
References: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
	 <AANLkTilm7VDQkXBMWUeRtH634oq9i9AdUIsv6V3woRH_@mail.gmail.com>
	 <1273788932.7796.376.camel@rchatre-DESK>
	 <AANLkTilireLxaN70NBPVqZwugHoKk1Iy2_I-cg0ev2oq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 16:16:38 -0700
Message-ID: <1273792598.7796.454.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sedat,

On Thu, 2010-05-13 at 15:58 -0700, Sedat Dilek wrote:
> Sorry, I was confused by the comments in [1] and I am especially
> interested in the internal scans stuff:
> 
> Port following patch to 3945.

Yeah ... in retrospect that commit message could benefit with the
details on why it is needed. Sorry for the confusion. It is indeed a
port of the iwlagn patch since iwlagn used internal scanning long before
iwl3945 and the race was thus fixed there first. The same fix was not
done at that time for iwl3945 since it (iwl3945) was not using internal
scanning.

> 
> "commit 90c4162ff59a3281b6d2f7206740be6217bd6758
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Apr 7 00:21:36 2010 -0700
>     iwlwifi: fix scan races"
> 
> The above mentionned patch is already accepted to upstream (2.6.34)
> [2] and iwlagn _is_ already using internal scans.

Right.

>  So why is iwl3945
> different in 2.6.34 especially in that case?

In 2.6.34 iwl3945 never calls RF reset, which triggers an internal scan.
In 2.6.34 iwlagn calls RF reset if the information received in
statistics notification warrants it. This feature is added to iwl3945 in
2.6.35 with [3].

> On first sight, I can't see the correlation of "iwl3945: add plcp
> error checking" [3] and "iwl3945: fix scan races" [1].

Note that [3] adds a value (and implementation behind that value) to the
check_plcp_health function pointer, which is called from
iwl_recover_from_statistics() which is for the first time made available
to iwl3945 in this patch also (see changes to iwl-rx.c).  It is
iwl_recover_from_statistics() that uses statistic information (now
available via the new check_plcp_health function) to decide if an RF
reset is needed. Before this patch iwl3945 merely recorded received
statistics, it never made decisions based on the information contained
in it. This patch introduces the logic to use statistics information to
decide if an RF reset is needed and will trigger and RF reset if needed.

Now, an RF reset is done via an internal scan and before [3] there was
nothing in iwl3945 that triggered an internal scan. We do have issues
with internal scanning, but they were not all addressed for iwl3945
since iwl3945 was not using internal scanning. With [3] we introduced
usage of internal scanning so needed to make sure that the internal scan
races are fixed for it also which was done with [1].


> [1] https://patchwork.kernel.org/patch/98326/
> [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=88be026490ed89c2ffead81a52531fbac5507e01
> [3] http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commit;h=a29576a7844326c5223f4d4adbfd3f4d64173d4c

Reinette


