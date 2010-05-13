Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503Ab0EMWPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 18:15:33 -0400
Subject: Re: [PATCH 0/2] iwlwifi fixes for 2.6.34
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTilm7VDQkXBMWUeRtH634oq9i9AdUIsv6V3woRH_@mail.gmail.com>
References: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
	 <AANLkTilm7VDQkXBMWUeRtH634oq9i9AdUIsv6V3woRH_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 15:15:32 -0700
Message-ID: <1273788932.7796.376.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-13 at 14:54 -0700, Sedat Dilek wrote:
> Whats with "iwl3945: fix scan races"?

hmmm ... cryptic indeed ... I assume you are asking "Why is "iwl3945:
fix scan races" not part of a submission to 2.6.34?

If that is the case then yes, indeed , we did not submit "iwl3945: fix
scan races" to 2.6.34 since the scan races being fixed is between normal
(mac80211 initiated) and internal (as part of rf reset) scans. Like I
mention in the cover letter of the submission that includes that patch
(http://thread.gmane.org/gmane.linux.kernel.wireless.general/50651 ) we
introduce RF reset usage to 3945 through the new "plcp error checking"
patch and thus need the scan races fix for that. Before that patch
nothing in iwl3945 was using RF reset and thus no internal scanning that
could trigger a race.

Reinette




