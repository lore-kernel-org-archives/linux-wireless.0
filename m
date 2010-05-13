Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33475 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab0EMW6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 18:58:02 -0400
Received: by wyb32 with SMTP id 32so1319783wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 15:58:01 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1273788932.7796.376.camel@rchatre-DESK>
References: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
	 <AANLkTilm7VDQkXBMWUeRtH634oq9i9AdUIsv6V3woRH_@mail.gmail.com>
	 <1273788932.7796.376.camel@rchatre-DESK>
Date: Fri, 14 May 2010 00:58:00 +0200
Message-ID: <AANLkTilireLxaN70NBPVqZwugHoKk1Iy2_I-cg0ev2oq@mail.gmail.com>
Subject: Re: [PATCH 0/2] iwlwifi fixes for 2.6.34
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, I was confused by the comments in [1] and I am especially
interested in the internal scans stuff:

Port following patch to 3945.

"commit 90c4162ff59a3281b6d2f7206740be6217bd6758
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Apr 7 00:21:36 2010 -0700
    iwlwifi: fix scan races"

The above mentionned patch is already accepted to upstream (2.6.34)
[2] and iwlagn _is_ already using internal scans. So why is iwl3945
different in 2.6.34 especially in that case?

On first sight, I can't see the correlation of "iwl3945: add plcp
error checking" [3] and "iwl3945: fix scan races" [1].

- Sedat -

[1] https://patchwork.kernel.org/patch/98326/
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=88be026490ed89c2ffead81a52531fbac5507e01
[3] http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commit;h=a29576a7844326c5223f4d4adbfd3f4d64173d4c

On Fri, May 14, 2010 at 12:15 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Thu, 2010-05-13 at 14:54 -0700, Sedat Dilek wrote:
>> Whats with "iwl3945: fix scan races"?
>
> hmmm ... cryptic indeed ... I assume you are asking "Why is "iwl3945:
> fix scan races" not part of a submission to 2.6.34?
>
> If that is the case then yes, indeed , we did not submit "iwl3945: fix
> scan races" to 2.6.34 since the scan races being fixed is between normal
> (mac80211 initiated) and internal (as part of rf reset) scans. Like I
> mention in the cover letter of the submission that includes that patch
> (http://thread.gmane.org/gmane.linux.kernel.wireless.general/50651 ) we
> introduce RF reset usage to 3945 through the new "plcp error checking"
> patch and thus need the scan races fix for that. Before that patch
> nothing in iwl3945 was using RF reset and thus no internal scanning that
> could trigger a race.
>
> Reinette
>
>
>
>
>
