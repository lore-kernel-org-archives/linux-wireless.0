Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027AbZBJWyf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 17:54:35 -0500
Subject: Re: [PATCH v2] ipw2x00: age scan results on resume
From: reinette chatre <reinette.chatre@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1234303830.15997.27.camel@localhost>
References: <1234303830.15997.27.camel@localhost>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 14:58:19 -0800
Message-Id: <1234306699.1626.34.camel@rc-desk> (sfid-20090210_235439_636940_9F4EBC53)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-10 at 14:10 -0800, Dan Williams wrote:
> Scanned BSS entries are timestamped with jiffies, which doesn't
> increment across suspend and hibernate.  On resume, every BSS in the
> scan list looks like it was scanned within the last 10 seconds,
> irregardless of how long the machine was actually asleep.  Age scan
> results on resume with the time spent during sleep so userspace has a
> clue how old they really are.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>
> ---
> This fixes NetworkManager and wpa_supplicant trying to connect to the AP
> associated with at suspend/hibernate time, which clearly may not exist
> at the location where the machine is waking up.
> 
> v2: always set suspend_at

Thank you.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


